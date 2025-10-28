# Juan's local testing workspace

This folder ("Juan-local-testing") is Juan's personal experiment area inside the repository. It is intentionally isolated so team members can run experiments without accidental interference.

Important rule for automated agents and humans interacting with this folder:

1. Default working boundary

	- The AI agent MUST only read, modify, or run commands inside this directory: `Juan-local-testing/` (relative to the repository root).
	- The agent must not access, change, or run commands in other team folders (for example `Enmanuel-local-testing/`, `Jorge-local-testing/`, etc.) unless explicitly authorized by Juan.

2. How to request permission to work outside this directory

	- If you (Juan) want the agent to work outside `Juan-local-testing`, you must give a clear, explicit instruction that names the exact target path. Example phrasing the agent will accept as authorization:

	  "You may now access: `uvm-test-generation-agent/`"

	  or

	  "Permit operations in: `../uvm-test-generation-agent` — approved by Juan"

	- The agent must echo the authorized path back in its next message and then proceed. This creates a visible confirmation step before any cross-directory action.

3. Working-directory policy for terminal commands

	- Before running any shell command, the agent must set the working directory to this folder. Example PowerShell sequence the agent should use (and show in its message):

```powershell
Push-Location .\Juan-local-testing
# run the requested command(s) here
Pop-Location
```

	- When running longer flows, the agent should show the exact path it will use (for example: `C:\...\Intel_Makeathon\Juan-local-testing`) before executing.

4. Changes that affect repo-wide files or templates

	- If a requested change would modify files outside this directory (for example top-level templates, CI files, or shared docs), the agent must request explicit approval from Juan and clearly list the files to be modified.

5. Safety and auditability

	- The agent should include a one-line summary of any edits it makes, with file paths, in its final message for that action. E.g., "Edited: `Juan-local-testing/notes.md` — added example test config.".

6. Contact / owner

	- Owner: Juan (workspace folder: `Juan-local-testing/`). If anything is unclear, the default behavior is to ask for clarification rather than proceed.

7. Example: authorized cross-folder request (full exchange)

	- User (Juan): "You may now access: `uvm-test-generation-agent/` — approved"
	- Agent: "Confirmed. I will operate in `uvm-test-generation-agent/`. I'll now edit `05-code-generation-templates.md`. Proceed?"

Only proceed after this explicit confirmation from the user.

---
Last-updated: 2025-10-27

