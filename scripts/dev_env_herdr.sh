#!/usr/bin/env bash

# Herdr version of dev_env.sh: one named session, one workspace, nvim/claude/lazygit tabs

SESSION_NAME="MJBDotFiles"

function h() {
    herdr --session "${SESSION_NAME}" "$@"
}

if herdr session list | awk '{print $1, $2}' | grep -qx "${SESSION_NAME} running"; then
    echo "Attaching to existing session: ${SESSION_NAME}..."
    exec herdr session attach "${SESSION_NAME}"
else
    echo "Creating new session: ${SESSION_NAME}..."

    # start a headless server for the session so it can be populated before attaching
    nohup herdr --session "${SESSION_NAME}" server >/dev/null 2>&1 &

    # wait for the server socket (up to 5s)
    for _ in $(seq 1 50); do
        h workspace list 2>/dev/null | grep -q '"result"' && break
        sleep 0.1
    done

    # create workspace and start nvim in its first tab
    workspace=$(h workspace create --cwd "${PWD}" --label "${SESSION_NAME}" --focus)
    workspace_id=$(jq -r '.result.workspace.workspace_id' <<<"${workspace}")
    nvim_tab=$(jq -r '.result.tab.tab_id' <<<"${workspace}")
    h tab rename "${nvim_tab}" nvim >/dev/null
    h pane run "$(jq -r '.result.root_pane.pane_id' <<<"${workspace}")" nvim >/dev/null

    # create new tab and run claude code
    claude_tab=$(h tab create --workspace "${workspace_id}" --cwd "${PWD}" --label claude --no-focus)
    h pane run "$(jq -r '.result.root_pane.pane_id' <<<"${claude_tab}")" claude >/dev/null

    # create new tab and run lazygit
    lazygit_tab=$(h tab create --workspace "${workspace_id}" --cwd "${PWD}" --label lazygit --no-focus)
    h pane run "$(jq -r '.result.root_pane.pane_id' <<<"${lazygit_tab}")" lazygit >/dev/null

    # focus nvim tab
    h tab focus "${nvim_tab}" >/dev/null

    # attach to session
    exec herdr session attach "${SESSION_NAME}"
fi
