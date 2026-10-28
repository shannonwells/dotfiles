#!/usr/bin/env bash
# Coder dotfiles entry point: maps this repo onto a fresh workspace's $HOME.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RCFILES="$REPO_DIR/rcfiles"

echo "setting up claude files (will clobber)"
mkdir -p "$HOME/.claude"
cp -f "$REPO_DIR/coding-agent/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

for dir in agents commands skills; do
  mkdir -p "$HOME/.claude/$dir"
  cp -rf "$REPO_DIR/coding-agent/$dir/." "$HOME/.claude/$dir/"
done

find "$HOME/.claude" -name '.gitkeep' -delete
find "$HOME/.claude" -name '.DS_Store' -delete

test "${SHELL}" == `which zsh` \
    && echo "copying zsh dotfiles" \
    &&  cp -f "$RCFILES/zshrc" "$HOME/.zshrc"  \
    && cp -f "$RCFILES/zprofile" "$HOME/.zprofile" \
test "${SHELL}" == `which bash` \
    && echo "copying bash dotfiles" \
    && cp -f "$RCFILES/bashrc" "$HOME/.bashrc"

FILES="gitconfig aliases vimrc"
for file in $FILES ; do
  echo "copying rest of dotfiles"
  cp -f "$RCFILES/$file" "$HOME/.$file"
done

echo "dev-toolkit: installed Claude agent files and shell dotfiles into $HOME"
