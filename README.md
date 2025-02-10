# WCX - Simple Script for Your C/C++ Projects with CMake

## **Introduction**

`wcx.sh` is a small Bash script designed to help developers quickly get started with C++ projects based on CMake. It aims to avoid lengthy configurations and simplify your workflow.

It is based on the principle of organizing projects into packages to structure and compile your code. You can easily build dynamic libraries and executables while customizing your `CMakeLists.txt` files if needed.

---

## **Installation**

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/wcx.git
   cd wcx
   ```
2. Make the script executable:
   ```bash
   chmod +x wcx.sh
   ```

---

## **Main Commands**

### **Create a Project**

Create a project with an executable and/or libraries:

```bash
./wcx.sh -n project.wcx -lib math -lib stream -exec executable
```

### **Build the Project**

Compile the project:

```bash
./wcx.sh -b project.wcx
```

### **Run a Program**

Run a generated executable:

```bash
./wcx.sh -r project.wcx executable
```

### **Clean Build Files**

Remove generated files:

```bash
./wcx.sh -c project.wcx
```

---

## **Example Directory Structure**

Here is the directory structure generated for a project with a `math` library, a `stream` library, and an `executable`:

```
project.wcx/
├── build/                # Files generated during compilation
├── install/              # Installed files (generated)
├── CMakeLists.txt        # Main configuration
├── packages/
│   ├── executable/
│   │   ├── CMakeLists.txt
│   │   ├── include/
│   │   │   └── executable.hpp
│   │   └── src/
│   │       └── executable.cpp
│   ├── math/
│   │   ├── CMakeLists.txt
│   │   ├── include/
│   │   │   └── math.hpp
│   │   └── src/
│   │       └── math.cpp
│   └── stream/
│       ├── CMakeLists.txt
│       ├── include/
│       │   └── stream.hpp
│       └── src/
│           └── stream.cpp
└── wcx.sh                # Main script
```

---

## **Quick Example**

1. **Create a Project**

   ```bash
   ./wcx.sh -n project.wcx -lib math -lib stream -exec executable
   ```

   **Output:**
   ```bash
   Creating project: project.wcx
   Adding library: math
   Adding library: stream
   Adding executable: executable
   ```

2. **Build and Run**

   - Build the project:
     ```bash
     ./wcx.sh -b project.wcx
     ```
     **Output:**
     ```bash
     Building project: project.wcx
     Compilation successful.
     ```
   - Run the executable:
     ```bash
     ./wcx.sh -r project.wcx executable
     ```
     **Output:**
     ```bash
     Running executable: project.wcx/build/executable
     Hello from executable!
     ```

