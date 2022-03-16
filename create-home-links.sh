#!/bin/sh
for x in "$(pwd)"/.*
do
  echo ln -s "$x" "$HOME/$(basename "$x")"
done
