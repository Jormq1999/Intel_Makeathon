#!/bin/bash
#
# Native UNIX Dashboard
# A shell-based script to explore and manage SystemVerilog verification environments.
# Replicates the core functionality of the Python web/GUI dashboard using standard
# UNIX command-line tools for maximum portability and minimal dependencies.
#

# --- Configuration ---
# The script will try to find config.json in its own directory.
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$SCRIPT_DIR/config.json"

# --- Helper Functions ---

# Function to display a header in a consistent style.
print_header() {
    echo "================================================================================"
    echo "  $1"
    echo "================================================================================"
}

# A simple JSON parser using grep and sed. Works only for the specific format of config.json.
# Usage: parse_json <file> <key>
parse_json() {
    local file=$1
    local key=$2
    # This parser is intentionally simple. For complex JSON, a tool like 'jq' would be better.
    grep -o "\"${key}\": *\"[^\"]*\"" "$file" | sed "s/.*\"${key}\": *\"\(.*\)\"/\1/"
}

# --- Core Logic Functions ---

select_environment() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Error: config.json not found at $CONFIG_FILE"
        return 1
    fi

    # Use a while loop and process substitution to correctly handle names with spaces.
    local names=()
    local paths=()
    while IFS= read -r line; do names+=("$line"); done < <(parse_json "$CONFIG_FILE" "name")
    while IFS= read -r line; do paths+=("$line"); done < <(parse_json "$CONFIG_FILE" "path")

    if [ ${#names[@]} -eq 0 ]; then
        echo "No environments found in config.json."
        return 1
    fi

    print_header "Select an Environment"
    for i in "${!names[@]}"; do
        echo "  $((i+1))) ${names[$i]}"
    done
    echo

    local choice
    while true; do
        read -p "Enter number (or 'q' to quit): " choice
        if [[ "$choice" == "q" ]]; then
            PROJECT_PATH=""
            return 1
        fi
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -gt 0 ] && [ "$choice" -le "${#names[@]}" ]; then
            PROJECT_PATH="${paths[$((choice-1))]}"
            echo "Environment set to: ${names[$((choice-1))]}"
            echo "Path: $PROJECT_PATH"
            return 0
        else
            echo "Invalid selection. Please try again."
        fi
    done
}

list_files() {
    local output_file=$1
    {
        echo "### File Explorer"
        echo
        echo "**DUT Files**"
        echo '```'
        find "$PROJECT_PATH" -type f \( -name "*.sv" -o -name "*.v" \) \
            -not -path "*tb*" -not -path "*test*" -not -path "*agent*" \
            -not -path "*driver*" -not -path "*monitor*" -not -path "*env*" \
            | sed "s|^$PROJECT_PATH/||"
        echo '```'
        echo

        echo "**Testbench Files**"
        echo '```'
        find "$PROJECT_PATH" -type f \( -name "*_agent.sv" -o -name "*_driver.sv" -o -name "*_monitor.sv" \
            -o -name "*_env.sv" -o -name "*_if.sv" -o -name "*_scoreboard.sv" -o -name "tb_top.sv" \) \
            | sed "s|^$PROJECT_PATH/||"
        echo '```'
        echo

        echo "**Tests/Sequences**"
        echo '```'
        find "$PROJECT_PATH" -type f \( -name "*_test.sv" -o -name "*_tests.sv" -o -name "*_sequences.sv" \) \
            | sed "s|^$PROJECT_PATH/||"
        echo '```'
        echo
    } | if [ -n "$output_file" ]; then tee -a "$output_file"; else cat; fi
}

extract_components() {
    local output_file=$1
    {
        echo "### Extracted Components"
        echo
        echo "| Type         | Name                         | File Path |"
        echo "|--------------|------------------------------|-----------|"
        find "$PROJECT_PATH" -type f \( -name "*.sv" -o -name "*.v" \) -exec \
            grep -E -H '^\s*(module|class|interface)\s+\w+' {} + \
            | awk -F'[: ]+' '{printf "| %-12s | %-28s | %s |\n", $2, $3, $1}' \
            | sed "s|^$PROJECT_PATH/||"
        echo
    } | if [ -n "$output_file" ]; then tee -a "$output_file"; else cat; fi
}

search_project() {
    print_header "Text Search"
    read -p "Enter search query: " query
    if [ -z "$query" ]; then
        echo "Search query cannot be empty."
        return
    fi

    read -p "Case-sensitive? (y/N): " case_sensitive
    read -p "Use regex? (y/N): " use_regex

    local grep_opts="-r"
    [ "$case_sensitive" != "y" ] && grep_opts="$grep_opts -i"
    [ "$use_regex" == "y" ] && grep_opts="$grep_opts -E"

    echo "Searching for '$query'..."
    grep $grep_opts --color=always "$query" "$PROJECT_PATH" \
        --include=\*.{sv,v,vh,svh,svt,h,c,py,md,txt} \
        | sed "s|^$PROJECT_PATH/||"
}

