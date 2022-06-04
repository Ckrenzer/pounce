#!/bin/bash

# Wrappers
# Custom version of the `ls` command
function ls(){
  rscript "${POUNCEPATH}/src/ls.R" "$@"
}
