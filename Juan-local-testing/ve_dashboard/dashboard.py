from flask import Flask, render_template, abort, request, redirect, url_for, flash
import os
import re
import json

app = Flask(__name__)
app.secret_key = 'supersecretkey' # Needed for flashing messages

# Load environments from config file
def load_environments():
    try:
        script_dir = os.path.dirname(os.path.abspath(__file__))
        config_path = os.path.join(script_dir, 'config.json')
        with open(config_path, 'r') as f:
            return json.load(f)['environments']
    except (IOError, json.JSONDecodeError):
        return []

ENVIRONMENTS = load_environments()
ENV_MAP = {env['id']: env for env in ENVIRONMENTS}

def get_project_path(env_id):
    """Returns the absolute path for a given environment ID."""
    env = ENV_MAP.get(env_id)
    return env['path'] if env else None

def find_full_path(project_path, filename):
    """Finds the full path of a file within a project directory."""
    for root, dirs, files in os.walk(project_path):
        if filename in files:
            return os.path.join(root, filename)
    return None

def perform_text_search(project_path, query, use_regex=False, case_sensitive=False):
    """Performs a raw text or regex search across all files in the project.

    Returns a tuple: (results_list, error_message_or_None)
    """
    results = []
    if not query:
        return results, None

    # Prepare regex or simple substring matching
    regex = None
    flags = 0
    if not case_sensitive:
        flags = re.IGNORECASE

    if use_regex:
        try:
            regex = re.compile(query, flags)
        except re.error as e:
            return [], f'Regex error: {e}'

    for root, dirs, files in os.walk(project_path):
        for file in files:
            # Only search text-like source files
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

def parse_sv_file(filepath):
    """Parses a SystemVerilog file to extract component info."""
    components = []
    try:
        with open(filepath, 'r', errors='ignore') as f:
            content = f.read()
            # Find modules, classes, and interfaces
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
    """Return a dict of component_name -> defining_file"""
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
    """Search for word-boundary occurrences of component names across project files.

    Returns dict: component_name -> list of (file, line_num, line)
    """
    usages = {name: [] for name in component_names}
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

@app.route('/', methods=['GET', 'POST'])
def project_dashboard():
    # Hardcode the environment to fifo_project
    env_id = "fifo_project"
    
    project_path = get_project_path(env_id)
    if not project_path or not os.path.isdir(project_path):
        abort(404, description="Environment 'fifo_project' not found or path is invalid.")

    env_name = ENV_MAP.get(env_id, {}).get('name', 'FIFO Project')

    if request.method == 'POST':
        # Handle file deletion
        files_to_delete = request.form.getlist('selected_files')
        deleted_count = 0
        error_count = 0
        for filename in files_to_delete:
            full_path = find_full_path(project_path, filename)
            if full_path and os.path.commonpath([project_path, full_path]) == project_path:
                try:
                    os.remove(full_path)
                    deleted_count += 1
                except OSError:
                    error_count += 1
            else:
                error_count += 1
        
        if deleted_count > 0:
            flash(f'Successfully deleted {deleted_count} file(s).', 'success')
        if error_count > 0:
            flash(f'Failed to delete {error_count} file(s).', 'danger')
        return redirect(url_for('project_dashboard'))

    # --- GET Request Logic ---
    search_query = request.args.get('search_query', '')
    use_regex = request.args.get('use_regex') == '1'
    case_sensitive = request.args.get('case_sensitive') == '1'
    search_results, search_error = [], None

    if search_query:
        search_results, search_error = perform_text_search(project_path, search_query, use_regex, case_sensitive)

    dut_files, tb_files, tests = [], [], []
    all_components = []
    try:
        for root, dirs, files in os.walk(project_path):
            for file in files:
                rel_path = os.path.relpath(os.path.join(root, file), project_path)
                if file.endswith(('.sv', '.v')):
                    # Simple categorization based on path
                    if 'tb' in root or 'test' in root:
                        if '_test.sv' in file or '_tests.sv' in file:
                            tests.append(rel_path)
                        else:
                            tb_files.append(rel_path)
                    else:
                        dut_files.append(rel_path)
                    
                    # Extract components
                    all_components.extend(parse_sv_file(os.path.join(root, file)))

    except Exception as e:
        flash(f"Error scanning project files: {e}", "danger")

    # Build dependency data
    component_names = [comp['name'] for comp in all_components]
    dep_usages = find_component_usages(project_path, component_names)
    
    # Filter out components that are not used by anything else
    dep_components = [comp for comp in all_components if comp['name'] in dep_usages and dep_usages[comp['name']]]


    return render_template('index.html', 
                           env_id=env_id,
                           env_name=env_name,
                           project_path=project_path,
                           dut_files=dut_files,
                           tb_files=tb_files,
                           tests=tests,
                           all_components=all_components,
                           dep_components=dep_components,
                           dep_usages=dep_usages,
                           search_query=search_query,
                           search_results=search_results,
                           search_error=search_error)

@app.route('/view_file/<path:filepath>')
def view_file(filepath):
    # Hardcode the environment to fifo_project
    env_id = "fifo_project"
    project_path = get_project_path(env_id)
    if not project_path:
        abort(404)

    # Security: Ensure the requested file is within the project directory
    full_path = os.path.join(project_path, filepath)
    if not os.path.commonpath([project_path, os.path.abspath(full_path)]) == project_path:
        abort(403)

    try:
        with open(full_path, 'r', errors='ignore') as f:
            content = f.read()
        return render_template('view_file.html', filename=filepath, content=content)
    except IOError:
        abort(404, description="File not found")


if __name__ == '__main__':
    port = int(os.environ.get('VE_DASH_PORT', 5001))
    app.run(debug=True, host='0.0.0.0', port=port)
