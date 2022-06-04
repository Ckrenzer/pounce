# About -----------------------------------------------------------------------
# Author: Connor Krenzer
# Contact: Ckrenzer.info@gmail.com
# Date: 6/1/2022
# Description:
#   Prints information about files in the input directory to the console.


# Settings --------------------------------------------------------------------
options(width = 125)


# Constants -------------------------------------------------------------------
NUM_BYTES_PER_KB <- 2^10
NUM_BYTES_PER_MB <- 2^20
NUM_BYTES_PER_GB <- 2^30


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
determine_message <- function(data, use_long_format){
  if(use_long_format){
    
    datefmt <- "   %a, %b %d, %Y at %I:%M %p"
    # Create a table with the file's:
    # name
    # formatted size
    # most-recent access time
    # most-recent modify time
    # time of creation
    info <- file.info(data)
    info$file <- rownames(info)
    info$size <- determine_unit(info$size)
    info$atime <- format(info$atime, format = datefmt)
    info$mtime <- format(info$mtime, format = datefmt)
    info$ctime <- format(info$ctime, format = datefmt)
    rownames(info) <- NULL
    info <- info[c("file", "size", "atime", "mtime", "ctime")]
    colnames(info) <- c("file", "size", "last_accessed", "last_modified", "created")
    
    print(info)
    message("")
    return(NULL)
  }
  message(sprintf("\t%s\n", sort(data)))
}


# Interpret Arguments ---------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
if(length(args) == 0) args <- ""

# The help page.
if(any(args == "--help")){
  
  # Give an overview of the function.
  message("Provides information about the files in the input directory.")
  message("The order in which the arguments are provided does not matter.\n")
  
  # Argument descriptions.
  input_options <- c("--help",
                     "<<path>>",
                     "<<regex>>",
                     "-l")
  input_desc <- c("Prints this help page.",
                  sprintf("%s %s\n\t\t\tNote: %s",
                          "The path to the directories (defaults to pwd).",
                          "Accepts both relative and absolute paths.",
                          "SPECIFIED DIRECTORIES MUST CONTAIN A FORWARD SLASH (/)!"),
                  sprintf("%s %s\n\t\t\tNote: %s %s",
                          "A regular expression identifying the files to use.",
                          "Leave blank to identify all files.",
                          "Accepts a regex using the syntax of R, not BASH.",
                          "Place pattern in quotes if the pattern contains whitespace."),
                  "Prints a table with file sizes and various file dates.")
  message(sprintf("%10s   %s\n", input_options, input_desc))
  
  # Examples.
  message("Examples:")
  message(sprintf("  %s\n\t%s",
                  "List all files in C:/Users",
                  "ls C:/Users"))
  message(sprintf("  List all files in a subdirectory called 'projects/'\n\t%s",
                  "ls projects/"))
  message(sprintf("  List all text files in the current directory\n\t%s",
                  "ls \\\\.txt$"))
  message(sprintf("  List all .csv files in a subdirectory called 'csv data/'\n\t%s",
                  "ls \"csv data/\" \\\\.csv$"))
  
  # Terminate R session.
  q(save = "no")
}

# Determines whether the user chose the long listing format.
verbose <- any(args == "-l")

# The subdirectory to perform the search
# (a forward slash should do b/c R lists
# directories using forward slashes and
# they are not allowed in file names,
# at least on Windows).
subdir <- grep(args, pattern = "/", fixed = TRUE, value = TRUE)
subdir <- set_default_values(arg = subdir, default_value = getwd())

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
invisible(determine_message(files, verbose))

# Directory Info
message("DIRS:")
invisible(determine_message(dirs, verbose))
