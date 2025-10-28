#!/usr/bin/env python3
"""
Simple DOCX -> Markdown converter using mammoth to HTML and html2text to markdown.
Creates `VAL_DCN_OCS_CPM.md` next to the input docx.
"""
import sys
from pathlib import Path

try:
    import mammoth
except ImportError:
    print("Missing dependency 'mammoth'. Install with: pip install mammoth html2text", file=sys.stderr)
    sys.exit(2)

try:
    import html2text
except ImportError:
    print("Missing dependency 'html2text'. Install with: pip install mammoth html2text", file=sys.stderr)
    sys.exit(2)


def convert(docx_path: Path) -> Path:
    out_md = docx_path.with_suffix('.md')
    with docx_path.open('rb') as f:
        result = mammoth.convert_to_html(f)
        html = result.value  # The generated HTML
        messages = result.messages

    if messages:
        print('Mammoth messages:')
        for m in messages:
            print('-', m)

    h = html2text.HTML2Text()
    h.body_width = 0
    md = h.handle(html)

    # Basic cleanup: strip trailing spaces
    md = md.strip() + '\n'

    out_md.write_text(md, encoding='utf-8')
    return out_md


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('Usage: convert_docx_to_md.py <path/to/file.docx>', file=sys.stderr)
        sys.exit(2)

    p = Path(sys.argv[1])
    if not p.exists():
        print(f'File not found: {p}', file=sys.stderr)
        sys.exit(2)

    out = convert(p)
    print(f'Wrote: {out}')
