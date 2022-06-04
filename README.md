# Pounce
Provides custom command line functions tailored to the maintainer's liking.
Though the maintainer created it for himself, the *pounce* command line extensions are for everyone!


# Getting Started



# File Hierarchy
```bash
├── src
│   └── ls.R
├── control.sh
├── test
├── README.md
├── LICENSE
└── .gitignore
```

**src:** Contains files used to implement all functionality in *pounce*.
1. **scripts:** Contains the code used in the command line extensions.

**control.sh:** Provides a wrapper around the code in **scripts/** to easily integrate with the command line.

**test:** Contains unit tests to ensure the functions work as intended.
