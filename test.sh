#!/usr/bin/env bash
#
# Smoke test for this Vim configuration.
#
#   ~/.vim/test.sh
#
# Every check is independent and prints PASS/FAIL. Exit code is non-zero
# when at least one check fails. Safe to run anytime (uses temporary files).
#
set -uo pipefail

VIMRC="$HOME/.vim/vimrc"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/vimtest.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT

PASS=0
FAIL=0
ok()      { printf '  \033[32mPASS\033[0m %s\n' "$1"; PASS=$((PASS + 1)); }
bad()     { printf '  \033[31mFAIL\033[0m %s\n' "$1"; FAIL=$((FAIL + 1)); }
skip()    { printf '  \033[33mSKIP\033[0m %s\n' "$1"; }
section() { printf '\n== %s ==\n' "$1"; }
report()  { grep -qF "$2" "$1" 2>/dev/null; }

if [ ! -f "$VIMRC" ]; then
    echo "vimrc not found: $VIMRC" >&2
    exit 1
fi

# ---------------------------------------------------------------- dependencies
section "External tools"
for tool in rg ctags-universal cscope; do
    if command -v "$tool" >/dev/null 2>&1; then
        ok "$tool: $(command -v "$tool")"
    else
        bad "$tool not found (see README 'Dependencies')"
    fi
done

# ------------------------------------------------------------------ startup
section "Vim starts without errors"
cat > "$TMP/startup.vim" <<'EOF'
redir! > $TMP/startup.txt
messages
redir END
qa!
EOF
sed -i "s|\$TMP|$TMP|g" "$TMP/startup.vim"
vim -Nu "$VIMRC" --not-a-term -es -S "$TMP/startup.vim" >/dev/null 2>&1
if grep -qi "error detected" "$TMP/startup.txt" 2>/dev/null; then
    bad "errors during startup:"
    sed 's/^/       /' "$TMP/startup.txt"
else
    ok "no startup errors"
fi

# ------------------------------------------------------------------ mappings
section "Mapping ownership"
cat > "$TMP/maps.vim" <<'EOF'
redir! > $TMP/maps.txt
echo ']c=' . string(maparg(']c', 'n'))
echo '[c=' . string(maparg('[c', 'n'))
echo ';hs=' . string(maparg(';hs', 'n'))
echo ';hu=' . string(maparg(';hu', 'n'))
echo ';hp=' . string(maparg(';hp', 'n'))
echo ';bl=' . string(maparg(';bl', 'n'))
echo ';ul=' . string(maparg(';ul', 'n'))
echo ';uc=' . string(maparg(';uc', 'n'))
echo ';sr=' . string(maparg(';sr', 'n'))
echo ';gg=' . string(maparg(';gg', 'n'))
echo ';gd=' . string(maparg(';gd', 'n'))
echo ';fF=' . string(maparg(';fF', 'n'))
echo ';H=' . string(maparg(';H', 'n'))
echo ';eL=' . string(maparg(';eL', 'n'))
echo ';sa=' . string(maparg(';sa', 'n'))
echo ';bn=' . string(maparg(';bn', 'n'))
echo 'n=' . string(maparg('n', 'n'))
echo 'N=' . string(maparg('N', 'n'))
echo 'CR=' . string(maparg("\<CR>", 'n'))
echo 'ctrlsf=' . ctrlsf#backend#Detect()
echo 'ctags_bin=' . g:tagbar_ctags_bin
redir END
qa!
EOF
sed -i "s|\$TMP|$TMP|g" "$TMP/maps.vim"
vim -Nu "$VIMRC" --not-a-term -es -S "$TMP/maps.vim" >/dev/null 2>&1

