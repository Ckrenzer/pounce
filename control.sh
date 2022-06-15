#!/bin/bash

printf "\n\nWarning: Some shell functions have been hidden to pave way for Pounce functionality.\n"
printf "You can effectively remove Pounce by commenting out the Pounce source call in the .bashrc file."


# Wrappers
# Custom version of the `ls` command
function ls(){
  rscript "${POUNCEPATH}/src/ls/ls.R" "${COLUMNS}" "$@"
}
