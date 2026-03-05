from pathlib import Path
import shutil
import zipfile
import xml.etree.ElementTree as ET


NS = {"w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main"}


def qn(name: str) -> str:
    prefix, local = name.split(":")
    return f"{{{NS[prefix]}}}{local}"


def ensure_child(parent: ET.Element, name: str) -> ET.Element:
    child = parent.find(name, NS)
    if child is None:
        child = ET.SubElement(parent, qn(name))
    return child


def bold_runs(container: ET.Element) -> None:
    for run in container.findall(".//w:r", NS):
        rpr = ensure_child(run, "w:rPr")
        ensure_child(rpr, "w:b")
        ensure_child(rpr, "w:bCs")


def right_align_paragraphs(container: ET.Element) -> None:
    for para in container.findall("w:p", NS):
        ppr = ensure_child(para, "w:pPr")
        jc = ensure_child(ppr, "w:jc")
        jc.set(qn("w:val"), "right")


def set_paragraph_style(para: ET.Element, style_name: str) -> None:
    ppr = ensure_child(para, "w:pPr")
    style = ensure_child(ppr, "w:pStyle")
    style.set(qn("w:val"), style_name)


def paragraph_style(para: ET.Element) -> str | None:
    ppr = para.find("w:pPr", NS)
    if ppr is None:
        return None
    style = ppr.find("w:pStyle", NS)
    if style is None:
        return None
    return style.get(qn("w:val"))


def is_blank_paragraph(para: ET.Element) -> bool:
    text = "".join(node.text or "" for node in para.findall(".//w:t", NS))
    return text.strip() == ""


def make_spacer_paragraph() -> ET.Element:
    para = ET.Element(qn("w:p"))
    ppr = ET.SubElement(para, qn("w:pPr"))
    spacing = ET.SubElement(ppr, qn("w:spacing"))
    spacing.set(qn("w:before"), "0")
    spacing.set(qn("w:after"), "0")
    spacing.set(qn("w:line"), "276")
    spacing.set(qn("w:lineRule"), "auto")
    run = ET.SubElement(para, qn("w:r"))
    text = ET.SubElement(run, qn("w:t"))
    text.text = " "
    return para


def process_docx(path: Path) -> None:
    tmp_dir = Path("/tmp/quartocv_public_docx_post")
    if tmp_dir.exists():
        shutil.rmtree(tmp_dir)
    tmp_dir.mkdir(parents=True)

    with zipfile.ZipFile(path) as zf:
        zf.extractall(tmp_dir)

    ET.register_namespace("w", NS["w"])
    ET.register_namespace("r", "http://schemas.openxmlformats.org/officeDocument/2006/relationships")

    document_path = tmp_dir / "word" / "document.xml"
    tree = ET.parse(document_path)
    root = tree.getroot()
    body = root.find("w:body", NS)

    for para in root.findall(".//w:p", NS):
        if paragraph_style(para) == "Heading1":
            ppr = ensure_child(para, "w:pPr")
            ind = ppr.find("w:ind", NS)
            if ind is not None:
                ppr.remove(ind)
            ET.SubElement(ppr, qn("w:ind"), {qn("w:left"): "0", qn("w:hanging"): "0"})
            spacing = ppr.find("w:spacing", NS)
            if spacing is not None:
                ppr.remove(spacing)
            ET.SubElement(ppr, qn("w:spacing"), {
                qn("w:before"): "200", qn("w:after"): "40", qn("w:line"): "220", qn("w:lineRule"): "auto"
            })

    children = list(body)
    insertions: list[tuple[int, ET.Element]] = []
    for idx, child in enumerate(children):
        if child.tag != qn("w:tbl"):
            continue
        if idx == 0:
            continue
        prev = children[idx - 1]
        if prev.tag == qn("w:p"):
            style = paragraph_style(prev)
            if style in ("Heading1", "Heading2"):
                continue
            if style == "BodyText" and is_blank_paragraph(prev):
                continue
        insertions.append((idx, make_spacer_paragraph()))

    for offset, (idx, spacer) in enumerate(insertions):
        body.insert(idx + offset, spacer)

    for table in root.findall(".//w:tbl", NS):
        tbl_pr = ensure_child(table, "w:tblPr")
        tbl_w = ensure_child(tbl_pr, "w:tblW")
        tbl_w.set(qn("w:type"), "pct")
        tbl_w.set(qn("w:w"), "10000")

        layout = ensure_child(tbl_pr, "w:tblLayout")
        layout.set(qn("w:type"), "fixed")

        tbl_grid = table.find("w:tblGrid", NS)
        if tbl_grid is not None:
            cols = tbl_grid.findall("w:gridCol", NS)
            if len(cols) == 2:
                cols[0].set(qn("w:w"), "8070")
                cols[1].set(qn("w:w"), "3000")

        for row in table.findall("w:tr", NS):
            cells = row.findall("w:tc", NS)
            if len(cells) < 2:
                continue
            if row is table.find("w:tr", NS):
                for para in cells[0].findall("w:p", NS):
                    set_paragraph_style(para, "Heading2")
                    ppr = ensure_child(para, "w:pPr")
                    ind = ppr.find("w:ind", NS)
                    if ind is not None:
                        ppr.remove(ind)
                    ET.SubElement(ppr, qn("w:ind"), {qn("w:left"): "0", qn("w:hanging"): "0"})
            right_cell = cells[-1]
            right_align_paragraphs(right_cell)
            bold_runs(right_cell)

    tree.write(document_path, encoding="UTF-8", xml_declaration=True)

    rebuilt = path.with_suffix(".tmp.docx")
    if rebuilt.exists():
        rebuilt.unlink()
    with zipfile.ZipFile(rebuilt, "w", zipfile.ZIP_DEFLATED) as zf:
        for file_path in sorted(tmp_dir.rglob("*")):
            if file_path.is_file():
                zf.write(file_path, file_path.relative_to(tmp_dir))

    rebuilt.replace(path)


if __name__ == "__main__":
    process_docx(Path("FinalProducts/WordResume.docx"))
