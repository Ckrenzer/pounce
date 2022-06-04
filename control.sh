#!/bin/bash

# Variables
# Stores the absolute path to this script.
pouncepath="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

# Wrappers
# Custom version of the `ls` command
function ls(){
  rscript "${pouncepath}/src/ls.R" "$@"
}
