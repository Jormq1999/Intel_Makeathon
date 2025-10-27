#!/usr/bin/env python3
"""
docx_to_md.py
Converts a .docx to Markdown, extracting images into ./media
Usage: python docx_to_md.py input.docx output.md
"""
import sys
import os
import uuid
import mammoth
from markdownify import markdownify as md

def convert(input_path, output_path):
    os.makedirs("media", exist_ok=True)
    def convert_image(image):
        ext = image.content_type.split("/")[-1]
        filename = f"media/{uuid.uuid4().hex}.{ext}"
        with open(filename, "wb") as f:
            f.write(image.read())
        return {"src": filename}

    with open(input_path, "rb") as docx_file:
        result = mammoth.convert_to_html(
            docx_file,
            convert_image=mammoth.images.inline(convert_image)
        )
        html = result.value
        if result.messages:
            for m in result.messages:
                print("Mammoth message:", m)
        markdown = md(html, heading_style="ATX")
        with open(output_path, "w", encoding="utf-8") as out:
            out.write(markdown)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python docx_to_md.py input.docx output.md")
        sys.exit(1)
    convert(sys.argv[1], sys.argv[2])