# Pounce
Custom command line functions tailored to the maintainer's liking.

# Getting Started
## Dependencies
1. The programming language R must be installed and added to the System Path.
    - Install R. See [Download and Install R](https://cloud.r-project.org/) (Windows users: https://cloud.r-project.org/bin/windows/base/).
    - Add *rscript.exe* to an environment variable. (Windows users: Search 'Edit environment variables for your account' then hit ENTER. Then click 'Environment Variables...'. Then--under 'User variables for {{USERNAME}}'--click on the 'Path' variable, then click 'Edit...'. Click 'New...' then click 'Browse...'. Navigate to 'path-to-r\R\R-#.#.#\bin' and click 'Ok'. You could greatly simplify this process by using chocolatey.)

## Installation
Clone this repo onto your device and add the path to the cloned directory
to your bashrc file.

Pasting the following lines below will clone the
repo into `~/.local/shell_extensions`:
```bash
# Clone the repo into ~/.local/shell_extensions
mkdir -p ~/.local/shell_extensions
cd ~/.local/shell_extensions
git clone https://github.com/Ckrenzer/pounce.git;
```
To add *pounce* functionality to your bash shell,
add the following lines to your .bashrc file:
```bash
POUNCEPATH="~/.local/shell_extensions/pounce";
source ${POUNCEPATH}/control.sh;
```

Once this is done, open a new instance of BASH, and these functions are ready to go!

## Updating Pounce

Just do an occasional `git pull` and you'll receive new functionality as it's developed!
```bash
# This'll do the trick
cd ~/.local/shell_extensions/pounce
git pull
cd -
```

# Commands
*Note: All commands have a help option. Type `command --help` to view it's help page.*


`ls`: Provides a prettier alternative to the shell's `ls()`.

`rename`: Renames files in the working directory based on a fixed pattern.

# Known Bugs and Issues

The installation commands will break in the event the repo was cloned twice and installed in a new directory.
This is due to the bashrc file requiring `$POUNCEPATH` to be defined before the call to `source`. 
To fix this, simply remove the `POUNCEPATH="path/to/pounce"` and `source "${POUNCEPATH}/control.sh"` lines from the bashrc file before performing a second installation.



# File Hierarchy
```bash
├── help
│   └── ls.txt
│   └── rename.txt
├── src
│   └── ls/
│   │   └── ls.R
│   └── rename/
│       └── rename.R
├── test
│   └── test_ls.R
│   └── test_rename.R
├── control.sh
├── README.md
├── LICENSE
└── .gitignore
```

**src:** Contains code used to implement all functionality in *pounce*.

**control.sh:** Provides a wrapper around the code in **scripts/** to easily integrate with the command line.

**test:** Contains unit tests to ensure the functions work as intended.
