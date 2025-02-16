# WCX - Workflow C++ with CMake
_______________________________________________________________________________________________________________

                              Script to manage and build C/C++ projects using CMake
                                              Author: KDZ7
                                              Version: 1.0
                                              License: Apache 2.0
_______________________________________________________________________________________________________________

WCX is a Bash script that simplifies the creation and management of C++ projects based on CMake.

> Not professional, Just create quick libraries and executables

## Requirements

- CMake
- Make
- C/C++ Compiler (GCC, Clang, MINGW, or MSVC)
- Bash Command Line Tools (WSL, MSYS2, Cygwin, Git Bash, etc.)

## Project Organization

### Overview
```
project1.wcx/
├── packages/           # Source code and configuration
│   ├── library1/       # Library component
│   ├── executable1/    # Executable component
│   └── pack.dep        # Dependency configuration
├── build/              # Build artifacts
└── install/            # Installation files
```

### Detailed Structure
```
project1.wcx/
├── packages/
│   ├── library1/                                  # Library component
│   │   ├── CMakeLists.txt                         # Component configuration
│   │   ├── include/
│   │   │   └── library1.hpp                       # Header Files
│   │   └── src/
│   │       └── library1.cpp                       # Implementation
│   ├── executable1/                               # Executable component
│   │   ├── CMakeLists.txt                         # Component configuration
│   │   ├── include/                               # Header Files
│   │   └── src/
│   │       └── executable1.cpp                    # Implementation
│   └── pack.dep                                   # Dependencies definition (Automatic update with <-dep> option)
├── build/
│   ├── library1/                                  # Library build files
│   │   ├── CMakeFiles/                            # CMake temporary files
│   │   ├── liblibrary1.so                         # Built library
│   │   ├── CMakeCache.txt                         # CMake cache
│   │   └── Makefile                               # Generated makefile
│   └── executable1/                               # Executable build files
│       ├── CMakeFiles/                            # CMake temporary files
│       ├── executable1                            # Built executable
│       ├── CMakeCache.txt                         # CMake cache
│       └── Makefile                               # Generated makefile
└── install/
    ├── library1/                                  # Installed library files
    │   ├── cmake/                                 # CMake configuration(Useful for find_package(..))
    │   │   ├── library1-config.cmake
    │   │   ├── library1-config-release.cmake
    │   │   └── library1-config-version.cmake
    │   ├── include/                               # Installed headers
    │   │   └── library1.hpp
    │   └── lib/                                   # Installed binaries
    │       └── liblibrary1.so
    └── executable1/                               # Installed executable
        ├── bin/                                   # Binaries
        │   └── executable1
        └── cmake/                                 # CMake configuration(To deactivate if not needed on the executable)
            ├── executable1-config.cmake
            ├── executable1-config-release.cmake
            └── executable1-config-version.cmake
```

## Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Display this help and exit |
| `-n, --new` | Create a new project |
| `-lib, --library` | Create a new library |
| `-exec, --executable` | Create a new executable |
| `-dep, --depend` | Add dependency libraries |
| `-b, --build` | Build the project |
| `-bd, --build-debug` | Build the project in debug mode |
| `-br, --build-release` | Build the project in release mode |
| `-w, --warning` | Enable the warnings while building |
| `-opt, --optimization` | Specify the optimization level (default: 2) |
| `-cb, --clean-build` | Rebuild the project (clean and build) |
| `-r, --run` | Run the executable |
| `-c, --clean` | Clean the build |
| `-d, --delete` | Delete the project |
| `-v, --version` | Display the version of the script |
| `-cxx, --c++` | Specify the C++ standard version (default: 17) |
| `-verb, --verbose` | Enable verbose while building |

## Dependencies (-dep)

The -dep flag is crucial - it separates new components from their dependencies:

### Format
```bash
wcx -n project \
  [components to create] \    # Before -dep
  -dep \                      # Dependency marker
  [required dependencies]     # After -dep
```

### Examples with Dependencies
```bash
# Library depending on other libraries
wcx -n project -lib library1 -dep -lib library2 -lib library3

# Multiple libraries with shared dependencies
wcx -n project \
  -lib library1 \
  -lib library2 \
  -dep \
  -lib library3 \
  -lib library4

# Executable with library dependencies
wcx -n project \
  -exec executable1 \
  -dep \
  -lib library1 \
  -lib library2
```

### Common Patterns

1. Create libraries first:
```bash
wcx -n project -lib library1 -lib library2
```

2. Add dependencies:
```bash
wcx project -lib library3 -dep -lib library1 -lib library2
```

3. Create executables with dependencies:
```bash
wcx project -exec executable1 -dep -lib library1 -lib library2 -lib library3
```

## Build and Run

### Build Options
```bash
# Standard build
wcx -b project

# Build with optimizations and warnings
wcx -b project -opt 3 -w

# Debug/Release builds
wcx -bd project  # Debug
wcx -br project  # Release
wcx -cb project  # Clean and build
```

### Run
```bash
wcx -r project executable1
```

### Clean/Delete
```bash
wcx -c project   # Clean build files
wcx -d project   # Delete entire project
```

## Understanding pack.dep

The pack.dep file defines component dependencies:

```
# Basic chain
library2:
library1: library2
executable1: library1 library2

# Multiple dependencies
library_core:
library_utils: library_core
library_gui: library_utils library_core
executable_app: library_gui library_utils library_core
```

WCX uses this file to:
1. Determine build order
2. Configure CMake dependencies
3. Link components correctly

## License

Apache License 2.0