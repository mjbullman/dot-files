#!/usr/bin/env bash
set -euo pipefail

SESSION_NAME="MJBDotFiles"
PROJECT_DIR="${PWD}"

h() { herdr --session "${SESSION_NAME}" "$@"; }

session_status() {
    herdr session list | awk -v s="${SESSION_NAME}" '$1 == s { print $2 }'
}

status="$(session_status)"

if [[ "${status}" == "running" ]]; then
    echo "Attaching to existing session: ${SESSION_NAME}..."
    exec herdr session attach "${SESSION_NAME}"
fi

# a stopped session restores its layout but not its programs; rebuild it fresh
if [[ "${status}" == "stopped" ]]; then
    herdr session delete "${SESSION_NAME}" >/dev/null
fi

echo "Creating new session: ${SESSION_NAME}..."

# start the session's server headless so the layout can be built before attaching
nohup herdr --session "${SESSION_NAME}" server >/dev/null 2>&1 &
for _ in {1..50}; do
    [[ "$(session_status)" == "running" ]] && break
    sleep 0.1
done

# workspace with nvim in its first tab
ws_json="$(h workspace create --cwd "${PROJECT_DIR}" --label "${SESSION_NAME}" --focus)"
WS_ID="$(jq -r .result.workspace.workspace_id <<<"${ws_json}")"
NVIM_TAB="$(jq -r .result.tab.tab_id <<<"${ws_json}")"
NVIM_PANE="$(jq -r .result.root_pane.pane_id <<<"${ws_json}")"
h tab rename "${NVIM_TAB}" nvim >/dev/null

# new tab with a command typed into its shell, so the shell (and any crash
# output) stays visible if the program exits
new_tab() {
    local label="$1" cmd="$2" pane
    pane="$(h tab create --workspace "${WS_ID}" --cwd "${PROJECT_DIR}" --label "${label}" --no-focus \
        | jq -r .result.root_pane.pane_id)"
    h pane run "${pane}" "${cmd}" >/dev/null
}

new_tab claude claude
new_tab lazygit lazygit

h pane run "${NVIM_PANE}" nvim >/dev/null

h tab focus "${NVIM_TAB}" >/dev/null
exec herdr session attach "${SESSION_NAME}"
