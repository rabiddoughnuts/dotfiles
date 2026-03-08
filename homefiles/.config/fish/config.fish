# 1. Load CachyOS Defaults
source /usr/share/cachyos-fish-config/cachyos-config.fish

if status is-interactive
    # 1. Load modprobed-db store
    modprobed-db store

end

export PATH="$HOME/bin:$PATH"

set -gx CONTAINERS /home/brandon/containers/

# 2. Change fish greeting
# if changed or uncommented, disables current fastfetch greeting, can customize
function fish_greeting
    if set -q maintenance_alert; and test "$maintenance_alert" = "true"
        set_color yellow
        echo "╔══════════════════════════════════════════╗"
        echo "║   NEW MAINTENANCE REPORT IS AVAILABLE    ║"
        echo "╚══════════════════════════════════════════╝"
        set_color normal
        # Show specific highlights from the log
        grep -Ev "LibClamAV |WARRANTY|2007|Enterprise|##|\\+|DONE|SKIPPED|systemd|ENABLED|DISABLED|NONE|---|=====|OK|UNSAFE|MEDIUM|EXPOSED|PROTECTED|runlevel|DEFAULT|UNKNOWN|FOUND|SUGGESTION|UP-TO-DATE|AUTO|NO|ACTIVE|\\[[[:space:]]*[0-9]+[a-z]*[[:space:]]*\\]|RUNNING|WEAK|ERROR|WARNING|DIFFERENT|HARDENED" /var/log/maintenance.log.prev | awk 'NF{blank=0} !NF{blank++} blank<2'
        echo ""
        set_color cyan
        echo "Run 'read_log' to clear this alert."
        set_color normal
    else
        fastfetch
    end
end

set -x MEDIA_ADMIN_TOKEN "your-admin-token"

function read_log
    set -U maintenance_alert false
    echo "Flag cleared. Have a productive session!"
end

function mkconf
    sudo mkdir -p (dirname $argv[1])
    sudo nvim $argv[1]
end

# 3. Environment Variables
set -gx PATH $PATH ~/bin
set -gx SUDO_EDITOR nvim
set -gx SCRAPER_PROGRESS 1

# 4. Initialize Zoxide
if type -q zoxide
    zoxide init fish | source
end

function lookup
    # 1. Search and import keys matching the email/name
    gpg --batch --with-colons --keyserver keyserver.ubuntu.com --search-keys $argv[1] | \
    awk -F: '$1=="pub"{print $2}' | xargs -I {} gpg --keyserver keyserver.ubuntu.com --recv-keys {}

    # 2. Print the full fingerprint of any imported keys matching that search
    gpg --fingerprint $argv[1]
end

function vol2
    singularity exec $CONTAINERS/volatility2.sif python2 /opt/volatility/vol.py $argv
end

function markdown
    if test (count $argv) -eq 0
        echo "Usage: markdown <input.pdf> [output.md]"
        return 1
    end

    set input $argv[1]
    set output_name ""

    if test (count $argv) -ge 2
        set output_name (basename -- $argv[2])
    else
        set base (basename -- $input)
        set stem (string replace -r '\\.pdf$' '' -- $base)
        set output_name "$stem.md"
    end

    set output_path "$PWD/$output_name"
    /home/brandon/bin/markitdown-env/bin/markitdown "$input" > "$output_path"
end

# 5. Your Personal Aliases
### Navigation & Core Aliases
alias ..='z ..'
alias cd='z'
alias c='clear'
alias gh='history | grep'
alias mirror='sudo cachyos-rate-mirrors'
alias security='systemd-analyze security'
alias poppy='~/bin/./ts'
alias look='gpg --keyserver keys.openpgp.org --search-keys'
alias hash='hashcat -d 1,2'
alias copilotsetup='~/bin/setup-copilot-scratch.sh'
alias mkdir='mkdir -pv'

### Move stat to fstat
alias fstat='/usr/bin/stat'

### Config Editing Shortcuts
alias rc='nvim ~/.config/fish/config.fish'
alias src='source ~/.config/fish/config.fish'
alias hypr='nvim ~/.config/hypr/hyprland.conf'
alias idle='nvim ~/.config/hypr/hypridle.conf'
alias way='nvim ~/.config/waybar/config'
alias key='ghostty +list-keybinds'

### Configure Git shortcuts
alias ga='git add .'
alias stat='git status'
alias gc='git commit -a -m'
alias gp='git push'
alias pull='git pull'
alias gs='git switch'
alias gb='git branch'

### Pacman / System Shortcuts
alias install='sudo pacman -S'
alias unins='sudo pacman -Rns'
alias orphans='pacman -Qqdt'
alias kill-orphans='sudo pacman -Rns (pacman -Qqdt)'
alias fresh='sudo pacman -S --needed (comm -12 (pacman -Slq | sort | psub) (sort "/run/media/brandon/EEB0F0D1B0F0A0EF/Personal/pkglist.txt" | psub))'
alias dep='pacman -Qi'

### Firewall Shortcuts
alias ipt='sudo /sbin/iptables' 
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'

### Fun / Misc
alias uxtu='python3 ~/Downloads/UXTU4Unix/UXTU4Unix.py'
alias ifconfig='ip addr show'
alias cow='fortune | cowsay'
alias maria='sudo systemctl start mariadb.service'
alias vol3="singularity exec $CONTAINERS/volatility3.sif volatility3"

## pass options to free ##
alias meminfo='free -m -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'
 
## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ##
 
## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
