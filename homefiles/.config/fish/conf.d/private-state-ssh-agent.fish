# Ensure interactive shells have an ssh-agent and the private-state key loaded.
# General use:
# - Start an agent only when one is not already available.
# - Add the dedicated private-state key automatically if the file exists.
# - Avoid duplicate ssh-add prompts by checking the key fingerprint first.

if status --is-interactive
    # Fish sessions started outside a desktop agent need a local ssh-agent first.
    if not set -q SSH_AUTH_SOCK
        ssh-agent -c | source >/dev/null
    end

    if test -f ~/.ssh/id_ed25519_private_state
        # Compare the private key fingerprint against loaded identities so the
        # helper only calls ssh-add when the dedicated key is actually missing.
        set -l _private_state_fpr (ssh-keygen -lf ~/.ssh/id_ed25519_private_state 2>/dev/null | awk '{print $2}')
        if test -n "$_private_state_fpr"
            ssh-add -l 2>/dev/null | grep -q "$_private_state_fpr"
            or ssh-add ~/.ssh/id_ed25519_private_state >/dev/null 2>&1
        end
    end
end