view_file() {
    print_header "View File"
    read -p "Enter file path (relative to project): " file_path
    local full_path="$PROJECT_PATH/$file_path"
    if [ -f "$full_path" ]; then
        less "$full_path"
    else
        echo "Error: File not found at $full_path"
    fi
}

delete_file() {
    print_header "Delete File"
    read -p "Enter file path to delete (relative to project): " file_path
    local full_path="$PROJECT_PATH/$file_path"
    if [ -f "$full_path" ]; then
        # Use rm -i for an interactive confirmation prompt.
        rm -i "$full_path"
    else
        echo "Error: File not found at $full_path"
    fi
}

analyze_dependencies() {
    print_header "Analyze Dependencies"
    read -p "Enter file path to analyze (relative to project): " file_path
    local full_path="$PROJECT_PATH/$file_path"
    
    if [ ! -f "$full_path" ]; then
        echo "Error: File not found at $full_path"
        return
    fi

    local filename=$(basename "$file_path")
    # Extract module/class/interface name from the file. Assumes one main definition per file.
    local symbol_name=$(grep -E '^\s*(module|class|interface)\s+\w+' "$full_path" | awk '{print $2}' | head -n 1)

    echo "Analyzing dependencies for: $filename"
    echo "Found symbol: ${symbol_name:-Not found}"
    echo "--------------------------------------------------------------------------------"

    # Search for `include "filename"`
    echo "Files including '$filename':"
    grep -r --color=always "\`include \"$filename\"" "$PROJECT_PATH" --include=\*.{sv,v,svh} | sed "s|^$PROJECT_PATH/||"
    echo

    # Search for symbol instantiation if a symbol was found
    if [ -n "$symbol_name" ]; then
        echo "Files instantiating '$symbol_name':"
        # This is a simplified search for instantiation, looking for 'symbol_name instance_name ('
        grep -r --color=always -E "$symbol_name\s+\w+\s*\(" "$PROJECT_PATH" --include=\*.{sv,v} | sed "s|^$PROJECT_PATH/||"
        echo
    fi
}

generate_report() {
    local report_file="$SCRIPT_DIR/report.md"
    print_header "Generating Markdown Report"
    echo "Report will be saved to: $report_file"
    
    # Create or clear the report file
    > "$report_file"
    
    echo "# Project Analysis Report for $(basename "$PROJECT_PATH")" >> "$report_file"
    echo "*Generated on $(date)*" >> "$report_file"
    echo "" >> "$report_file"

    # Add file list to report
    list_files "$report_file" >/dev/null # Suppress terminal output

    # Add component list to report
    extract_components "$report_file" >/dev/null # Suppress terminal output

    echo "Report generation complete."
}


# --- Main Menu ---

main_menu() {
    while true; do
        print_header "UNIX Dashboard | Current Project: ${PROJECT_PATH:-Not Set}"
        echo "  1) Select Environment"
        echo "  2) List Files"
        echo "  3) Extract Components"
        echo "  4) Search Project"
        echo "  5) View File"
        echo "  6) Delete File"
        echo "  7) Analyze Dependencies"
        echo "  8) Generate Markdown Report"
        echo "  q) Quit"
        echo

        read -p "Enter your choice: " choice

        case $choice in
            1) select_environment ;;
            2) [ -z "$PROJECT_PATH" ] && echo "Please select an environment first." || list_files ;;
            3) [ -z "$PROJECT_PATH" ] && echo "Please select an environment first." || extract_components ;;
            4) [ -z "$PROJECT_PATH" ] && echo "Please select an environment first." || search_project ;;
            5) [ -z "$PROJECT_PATH" ] && echo "Please select an environment first." || view_file ;;
            6) [ -z "$PROJECT_PATH" ] && echo "Please select an environment first." || delete_file ;;
            7) [ -z "$PROJECT_PATH" ] && echo "Please select an environment first." || analyze_dependencies ;;
            8) [ -z "$PROJECT_PATH" ] && echo "Please select an environment first." || generate_report ;;
            q|Q) echo "Exiting."; exit 0 ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
        
        [ "$choice" != "1" ] && [ -n "$PROJECT_PATH" ] && read -p "Press Enter to return to the menu..."
    done
}

# --- Script Entry Point ---
main_menu
