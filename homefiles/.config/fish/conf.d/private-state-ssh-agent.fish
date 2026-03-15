# Auto-start ssh-agent (if needed) and ensure private-state key is loaded.
if status --is-interactive
    if not set -q SSH_AUTH_SOCK
        ssh-agent -c | source >/dev/null
    end

    if test -f ~/.ssh/id_ed25519_private_state
        set -l _private_state_fpr (ssh-keygen -lf ~/.ssh/id_ed25519_private_state 2>/dev/null | awk '{print $2}')
        if test -n "$_private_state_fpr"
            ssh-add -l 2>/dev/null | grep -q "$_private_state_fpr"
            or ssh-add ~/.ssh/id_ed25519_private_state >/dev/null 2>&1
        end
    end
end
