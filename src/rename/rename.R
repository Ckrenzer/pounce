# About -----------------------------------------------------------------------
# Author: Connor Krenzer
# Contact: Ckrenzer.info@gmail.com
# Date: 6/14/2022
# Description:
#   Replaces a fixed pattern in a file name.
#
# Notes:
#   base::list.files() acts weird with a fixed pattern, so all the files are listed
#   and the desired pattern will be caught with grep().


# Interpret Arguments ---------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
# The path to pounce is always the first argument passed.
POUNCEPATH <- args[[1]]
args <- args[-1]

# The help page.
if(any(args == "--help")){
  # Give an overview of the function.
  cat(readLines(paste(POUNCEPATH, "help/rename.txt", sep = "/")), sep = "\n")
  # Terminate R session.
  q(save = "no")
}


# Rename Files ---------------------------------------------------------------
inputs <- tail(args, 2)
cat("\nFiles renamed from:\n")
files_to_rename <- base::list.files(path = getwd(), full.names = FALSE)
files_to_rename <- grep(x = files_to_rename, pattern = inputs[1], fixed = TRUE, value = TRUE)
newnames <- gsub(x = files_to_rename, pattern = inputs[1], replacement = inputs[2], fixed = TRUE)
cat(files_to_rename, sep = "\n")
cat("\nto:\n")
invisible(file.rename(files_to_rename, newnames))
cat(newnames, sep = "\n")
