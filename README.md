# Pounce
Provides custom command line functions tailored to the maintainer's liking.
Though the maintainer created it for himself, the *pounce* command line extensions are for everyone!

# Getting Started
## Prerequisites
1. Install R. See [Download and Install R](https://cloud.r-project.org/) (Windows users: https://cloud.r-project.org/bin/windows/base/).
1. Add *rscript.exe* to an environment variable. (Windows users: Search 'Edit environment variables for your account' then hit ENTER. Then click 'Environment Variables...'. Then--under 'User variables for {{USERNAME}}'--click on the 'Path' variable, then click 'Edit...'. Click 'New...' then click 'Browse...'. Navigate to 'path-to-r\R\R-#.#.#\bin' and click 'Ok'.)

## Installation
Open BASH to the location you'd like to clone the repo and then paste the following commands into the terminal:
```bash
# Clone the repo
git clone https://github.com/Ckrenzer/pounce.git;
cd pounce;
POUNCEPATH=${PWD};

# Store absolute path to pounce, source line control.sh to .bashrc if they are not already in .bashrc
cd ~
BASHRCFILE=".bashrc"
if [ ! -f "$BASHRCFILE" ]; then
    touch .bashrc
fi
grep -qxF "POUNCEPATH=\"${POUNCEPATH}\"" .bashrc || echo "POUNCEPATH=\"${POUNCEPATH}\"" >> .bashrc;
grep -qxF 'source "${POUNCEPATH}/control.sh"' .bashrc || echo 'source "${POUNCEPATH}/control.sh"' >> .bashrc
```

Once this is done, open a new instance of BASH, and these functions are ready to go!

## Updating Pounce

Just do an occasional `git pull` and you'll receive new functionality as it's developed!


# Commands
*Note: All commands have a help option. Type `command --help` to view it's help page.*


`ls`: Provides a prettier alternative to the shell's `ls()`.

`rename`: Renames files in the working directory based on a fixed pattern.

# Known Bugs and Issues

The installation commands will break in the event the repo was cloned twice and installed in a new directory.
This is due to the .bashrc file requiring `$POUNCEPATH` to be defined before the call to `source`. 
To fix this, simply remove the `POUNCEPATH="path/to/pounce"` and `source "${POUNCEPATH}/control.sh"` lines from the .bashrc file before performing a second installation.



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