check_map() { # check_map <key> <expected substring | EMPTY>
    if [ "$2" = "EMPTY" ]; then
        if report "$TMP/maps.txt" "$1=''"; then ok "$1 is not mapped (as expected)"; else bad "$1 is unexpectedly mapped"; fi
    else
        if report "$TMP/maps.txt" "$1='$2"; then ok "$1 -> $2"; else bad "$1 does not point to $2"; fi
    fi
}
check_map "]c"  "<Plug>(GitGutterNextHunk)"
check_map "[c"  "<Plug>(GitGutterPrevHunk)"
check_map ";hs" "<Plug>(GitGutterStageHunk)"
check_map ";hu" "<Plug>(GitGutterUndoHunk)"
check_map ";hp" "<Plug>(GitGutterPreviewHunk)"
check_map ";bl" ":LeaderfBuffer"
check_map ";ul" ":set list"
check_map ";uc" ":setlocal cursorline!"
check_map ";sr" ":Leaderf rg"
check_map ";gg" ":Git"
check_map ";gd" ":Gdiffsplit"
check_map ";fF" ":NERDTreeFind"
check_map ";H"  ":Cheat"
check_map ";eL" "EMPTY"
check_map ";sa" "EMPTY"
check_map ";bn" "EMPTY"
check_map "n"   "EMPTY"
check_map "N"   "EMPTY"
check_map "CR"  "EMPTY"

if report "$TMP/maps.txt" "ctrlsf=rg"; then
    ok "CtrlSF backend -> rg"
else
    bad "CtrlSF backend is not rg ($(grep '^ctrlsf=' "$TMP/maps.txt"))"
fi
if report "$TMP/maps.txt" "ctags_bin=ctags-universal"; then
    ok "tagbar uses ctags-universal"
else
    bad "g:tagbar_ctags_bin is not ctags-universal"
fi

# ------------------------------------------------------- n/N counts restored
section "n/N keep default count behaviour (E16 regression)"
printf 'x1\nx2\nx3\nx4\n' > "$TMP/count.txt"
cat > "$TMP/count.vim" <<'EOF'
set nobackup nowritebackup noundofile noswapfile
edit $TMP/count.txt
call cursor(1, 1)
let @/ = 'x'
silent! normal 3n
redir! > $TMP/count_out.txt
echo 'line=' . line('.')
messages
redir END
qa!
EOF
sed -i "s|\$TMP|$TMP|g" "$TMP/count.vim"
vim -Nu "$VIMRC" --not-a-term -es -S "$TMP/count.vim" >/dev/null 2>&1
if report "$TMP/count_out.txt" "line=4" && ! grep -q "E16" "$TMP/count_out.txt"; then
    ok "3n moves to the 3rd match (line 4)"
else
    bad "3n did not work: $(tr '\n' ' ' < "$TMP/count_out.txt")"
fi

# ------------------------------------------------------------- gitgutter
section "gitgutter hunk jumping"
mkdir -p "$TMP/repo"
(
    cd "$TMP/repo" || exit 1
    git init -q
    git config user.email test@example.com
    git config user.name Test
    seq 1 40 > a.txt
    git add a.txt
    git commit -qm init
)
sed -i '5s/.*/five-changed/;20s/.*/twenty-changed/' "$TMP/repo/a.txt"
cat > "$TMP/gitgutter.vim" <<'EOF'
set nobackup nowritebackup noundofile noswapfile
edit a.txt
silent GitGutter
call cursor(1, 1)
silent! normal ]c
redir! > $TMP/gitgutter_out.txt
echo 'first=' . line('.')
silent! normal ]c
echo 'second=' . line('.')
messages
redir END
qa!
EOF
sed -i "s|\$TMP|$TMP|g" "$TMP/gitgutter.vim"
( cd "$TMP/repo" && vim -Nu "$VIMRC" --not-a-term -es \
    --cmd 'let g:gitgutter_async = 0' -S "$TMP/gitgutter.vim" >/dev/null 2>&1 )
if report "$TMP/gitgutter_out.txt" "first=5" && report "$TMP/gitgutter_out.txt" "second=20"; then
    ok "]c jumps to first hunk (5) and next hunk (20)"
else
    bad "gitgutter jumping failed: $(tr '\n' ' ' < "$TMP/gitgutter_out.txt")"
