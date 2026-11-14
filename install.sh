#!/usr/bin/env bash
# Coder dotfiles entry point: maps this repo onto a fresh workspace's $HOME.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RCFILES="$REPO_DIR/rcfiles"
COPY="cp -n"

while getopts "fh" opt; do
    case $opt in 
        h) 
            echo "Usage: $0 [-h] [-f] "
            echo "-h - print this message" 
            echo "-f - clobber existing files"
            ;;
        -f) 
            COPY="cp -f"
            echo "existing files will be clobbered."
            ;;
    esac
done

echo "setting up claude files"
mkdir -p "$HOME/.claude"
$COPY "$REPO_DIR/coding-agent/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

for dir in agents commands skills; do
  mkdir -p "$HOME/.claude/$dir"
  $COPY -r "$REPO_DIR/coding-agent/$dir/." "$HOME/.claude/$dir/"
done

find "$HOME/.claude" -name '.gitkeep' -delete
find "$HOME/.claude" -name '.DS_Store' -delete

case $(basename $SHELL) in
  zsh)
    echo "copying zsh dotfiles" 
    echo "source $HOME/.zprofile" >> $HOME/.zshrc

    for file in $(ls $RCFILES/z*) ; do $COPY $file $HOME/".$(basename $file)" ; done
    ;;
  bash)
    echo "copying bash dotfiles" \
    $COPY "$RCFILES/bashrc" "$HOME/.bashrc"
    ;;
esac

FILES="gitconfig aliases vimrc"
echo "copying rest of dotfiles"
for file in $FILES ; do
  $COPY "$RCFILES/$file" "$HOME/.$file"
done

echo "installed Claude agent files and shell dotfiles into $HOME"
