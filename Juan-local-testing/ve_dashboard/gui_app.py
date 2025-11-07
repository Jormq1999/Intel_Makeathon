#!/usr/bin/env python3
"""
Simple UNIX-compatible GUI for the VE Dashboard features using Tkinter.
Features:
- Load environments from config.json
- Choose an environment
- Browse DUT/TB/Test files
- Simple search (substring/regex)
- View file contents and delete files
- Show extracted components and a simple dependency viewer

This is intentionally lightweight and synchronous so it's easy to run on Unix desktops.
"""

import os
import json
import re
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
from tkinter.scrolledtext import ScrolledText

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CONFIG_PATH = os.path.join(SCRIPT_DIR, 'config.json')

# Helper functions copied/adapted from dashboard.py

def load_environments():
    try:
        with open(CONFIG_PATH, 'r') as f:
            return json.load(f).get('environments', [])
    except Exception:
        return []


def parse_sv_file(filepath):
    components = []
    try:
        with open(filepath, 'r', errors='ignore') as f:
            content = f.read()
            modules = re.findall(r'^\s*module\s+(\w+)', content, re.MULTILINE)
            classes = re.findall(r'^\s*class\s+(\w+)', content, re.MULTILINE)
            interfaces = re.findall(r'^\s*interface\s+(\w+)', content, re.MULTILINE)
            base_filename = os.path.basename(filepath)
            for name in modules:
                components.append({'type': 'Module', 'name': name, 'file': base_filename})
            for name in classes:
                components.append({'type': 'Class', 'name': name, 'file': base_filename})
            for name in interfaces:
                components.append({'type': 'Interface', 'name': name, 'file': base_filename})
    except Exception:
        pass
    return components


def build_component_index(project_path):
    index = {}
    for root, dirs, files in os.walk(project_path):
        for fname in files:
            if fname.endswith(('.sv', '.v')):
                full = os.path.join(root, fname)
                try:
                    with open(full, 'r', errors='ignore') as f:
                        content = f.read()
                        modules = re.findall(r'^\s*module\s+(\w+)', content, re.MULTILINE)
                        classes = re.findall(r'^\s*class\s+(\w+)', content, re.MULTILINE)
                        interfaces = re.findall(r'^\s*interface\s+(\w+)', content, re.MULTILINE)
                        for m in modules + classes + interfaces:
                            index[m] = os.path.relpath(full, project_path)
                except Exception:
                    pass
    return index


def find_component_usages(project_path, component_names):
    usages = {name: [] for name in component_names}
    if not component_names:
        return usages
    name_pattern = re.compile(r"\b(" + "|".join(re.escape(n) for n in component_names) + r")\b")
    for root, dirs, files in os.walk(project_path):
        for fname in files:
            if fname.endswith(('.sv', '.v', '.vh', '.svh', '.svt', '.h', '.py', '.txt')):
                full = os.path.join(root, fname)
                rel = os.path.relpath(full, project_path)
                try:
                    with open(full, 'r', errors='ignore') as f:
                        for i, line in enumerate(f, start=1):
                            for match in name_pattern.finditer(line):
                                comp = match.group(1)
                                usages[comp].append((rel, i, line.rstrip('\n')))
                except Exception:
                    pass
    return usages


def perform_text_search(project_path, query, use_regex=False, case_sensitive=False):
    results = []
    if not query:
        return results, None
    regex = None
    flags = 0 if case_sensitive else re.IGNORECASE
    if use_regex:
        try:
            regex = re.compile(query, flags)
        except re.error as e:
            return [], f'Regex error: {e}'
    for root, dirs, files in os.walk(project_path):
        for file in files:
            if file.endswith(('.sv', '.v', '.vh', '.svh', '.svt', '.h', '.c', '.py', '.md', '.txt')):
                full_path = os.path.join(root, file)
                try:
                    with open(full_path, 'r', errors='ignore') as f:
                        for i, line in enumerate(f, start=1):
                            hay = line.rstrip('\n')
                            if use_regex:
                                if regex.search(hay):
                                    results.append({'file': os.path.relpath(full_path, project_path), 'line_num': i, 'line_content': hay})
                            else:
                                if case_sensitive:
                                    if query in hay:
                                        results.append({'file': os.path.relpath(full_path, project_path), 'line_num': i, 'line_content': hay})
                                else:
                                    if query.lower() in hay.lower():
                                        results.append({'file': os.path.relpath(full_path, project_path), 'line_num': i, 'line_content': hay})
                except Exception:
                    pass
    return results, None