fi
if grep -qi "Please change your map" "$TMP/gitgutter_out.txt" 2>/dev/null; then
    bad "deprecated <Plug> mapping warning is back"
else
    ok "no deprecated <Plug> warning"
fi

# --------------------------------------------------------------- plugin cmds
section "Plugin commands"
cat > "$TMP/cmds.vim" <<'EOF'
redir! > $TMP/cmds.txt
echo 'Git=' . exists(':Git')
echo 'CtrlSF=' . exists(':CtrlSF')
echo 'TagbarToggle=' . exists(':TagbarToggle')
echo 'LeaderfFile=' . exists(':LeaderfFile')
echo 'NERDTreeFind=' . exists(':NERDTreeFind')
echo 'Ack=' . exists(':Ack')
echo 'Grepper=' . exists(':Grepper')
echo 'CtrlP=' . exists(':CtrlP')
echo 'Cheat=' . exists(':Cheat')
redir END
qa!
EOF
sed -i "s|\$TMP|$TMP|g" "$TMP/cmds.vim"
vim -Nu "$VIMRC" --not-a-term -es -S "$TMP/cmds.vim" >/dev/null 2>&1
for c in Git CtrlSF TagbarToggle LeaderfFile NERDTreeFind Cheat; do
    if report "$TMP/cmds.txt" "$c=2"; then ok ":$c available"; else bad ":$c missing"; fi
done
for c in Ack Grepper CtrlP; do
    if report "$TMP/cmds.txt" "$c=0"; then ok ":$c removed"; else bad ":$c should be removed"; fi
done

# ------------------------------------------------------- LeaderF C extension
section "LeaderF C extension"
cat > "$TMP/leaderf.vim" <<'EOF'
py3 << PYEOF
import sys, vim
path = vim.eval("expand('$HOME/.vim/plugged/LeaderF/autoload/leaderf/python')")
sys.path.insert(0, path)
try:
    import fuzzyMatchC, fuzzyEngine
    vim.vars['vimtest_c'] = 1
except ImportError:
    vim.vars['vimtest_c'] = 0
PYEOF
redir! > $TMP/leaderf_out.txt
echo 'c_ext=' . get(g:, 'vimtest_c', 0)
redir END
qa!
EOF
sed -i "s|\$TMP|$TMP|g" "$TMP/leaderf.vim"
vim -Nu "$VIMRC" --not-a-term -es -S "$TMP/leaderf.vim" >/dev/null 2>&1
if report "$TMP/leaderf_out.txt" "c_ext=1"; then
    ok "fuzzyMatchC/fuzzyEngine import OK"
else
    bad "C extension not importable - rebuild with: cd ~/.vim/plugged/LeaderF && ./install.sh"
fi

# ------------------------------------------------------------------- tagbar
section "tagbar (needs a pty)"
if command -v script >/dev/null 2>&1; then
    cat > "$TMP/t.cpp" <<'EOF'
namespace ns {
class Widget {
public:
    void draw();
};
void Widget::draw() {}
}
int main() { return 0; }
EOF
    cat > "$TMP/tagbar.vim" <<'EOF'
set nobackup nowritebackup noundofile noswapfile
edit $TMP/t.cpp
TagbarOpen
2wincmd w
redir! > $TMP/tagbar_out.txt
silent %print
redir END
qa!
EOF
    sed -i "s|\$TMP|$TMP|g" "$TMP/tagbar.vim"
    script -qec "vim -Nu $VIMRC -S $TMP/tagbar.vim" /dev/null >/dev/null 2>&1
    if report "$TMP/tagbar_out.txt" "Widget" && report "$TMP/tagbar_out.txt" "main()"; then
        ok "tagbar lists C++ symbols"
    else
        bad "tagbar did not list symbols"
    fi
else
    skip "util-linux 'script' not available, cannot test tagbar"
fi

# -------------------------------------------------------------------- summary
printf '\n%s\n' "----------------------------------------"
printf 'PASS: %d   FAIL: %d\n' "$PASS" "$FAIL"
if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
