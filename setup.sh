#!/usr/bin/env bash
#
# Deploy this vim config to ~/.vim (run from the repository root or from ~/.vim).
#
#   git clone <this-repo> ~/.vim
#   cd ~/.vim && ./setup.sh
#
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Link the vimrc (~/.vimrc -> ~/.vim/vimrc).
ln -sf "$HERE/vimrc" "$HOME/.vimrc"

# 2. Directories used for backup/swap/undo/viminfo files.
mkdir -p "$HOME/.vim/files/backup" \
         "$HOME/.vim/files/swap" \
         "$HOME/.vim/files/undo" \
         "$HOME/.vim/files/info"

# 3. Install vim-plug if missing.
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# 4. External tools used by the plugins (needs sudo).
#    ripgrep  -> :Leaderf rg / CtrlSF backend
#    universal-ctags -> tagbar
if command -v apt-get >/dev/null 2>&1; then
    missing=()
    command -v rg >/dev/null 2>&1 || missing+=(ripgrep)
    command -v ctags-universal >/dev/null 2>&1 || missing+=(universal-ctags)
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Installing missing tools: ${missing[*]} (sudo required)"
        sudo apt-get install -y "${missing[@]}"
    fi
fi

cat <<'EOF'
Done.

Next steps:
  1. Start vim:            vim
  2. Install/update plugins:  :PlugInstall   (:PlugUpdate to update)
  3. Check plugin status:     :PlugStatus
  4. Rebuild LeaderF C extension (after Python upgrades):
       cd ~/.vim/plugged/LeaderF && ./install.sh
  5. Verify the setup:        ~/.vim/test.sh
EOF