class VEDashboardGUI(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title('VE Dashboard - Local GUI')
        self.geometry('1000x700')

        self.environments = load_environments()
        self.current_env = None
        self.current_path = None

        self.create_widgets()

    def create_widgets(self):
        left = ttk.Frame(self)
        left.pack(side='left', fill='y', padx=10, pady=10)

        ttk.Label(left, text='Environments').pack(anchor='nw')
        self.env_listbox = tk.Listbox(left, height=10)
        self.env_listbox.pack(fill='y')
        for env in self.environments:
            self.env_listbox.insert('end', env.get('name', 'Unnamed'))
        self.env_listbox.bind('<<ListboxSelect>>', self.on_env_select)

        ttk.Button(left, text='Reload config', command=self.reload_config).pack(fill='x', pady=5)

        mid = ttk.Frame(self)
        mid.pack(side='left', fill='both', expand=True, padx=10, pady=10)

        # Search box
        search_frame = ttk.Frame(mid)
        search_frame.pack(fill='x')
        self.search_var = tk.StringVar()
        ttk.Entry(search_frame, textvariable=self.search_var).pack(side='left', fill='x', expand=True)
        self.regex_var = tk.BooleanVar()
        ttk.Checkbutton(search_frame, text='Regex', variable=self.regex_var).pack(side='left')
        self.case_var = tk.BooleanVar()
        ttk.Checkbutton(search_frame, text='Case', variable=self.case_var).pack(side='left')
        ttk.Button(search_frame, text='Search', command=self.on_search).pack(side='left', padx=4)

        # File lists and components
        panes = ttk.Panedwindow(mid, orient='horizontal')
        panes.pack(fill='both', expand=True, pady=10)

        files_frame = ttk.Labelframe(panes, text='Files')
        panes.add(files_frame, weight=1)
        self.files_tree = ttk.Treeview(files_frame, columns=('type',), show='tree')
        self.files_tree.pack(fill='both', expand=True)
        self.files_tree.bind('<Double-1>', self.on_file_open)

        comp_frame = ttk.Labelframe(panes, text='Components')
        panes.add(comp_frame, weight=1)
        self.comp_tree = ttk.Treeview(comp_frame, columns=('type','file'), show='headings')
        self.comp_tree.heading('type', text='Type')
        self.comp_tree.heading('file', text='File')
        self.comp_tree.pack(fill='both', expand=True)
        self.comp_tree.bind('<Double-1>', self.on_component_select)

        # Bottom: file viewer and actions
        bottom = ttk.Frame(self)
        bottom.pack(side='right', fill='both', expand=True, padx=10, pady=10)
        ttk.Label(bottom, text='File viewer').pack(anchor='nw')
        self.viewer = ScrolledText(bottom, wrap='none', height=20)
        self.viewer.pack(fill='both', expand=True)

        action_frame = ttk.Frame(bottom)
        action_frame.pack(fill='x')
        ttk.Button(action_frame, text='Delete File', command=self.delete_selected_file).pack(side='left')
        ttk.Button(action_frame, text='Show Dependencies', command=self.show_dependencies).pack(side='left')

    def reload_config(self):
        self.environments = load_environments()
        self.env_listbox.delete(0, 'end')
        for env in self.environments:
            self.env_listbox.insert('end', env.get('name', 'Unnamed'))
        messagebox.showinfo('Config', 'Reloaded config.json')

    def on_env_select(self, event=None):
        sel = self.env_listbox.curselection()
        if not sel:
            return
        idx = sel[0]
        env = self.environments[idx]
        self.current_env = env
        self.current_path = env.get('path')
        self.refresh_file_list()
        self.refresh_components()
        self.viewer.delete('1.0','end')

    def refresh_file_list(self):
        self.files_tree.delete(*self.files_tree.get_children())
        if not self.current_path or not os.path.isdir(self.current_path):
            return
        for root, dirs, files in os.walk(self.current_path):
            for f in files:
                rel = os.path.relpath(os.path.join(root, f), self.current_path)
                self.files_tree.insert('', 'end', text=rel)

    def refresh_components(self):
        self.comp_tree.delete(*self.comp_tree.get_children())
        if not self.current_path:
            return
        components = []
        for root, dirs, files in os.walk(self.current_path):
            for f in files:
                full = os.path.join(root, f)
                if f.endswith(('.sv', '.v')):
                    components.extend(parse_sv_file(full))
        for comp in components:
            self.comp_tree.insert('', 'end', values=(comp['type'], comp['file']), text=comp['name'])

    def on_file_open(self, event=None):
        item = self.files_tree.focus()
        if not item:
            return
        filename = self.files_tree.item(item, 'text')
        full = os.path.join(self.current_path, filename)
        try:
            with open(full, 'r', errors='ignore') as f:
                data = f.read()
            self.viewer.delete('1.0','end')
            self.viewer.insert('1.0', data)
        except Exception as e:
            messagebox.showerror('Open', f'Failed to open: {e}')

    def delete_selected_file(self):
        item = self.files_tree.focus()
        if not item:
            messagebox.showwarning('Delete', 'No file selected')
            return
        filename = self.files_tree.item(item, 'text')
        full = os.path.join(self.current_path, filename)
        if not os.path.isfile(full):
            messagebox.showwarning('Delete', 'Selected item is not a regular file')
            return
        if messagebox.askyesno('Delete', f'Are you sure you want to delete {filename}?'):
            try:
                os.remove(full)
                self.refresh_file_list()
                self.refresh_components()
                self.viewer.delete('1.0','end')
                messagebox.showinfo('Delete', 'File deleted')
            except Exception as e:
                messagebox.showerror('Delete', f'Failed to delete: {e}')

    def on_search(self):
        q = self.search_var.get().strip()
        if not q or not self.current_path:
            return
        use_regex = self.regex_var.get()
        case = self.case_var.get()
        results, err = perform_text_search(self.current_path, q, use_regex=use_regex, case_sensitive=case)
        if err:
            messagebox.showerror('Search', err)
            return
        # show results in viewer
        self.viewer.delete('1.0','end')
        if not results:
            self.viewer.insert('1.0', 'No results')
            return
        for r in results:
            self.viewer.insert('end', f"{r['file']}:{r['line_num']} - {r['line_content']}\n")

    def on_component_select(self, event=None):
        item = self.comp_tree.focus()
        if not item:
            return
        name = self.comp_tree.item(item, 'text')
        # find definition file via index
        index = build_component_index(self.current_path)
        defined = index.get(name)
        # show usages
        usages = find_component_usages(self.current_path, [name])
        self.viewer.delete('1.0','end')
        self.viewer.insert('1.0', f"Component: {name}\nDefined in: {defined}\n\nUsages:\n")
        for u in usages.get(name, []):
            self.viewer.insert('end', f"{u[0]}:{u[1]} - {u[2]}\n")

    def show_dependencies(self):
        if not self.current_path:
            return
        index = build_component_index(self.current_path)
        usages = find_component_usages(self.current_path, index.keys())
        out = []
        for comp, def_file in index.items():
            refs = [u for u in usages.get(comp, []) if u[0] != def_file]
            if refs:
                out.append(f"{comp} defined in {def_file} used {len(refs)} times")
        self.viewer.delete('1.0','end')
        if not out:
            self.viewer.insert('1.0', 'No external dependencies found')
        else:
            self.viewer.insert('1.0', '\n'.join(out))


def choose_env_console(environments):
    if not environments:
        print('No environments configured in config.json')
        return None
    print('Available environments:')
    for i, e in enumerate(environments, start=1):
        print(f"{i}. {e.get('name')} ({e.get('id')}) -> {e.get('path')}")
    while True:
        sel = input('Select environment number (or q to quit): ').strip()
        if sel.lower() in ('q', 'quit', 'exit'):
            return None
        try:
            idx = int(sel) - 1
            if 0 <= idx < len(environments):
                return environments[idx]
        except ValueError:
            pass
        print('Invalid selection')


def console_menu(env):
    project_path = env.get('path')
    print(f"Selected: {env.get('name')} -> {project_path}")
    if not project_path or not os.path.isdir(project_path):
        print('Project path does not exist or is not a directory')
        return

    def list_files():
        for root, dirs, files in os.walk(project_path):
            for f in files:
                rel = os.path.relpath(os.path.join(root, f), project_path)
                print(rel)

    def view_file():
        fp = input('Enter file path (relative to project) to view: ').strip()
        full = os.path.join(project_path, fp)
        if not os.path.isfile(full):
            print('File not found')
            return
        with open(full, 'r', errors='ignore') as f:
            print(f.read())

    def delete_file():
        fp = input('Enter file path (relative to project) to delete: ').strip()
        full = os.path.join(project_path, fp)
        if not os.path.isfile(full):
            print('File not found')
            return
        confirm = input(f'Permanently delete {fp}? (yes/no): ')
        if confirm.lower() == 'yes':
            try:
                os.remove(full)
                print('Deleted')
            except Exception as e:
                print('Failed to delete:', e)

    def search():
        q = input('Enter search query: ').strip()
        if not q:
            return
        use_regex = input('Use regex? (y/N): ').strip().lower() == 'y'
        case = input('Case sensitive? (y/N): ').strip().lower() == 'y'
        results, err = perform_text_search(project_path, q, use_regex=use_regex, case_sensitive=case)
        if err:
            print('Search error:', err)
            return
        if not results:
            print('No results')
            return
        for r in results:
            print(f"{r['file']}:{r['line_num']} - {r['line_content']}")

    def components():
        comps = []
        for root, dirs, files in os.walk(project_path):
            for f in files:
                full = os.path.join(root, f)
                if f.endswith(('.sv', '.v')):
                    comps.extend(parse_sv_file(full))
        if not comps:
            print('No components found')
            return
        for c in comps:
            print(f"{c['type']} {c['name']} in {c['file']}")

    def deps():
        index = build_component_index(project_path)
        usages = find_component_usages(project_path, index.keys())
        for comp, def_file in index.items():
            refs = [u for u in usages.get(comp, []) if u[0] != def_file]
            if refs:
                print(f"{comp} defined in {def_file} used {len(refs)} times")

    actions = {
        'l': ('List files', list_files),
        'v': ('View file', view_file),
        'd': ('Delete file', delete_file),
        's': ('Search', search),
        'c': ('Components', components),
        'p': ('Dependencies', deps),
        'q': ('Quit', lambda: None),
    }

    while True:
        print('\nCommands:')
        for k, (desc, _) in actions.items():
            print(f" {k} - {desc}")
        cmd = input('Enter command: ').strip().lower()
        if cmd == 'q':
            break
        if cmd in actions:
            try:
                actions[cmd][1]()
            except Exception as e:
                print('Error:', e)
        else:
            print('Unknown command')


if __name__ == '__main__':
    # If no DISPLAY (headless), fall back to console mode
    if not os.environ.get('DISPLAY'):
        print('No $DISPLAY detected — running in console mode')
        envs = load_environments()
        env = choose_env_console(envs)
        if env:
            console_menu(env)
        else:
            print('Exiting')
    else:
        app = VEDashboardGUI()
        app.mainloop()
