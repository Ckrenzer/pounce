# Pounce
Provides custom command line functions tailored to the maintainer's liking.
The *pounce* command line extensions are hosted here for anyone to use.


# Getting Started



# File Hierarchy
```bash
├── src
│   ├── control.sh
│   └── scripts
│        └── ls.R
├── test
├── README.md
├── LICENSE
└── .gitignore
```

## About

**src:** Contains files used to implement all functionality in *pounce*.
1. **scripts:** Contains the code used in the command line extensions.
1. **control.sh:** Provides a wrapper around the code in **scripts/** to easily integrate with the command line.

**test:** Contains unit tests to ensure the functions work as intended.
