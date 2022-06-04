#!/bin/bash

# Wrappers
# Custom version of the `ls` command
function ls(){
  rscript "${pouncepath}/src/ls.R" "$@"
}
