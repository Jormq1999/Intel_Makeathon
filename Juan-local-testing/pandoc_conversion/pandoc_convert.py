#!/usr/bin/env python3
"""
Pandoc-based DOCX -> Markdown converter.

Usage:
    python pandoc_convert.py /path/to/file.docx

Behavior:
 - Tries to use pypandoc (Python wrapper). If not installed, falls back to calling the `pandoc` CLI.
 - Writes output as the same basename with `.md` in the same directory as the input DOCX.
 - Exits with non-zero code on error and prints helpful diagnostics.
"""
import os
import sys
import shutil
from pathlib import Path


def convert_with_pypandoc(input_path: Path, output_path: Path) -> None:
    try:
        import pypandoc
    except Exception as e:
        raise RuntimeError(f"pypandoc not available: {e}")

    # pypandoc may require pandoc installed; it wraps the pandoc binary
    try:
        pypandoc.convert_file(str(input_path), 'gfm', outputfile=str(output_path))
    except Exception as e:
        raise RuntimeError(f"pypandoc conversion failed: {e}")


def convert_with_cli(input_path: Path, output_path: Path) -> None:
    pandoc = shutil.which('pandoc')
    if not pandoc:
        raise RuntimeError('pandoc CLI not found on PATH; install pandoc or install pypandoc')

    cmd = [pandoc, '-s', str(input_path), '-t', 'gfm', '-o', str(output_path)]
    rc = os.system(' '.join(f'"{c}"' for c in cmd))
    if rc != 0:
        raise RuntimeError(f'pandoc CLI failed with exit code {rc}')


def main():
    if len(sys.argv) != 2:
        print('Usage: pandoc_convert.py /path/to/file.docx', file=sys.stderr)
        sys.exit(2)

    inp = Path(sys.argv[1])
    if not inp.exists():
        print(f'Input not found: {inp}', file=sys.stderr)
        sys.exit(2)

    out = inp.with_suffix('.md')

    # Try pypandoc first
    try:
        convert_with_pypandoc(inp, out)
        print(f'Wrote (pypandoc): {out}')
        return
    except Exception as e:
        print(f'[INFO] pypandoc not used: {e}')

    # Fallback to CLI
    try:
        convert_with_cli(inp, out)
        print(f'Wrote (pandoc CLI): {out}')
        return
    except Exception as e:
        print(f'[ERROR] pandoc CLI not available or failed: {e}', file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
