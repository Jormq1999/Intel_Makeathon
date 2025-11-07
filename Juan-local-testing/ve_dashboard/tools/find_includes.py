#!/usr/bin/env python3
"""
find_includes.py

Recursively searches a project directory for SystemVerilog `include "..."` directives
and prints a grouped mapping: included_file <- including_file:line_number : line

Usage:
    python3 find_includes.py /path/to/project

"""
import os
import re
import sys
from collections import defaultdict

INCLUDE_RE = re.compile(r'`include\s*"([^"]+)"')
TEXT_EXTS = {'.sv', '.v', '.vh', '.svh', '.svt', '.vhf', '.vhpp'}


def scan_project(project_path):
    mapping = defaultdict(list)
    for root, dirs, files in os.walk(project_path):
        for fname in files:
            _, ext = os.path.splitext(fname)
            if ext.lower() in TEXT_EXTS or fname.endswith('.svs') or fname.endswith('.svm'):
                full = os.path.join(root, fname)
                rel = os.path.relpath(full, project_path)
                try:
                    with open(full, 'r', errors='ignore') as f:
                        for i, line in enumerate(f, start=1):
                            m = INCLUDE_RE.search(line)
                            if m:
                                included = m.group(1)
                                mapping[included].append((rel, i, line.rstrip('\n')))
                except Exception:
                    # skip unreadable files
                    pass
    return mapping


def print_mapping(mapping):
    if not mapping:
        print('No `include` directives found.')
        return
    for included, uses in sorted(mapping.items()):
        print(f'Included file: {included}')
        for rel, lineno, line in uses:
            print(f'  - {rel}:{lineno}: {line.strip()}')
        print()


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python3 find_includes.py /path/to/project')
        sys.exit(2)
    proj = sys.argv[1]
    if not os.path.isdir(proj):
        print('Project path not found:', proj)
        sys.exit(2)
    mapping = scan_project(proj)
    print_mapping(mapping)
