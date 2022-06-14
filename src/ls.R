# About -----------------------------------------------------------------------
# Author: Connor Krenzer
# Contact: Ckrenzer.info@gmail.com
# Date: 6/1/2022
# Description:
#   Prints information about files in the input directory to the console.


# Constants -------------------------------------------------------------------
NUM_BYTES_PER_KB <- 2^10
NUM_BYTES_PER_MB <- 2^20
NUM_BYTES_PER_GB <- 2^30
WD <- getwd()


# Functions -------------------------------------------------------------------
# Sets default values depending on the values the user sends at the CLI.
set_default_values <- function(arg, default_value){
  if(all(is.na(arg)) | all(arg == "") | length(arg) != 1){
    default_value
  } else {
    arg 
  }
}

# All file sizes below 1 Mb are portrayed in Kb.
determine_unit <- function(size){
  range_kb <- size < NUM_BYTES_PER_MB
  range_gb <- size > NUM_BYTES_PER_GB
  range_mb <- !(range_kb | range_gb)
  
  size[range_kb] <- size[range_kb] / NUM_BYTES_PER_KB
  size[range_mb] <- size[range_mb] / NUM_BYTES_PER_MB
  size[range_gb] <- size[range_gb] / NUM_BYTES_PER_GB
  
  formats <- character(length(size))
  formats[range_kb] <- "Kb"
  formats[range_mb] <- "Mb"
  formats[range_gb] <- "Gb"
  
  sprintf("%3s%.2f %s", "", size, formats)
}

# Determines the format to print files.
determine_message <- function(data, relative_path){
  if(!length(data) > 0){
    return(NULL)
  }
  
  datefmt <- "   %a, %b %d, %Y at %I:%M %p"
  # If the files are relative paths (defined as 'paths not starting in a drive'),
  # ensure the files and directories have the relative paths building up to them
  # (Ex. 'help/ls.txt' instead of just 'ls.txt').
  paths <- data
  if(!any(grepl(x = paths, "^[A-Z]:"))){
    paths <- paste(relative_path, data, sep = "/")
  }

  # Create a table with the file's:
  # name
  # formatted size
  # most-recent access time
  # most-recent modify time
  # time of creation
  info <- file.info(paths)
  info$file <- basename(rownames(info))
  info$size <- determine_unit(info$size)
  info$atime <- format(info$atime, format = datefmt)
  info$mtime <- format(info$mtime, format = datefmt)
  info$ctime <- format(info$ctime, format = datefmt)
  rownames(info) <- NULL
  info <- info[c("file", "size", "atime", "mtime", "ctime")]
  colnames(info) <- c("file", "size", "last_accessed", "last_modified", "created")
  
  # Cut out dates when the table is too wide for the terminal
  wiggle_room <- 5L
  for(datecol in c("created", "last_accessed", "last_modified")){
    exceeds_terminal_width <- any(nchar(do.call(paste, info)) + wiggle_room > width)
    if(exceeds_terminal_width){
      info[[datecol]] <- NULL
    }
  }
  
  # Only print when data is found
  if(nrow(info) > 0){
    print(info)
  }
  message("")
}


# Interpret Arguments ---------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)

# Determine the width of the terminal (it should be the first parameter passed)
# and then remove it from the args (to avoid interfering with the identification
# of other parameters).
width <- as.integer(args[[1]])
options(width = width)
args <- args[-1]

# Ensure args has a default value
if(length(args) == 0) args <- ""

# The help page.
if(any(args == "--help")){
  # Give an overview of the function.
  cat(readLines("help/ls.txt"), sep = "\n")
  # Terminate R session.
  q(save = "no")
}

# The subdirectory to perform the search
# (a forward slash should do b/c R lists
# directories using forward slashes and
# they are not allowed in file names,
# at least on Windows).
subdir <- grep(args, pattern = "/", fixed = TRUE, value = TRUE)
subdir <- set_default_values(arg = subdir, default_value = paste0(WD, "/"))

# The regular expression to filter the files in the directory.
#
# Defined by looking for the argument that does not start with
# a hyphen and is not a path to a directory.
#
# If a pattern is not found, assume the user wants to see all files.
patt <- setdiff(grep(x = args, pattern = "^-{1,2}", value = TRUE, invert = TRUE), subdir)
patt <- set_default_values(arg = patt, default_value = "")


# Get File Names --------------------------------------------------------------
# For whatever reason, list.files() still returns directory names after
# setting `include.dirs =` to FALSE.
dirs <- basename(list.dirs(path = subdir, recursive = FALSE))
files <- setdiff(list.files(path = subdir, pattern = patt, include.dirs = FALSE), dirs)
# Filter down to only those files and directories matching the pattern.
dirs <- grep(x = dirs, pattern = patt, value = TRUE)


# Print -----------------------------------------------------------------------
# File Info
message("FILES:")
invisible(determine_message(files, relative_path = subdir))

# Directory Info
message("DIRS:")
invisible(determine_message(dirs, relative_path = subdir))
