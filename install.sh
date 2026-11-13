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

case $(basename $SHELL) in
  zsh)
    echo "copying zsh dotfiles" 
    echo "source $HOME/.zprofile" >> $HOME/.zshrc

    for file in $(ls $RCFILES/z*) ; do cp -n $file $HOME/".$(basename $file)" ; done
    ;;
  bash)
    echo "copying bash dotfiles" \
    cp -f "$RCFILES/bashrc" "$HOME/.bashrc"
    ;;
esac

FILES="gitconfig aliases vimrc"
echo "copying rest of dotfiles"
for file in $FILES ; do
  cp -f "$RCFILES/$file" "$HOME/.$file"
done

echo "dev-toolkit: installed Claude agent files and shell dotfiles into $HOME"
