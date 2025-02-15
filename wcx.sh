#!/bin/bash

# _________________________________________________________________________
# Script to organize the workflow of creating and building C/C++ with CMake
# _________________________________________________________________________
# Author: 	KDZ7
# _________________________________________________________________________

show_help() {
    echo "Usage: $0 [option...] "
    echo "_______________________________________________________________________________________________________________"
    echo "_______________________________________________________________________________________________________________"
    echo "                                         WCX - Workflow C/C++ with CMake                                       "
    echo "                              Script to manage and build C/C++ projects using CMake                            "
    echo "                                              Author: KDZ7                                                     "
    echo "                                              Version: ${__WCX_VERSION}                                        "
    echo "                                              License: Apache 2.0                                              "
    echo "_______________________________________________________________________________________________________________"
    echo "_______________________________________________________________________________________________________________"
    echo "Requirements:                                                                                                  "
    echo "  - CMake                                                                                                      "
    echo "  - Make                                                                                                       "
    echo "  - C/C++ Compiler (GCC, Clang, MINGW, or MSVC)                                                                "
    echo "  - Bash Command Line Tools (WSL, MSYS2, Cygwin, Git Bash, etc.)                                               "
    echo "_______________________________________________________________________________________________________________"
    echo "                    !!!   Not professional, Just create quick libraries and executables    !!!                 "
    echo "_______________________________________________________________________________________________________________"
    echo "Options:                                                                                                       "
    echo "  -h, --help            Display this help and exit                                                             "
    echo "  -n, --new             Create a new project                                                                   "
    echo "  -lib, --library       Create a new library                                                                   "
    echo "  -exec, --executable   Create a new executable                                                                "
    echo "  -dep, --depend        Add dependency libraries                                                               "
    echo "  -b, --build           Build the project                                                                      "
    echo "  -bd, --build-debug    Build the project in debug mode                                                        "
    echo "  -br, --build-release  Build the project in release mode                                                      "
    echo "  -w,  --warning        Enable the warnings while building                                                     "
    echo "  -opt, --optimization  Specify the optimization level (default: 2)                                            "
    echo "  -cb, --clean-build    Rebuild the project (clean and build)                                                  "
    echo "  -r, --run             Run the executable                                                                     "
    echo "  -c, --clean           Clean the build                                                                        "
    echo "  -d, --delete          Delete the project                                                                     "
    echo "  -v, --version         Display the version of the script                                                      "
    echo "  -cxx, --c++           Specify the C++ standard version (default: 17)                                         "
    echo "  -verb, --verbose      Enable verbose while building                                                          "
    echo "_______________________________________________________________________________________________________________"
    echo "                          Examples to quick start a project with libraries/executables                         "
    echo "_______________________________________________________________________________________________________________"
    echo "                                            Create a new project                                               "
    echo "_______________________________________________________________________________________________________________"
    echo "      1. Simple project creation                                                                               "
    echo "      - wcx.sh -n [project]                                                                                    "
    echo "      - wcx.sh -n [project] -lib [library_1] -exec [executable_1]                                              "
    echo "                                                                                                               "
    echo "      2. Project with multiple libraries/executables                                                           "
    echo "      - wcx.sh -n [project] -lib [library_1] -lib [library_2] -cxx 20                                          "
    echo "      - wcx.sh -n [project] -exec [executable_1] -exec [executable_2]                                          "
    echo "                                                                                                               "
    echo "      3. Project with dependency libraries                                                                     " 
    echo "      - wcx.sh -n [project] -lib [library_1] -dep -lib [library_2] -lib [library_3]                            "
    echo "      - wcx.sh -n [project] -lib [library_1] -lib [library_2] -dep -lib [library_3] -lib [library_4]           "
    echo "      - wcx.sh -n [project] -exec [executable_1] -dep -lib [library_1] -lib [library_2]                        "
    echo "      - wcx.sh -n [project] -exec [executable_1] -exec [executable_2] -dep -lib [library_1] -lib [library_2]   "
    echo "_______________________________________________________________________________________________________________"
    echo "                                         Work with existing project                                            "
    echo "_______________________________________________________________________________________________________________"
    echo "      1. Add libraries/executables to existing project                                                         "
    echo "      - wcx.sh [project] -lib [library_1] -lib [library_2] -cxx 20                                             "
    echo "      - wcx.sh [project] -exec [executable_1] -exec [executable_2]                                             "
    echo "      - wcx.sh [project] -lib [library_1] -lib [library_2] -exec [executable_1] -exec [executable_2] -cxx 20   "
    echo "                                                                                                               "
    echo "      2. Add dependency libraries to existing project                                                          "
    echo "      - wcx.sh [project] -lib [library_1] -dep -lib [library_2] -lib [library_3]                               "
    echo "      - wcx.sh [project] -lib [library_1] -lib [library_2] -dep -lib [library_3] -lib [library_4]              "
    echo "      - wcx.sh [project] -exec [executable_1] -dep -lib [library_1] -lib [library_2]                           "
    echo "      - wcx.sh [project] -exec [executable_1] -exec [executable_2] -dep -lib [library_1] -lib [library_2]      "
    echo "_______________________________________________________________________________________________________________"
    echo "                                        Build/Run/Clean the project                                            "
    echo "_______________________________________________________________________________________________________________"
    echo "      - wcx.sh -b  [project] -opt 3                                                                            "
    echo "      - wcx.sh -b  [project] -opt 3 -w                                                                         "
    echo "      - wcx.sh -b  [project] -opt 3 -w -verb                                                                   "   
    echo "      - wcx.sh -bd [project]                                                                                   "
    echo "      - wcx.sh -br [project]                                                                                   "
    echo "      - wcx.sh -cb [project]                                                                                   "
    echo "      - wcx.sh -r  [project] [executable]                                                                      "
    echo "      - wcx.sh -c  [project]                                                                                   "
    echo "      - wcx.sh -d  [project]                                                                                   "
    echo "_______________________________________________________________________________________________________________"
}

__template_header='
#_____________________________________________________________________________________________________________________________________________________________________________________________
#                                             Generated by WCX - Workflow C/C++ with CMake
#                                                             Author: KDZ7
#_____________________________________________________________________________________________________________________________________________________________________________________________
#_____________________________________________________________________________________________________________________________________________________________________________________________
#                                                  Default template for CMakeLists.txt
#                                         Template for to have a shared library in the project
#                                                You can modify the template as you wish
# 
#                                        !!! The variable start with '__WCX' modify carefully !!!
#_____________________________________________________________________________________________________________________________________________________________________________________________
'
__template_section_compiler_configuration='
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                     SECTION: Compiler Configuration 
# ___________________________________________________________________________________________________________________________________________________________________________________________

# C++ standard
set(CMAKE_CXX_STANDARD ${__WCX_CXX_STANDARD}) 
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Optimization level (Default: O${__WCX_OPTIMIZATION})
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O${__WCX_OPTIMIZATION}")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O${__WCX_OPTIMIZATION}")

# Add compiler warning flags
if(__WCX_WARNING)
    if(MSVC)
    # MSVC warning configuration 
        target_compile_options(
            ${__TARGET_NAME}
            PRIVATE 
            /W4                                                              # Warning level 4
            /WX                                                              # Treat warnings as errors
            /permissive-                                                     # Strict standard compliance
        )
    else()
    # GCC/Clang/.. warning configuration
        target_compile_options(
            ${__TARGET_NAME}
            PRIVATE
            -Wall                                                            # Enable all basic warnings
            -Wextra                                                          # Enable extra warnings
            -Wpedantic                                                       # Strict ISO C/C++ compliance
            -Werror                                                          # Treat warnings as errors
            -Wconversion                                                     # Warn about implicit conversions
            -Wshadow                                                         # Warn about shadowed variables
        )
    endif()
else()
# Minimal warnings configuration (Default mode)
    if(NOT MSVC)
        target_compile_options(
            ${__TARGET_NAME}
            PRIVATE
            -Wno-unused-parameter                                            # Disable unused parameter warning
            -Wno-unused-variable                                             # Disable unused variable warning
        )
    endif()
endif()
'

__template_section_preprocessor_configuration() {
    local target_name=$1
    cat << EOF
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                SECTION: Preprocessor Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________
# Add compile definitions for preprocessing
target_compile_definitions(
    \${__TARGET_NAME}
    PRIVATE
    __${target_name^^}_EXPORTS__                                               # Custom macro definition                                                       
)
EOF
}

__template_section_dependencies_configuration() {
    local dependencies=("$@")
    local sp=""
    if [ ${#dependencies[@]} -eq 0 ]; then
        sp="#"
    else
        sp=" "
    fi
    cat << EOF
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                 SECTION: Dependencies Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________
$(
echo "# Add the dependencies packages if needed"
for dep in "${dependencies[@]}"; do
    echo "${sp} find_package(${dep} REQUIRED)"
done
echo "# find_package(package_name REQUIRED)"
echo "
# Link the external libraries if needed
${sp} target_link_libraries(
${sp}   \${__TARGET_NAME}
${sp}   PUBLIC"
for dep in "${dependencies[@]}"; do
    echo "${sp}   ${dep}::${dep}"
done
echo "#   external_library"
echo "#   namespace::external_library"
echo "${sp})"
)
EOF
}

__template_version_configuration='
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                    SECTION: Version Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________
# Set the version of the project
set(${__TARGET_NAME}_VERSION ${__WCX_PACKAGE_VERSION})

# Generate the package version file
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${__TARGET_NAME}-config-version.cmake
    VERSION ${${__TARGET_NAME}_VERSION}
    COMPATIBILITY AnyNewerVersion
)

# Install the package version file
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/${__TARGET_NAME}-config-version.cmake
    DESTINATION ${__WCX_EXPORT_DESTINATION}
)
'

__template_export_configuration='
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                   SECTION: Export Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________
# Export the targets

install(
    EXPORT ${__TARGET_NAME}-targets
    FILE ${__TARGET_NAME}-config.cmake
    NAMESPACE ${__TARGET_NAME}::
    DESTINATION ${__WCX_EXPORT_DESTINATION}
)
'

__template_build_information='
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                   SECTION: Build Information
# ___________________________________________________________________________________________________________________________________________________________________________________________
# Print the build information
message(STATUS "Project: ${__PROJECT_NAME}")
message(STATUS "Target: ${__TARGET_NAME}")
message(STATUS "Version: ${${__TARGET_NAME}_VERSION}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "Optimization Level: O${__WCX_OPTIMIZATION}")
message(STATUS "Compiler Warnings: ${__WCX_WARNING}")
'


estimate_cmake_minimum_required() {
    local current_version=$(cmake --version | head -n 1 | cut -d ' ' -f 3)
    local major_version=$(echo $current_version | cut -d '.' -f 1)
    local minor_version=$(echo $current_version | cut -d '.' -f 2)
    local min_minor_version=$((minor_version - 10))
    if [ $minor_version -lt 0 ]; then
        min_minor_version=0
    fi
    # Return estimated version
    echo "${major_version}.${min_minor_version}"
}

template_cmake_library() {
    local project_name=$1
    local library_name=$2
    local dependencies=("${@:3}")
    local min_version=$(estimate_cmake_minimum_required)

    cat > CMakeLists.txt << EOF
${__template_header}
cmake_minimum_required(VERSION ${min_version})

set(__PROJECT_NAME ${project_name})
set(__TARGET_NAME ${library_name})

project(\${__PROJECT_NAME})

# Set global configuration variables
set(__WCX_CXX_STANDARD ${__WCX_CXX_STANDARD})
set(__WCX_OPTIMIZATION ${__WCX_OPTIMIZATION})
set(__WCX_WARNING ${__WCX_WARNING})
set(__WCX_PACKAGE_VERSION "1.0.0")
set(__WCX_EXPORT_DESTINATION cmake/)                                                

# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                     SECTION: Library Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________

# Create the shared library
add_library(
    \${__TARGET_NAME}
    SHARED
    src/\${__TARGET_NAME}.cpp
) 

# Include library header files
target_include_directories(
    \${__TARGET_NAME}                                                      
    PUBLIC
    \$<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include>     
    \$<INSTALL_INTERFACE:include>                                           
)
${__template_section_compiler_configuration}
$(__template_section_preprocessor_configuration ${library_name})
$(__template_section_dependencies_configuration ${dependencies[@]})
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                  SECTION: Installation Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________
# Install the library
install(
    TARGETS \${__TARGET_NAME}
    EXPORT \${__TARGET_NAME}-targets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
)

# Install the header files
install(
    DIRECTORY include/
    DESTINATION include
    FILES_MATCHING PATTERN "*.hpp" 
)
${__template_version_configuration}
${__template_export_configuration}
${__template_build_information}
EOF
}

template_cmake_executable() {
    local project_name=$1
    local executable_name=$2
    local dependencies=("${@:3}")
    local min_version=$(estimate_cmake_minimum_required)

    cat > CMakeLists.txt << EOF
${__template_header}
cmake_minimum_required(VERSION ${min_version})

set(__PROJECT_NAME ${project_name})
set(__TARGET_NAME ${executable_name})

project(\${__PROJECT_NAME})

# Set global configuration variables
set(__WCX_CXX_STANDARD ${__WCX_CXX_STANDARD})
set(__WCX_OPTIMIZATION ${__WCX_OPTIMIZATION})
set(__WCX_WARNING ${__WCX_WARNING})
set(__WCX_PACKAGE_VERSION "1.0.0")
set(__WCX_EXPORT_DESTINATION cmake/)

# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                     SECTION: Executable Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________

# Create the executable
add_executable(
    \${__TARGET_NAME}
    src/\${__TARGET_NAME}.cpp
)

# Include the header files for the executable
target_include_directories(
    \${__TARGET_NAME}                                                      
    PRIVATE
    \${CMAKE_CURRENT_SOURCE_DIR}/include
)
${__template_section_compiler_configuration}
$(__template_section_preprocessor_configuration ${executable_name})
$(__template_section_dependencies_configuration ${dependencies[@]})
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                  SECTION: Installation Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________
# Install the executable
install(
    TARGETS \${__TARGET_NAME}
    EXPORT \${__TARGET_NAME}-targets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)
${__template_version_configuration}
${__template_export_configuration}
${__template_build_information}
EOF
}


template_class_library() {
    local project_name=$1
    local library_name=$2
    local class_name=$3
    local dependencies=("${@:4}")

    cat > "include/${class_name}.hpp" << EOF
#ifndef __${class_name^^}_HPP__
#define __${class_name^^}_HPP__

#if defined(_WIN32) || defined(_WIN64)
    #ifdef __${library_name^^}_EXPORTS__
        #define ${library_name^^}_API __declspec(dllexport)
    #else
        #define ${library_name^^}_API __declspec(dllimport)
    #endif
#else
    #define ${library_name^^}_API __attribute__((visibility("default")))
#endif

$(for dep in "${dependencies[@]}"; do echo "#include \"${dep}.hpp\""; done)

namespace ${library_name} {
    class ${library_name^^}_API ${class_name} {
        public:
            explicit ${class_name}(int count = 0);
            virtual ~${class_name}();
            void hello();

        private:
$(for dep in "${dependencies[@]}"; do echo -e "\t\t\t${dep}::${dep} _${dep}_instance;"; done)
            int _count;
    };
} // namespace ${library_name}
#endif // __${class_name^^}_HPP__
EOF
    cat > "src/${class_name}.cpp" << EOF
#include <iostream>
#include "${class_name}.hpp"

namespace ${library_name} {
    ${class_name}::${class_name}(int count) : _count(count)
$(for dep in "${dependencies[@]}"; do echo -e "\t\t\t\t\t\t,_${dep}_instance(count)"; done)
    {
        // Constructor
    }

    ${class_name}::~${class_name}() 
    {
        // Destructor
    }

    void ${class_name}::hello() {
        std::cout << std::endl << _count << ". Hello from ${class_name}!" << std::endl;
$(for dep in "${dependencies[@]}"; do echo -e "\t\t_${dep}_instance.hello();"; done)
        _count++;
    }
} // namespace ${library_name}
EOF
}

template_executable() {
    local project_name=$1
    local executable_name=$2
    local dependencies=("${@:3}")

    cat > "src/${executable_name}.cpp" << EOF
#include <iostream>
#include <chrono>
#include <thread>

$(for dep in "${dependencies[@]}"; do echo "#include \"${dep}.hpp\""; done)

int main() {
    int count = 0;
$(for dep in "${dependencies[@]}"; do echo -e "\t${dep}::${dep} ${dep}_instance(count);"; done)
    while(true) {
        std::cout << std::endl << count << ". Hello from ${executable_name}!" << std::endl;
$(for dep in "${dependencies[@]}"; do echo -e "\t\t${dep}_instance.hello();"; done)
        count ++;
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
    return 0;
}
EOF
}

# Default configuration (__WCX_GLOBAL_VARIABLES__)
__WCX_CXX_STANDARD="17"
__WCX_OPTIMIZATION="2"
__WCX_BUILD_TYPE="Release"
__WCX_VERBOSE_MAKEFILE="OFF"
__WCX_WARNING="OFF"
__WCX_VERSION="1.0"

create_project() {
    local project_name=$1
    local cpath="$(pwd)"
    local path_project="$cpath/$project_name"
    
    # Create the source packages directory tree
    mkdir -p "$path_project"/packages

    echo "Project '$project_name' created"
}

pack_dep() {
    local path_depfile=$1
    local target_name=$2
    local dependencies=("${@:3}")

    # Remove the target line if it exists
    sed -i "/^${target_name}:/d" "$path_depfile" 2>/dev/null

    # Prepare dependency line
    local dep_line="${target_name}:"
    for dep in "${dependencies[@]}"; do
        dep_line+=" ${dep}"
    done
    
    # Add to dep file
    echo "$dep_line" >> "$path_depfile"
}

manage_dep() {
    local path_depfile=$1
    local pack=$2
    local chain=$3
    local -n procs_ref=$4
    local -n packs_ref=$5
    local -n ret_ref=$6

    if [[ " $chain " == *" $pack "* ]]; then
        echo "[ERROR] Circular dependency detected" >&2
        echo "- Package: $pack" >&2
        echo "- Conflict dependencies: $chain $pack" >&2
        return 1
    fi
    
    # Check if the process is already handled
    [[ -n "${procs_ref[$pack]}" ]] && return

    # Process dependencies first
    for dep in ${packs_ref[$pack]}; do
        [[ -n "$dep" ]] && manage_dep "$path_depfile" "$dep" "$chain $pack" "$4" "$5" "$6"
    done

    # Add the package
    if [ -f "$path_depfile" ]; then
        procs_ref["$pack"]="X"
        ret_ref+=( "$pack" )
    fi
}

resolve_dep() {
    local path_depfile=$1
    local -A procs=()
    local -A packs=()
    local ret=()

    # Load package dependencies from specified dep file
    while IFS=':' read -r target deps; do
        it=$(echo "$target" | xargs)
        [[ -n "$it" ]] && packs["$it"]="$(echo "$deps" | xargs)"
    done < "$path_depfile"

    # Manage the build order of packages
    for pack in "${!packs[@]}"; do
        manage_dep "$path_depfile" "$pack" "" procs packs ret
    done

    echo "${ret[@]}"
}

create_library() {
    local project_name=$1
    local library_name=$2
    local class_name=$3
    local dependencies=("${@:4}") 
    local cpath="$(pwd)"
    local path_target="$cpath/$project_name/packages/$library_name"
    local path_depfile="$cpath/$project_name/packages/pack.dep"

    # Create the target directory tree
    mkdir -p "$path_target"/{include,src}

    # Update dependency order
    pack_dep "$path_depfile" "$library_name" "${dependencies[@]}"

    # Create library's CMakeLists.txt
    cd "$path_target"
    template_cmake_library "$project_name" "$library_name" "${dependencies[@]}"

    # Create a class for the library
    template_class_library "$project_name" "$library_name" "$class_name" "${dependencies[@]}"

    cd "$cpath"

    echo "Library '$library_name' created"
}

create_executable() {
    local project_name=$1
    local executable_name=$2
    local dependencies=("${@:3}")
    local cpath="$(pwd)"
    local path_target="$cpath/$project_name/packages/$executable_name"
    local path_depfile="$cpath/$project_name/packages/pack.dep"

    # Create the target directory tree
    mkdir -p "$path_target"/{include,src}

    # Update dependency order
    pack_dep "$path_depfile" "$executable_name" "${dependencies[@]}"

    # Create target's CMakeLists.txt
    cd "$path_target"
    template_cmake_executable "$project_name" "$executable_name" "${dependencies[@]}"

    # Create the executable
    template_executable "$project_name" "$executable_name" "${dependencies[@]}"

    cd "$cpath"

    echo "Executable '$executable_name' created"
}

build_project() {
    local project_name=$1
    local cpath="$(pwd)"
    local path_depfile="$cpath/$project_name/packages/pack.dep"
    
    if [ ! -d "$project_name" ]; then
        echo "[ERROR] Project directory '$project_name' not found" >&2
        exit 1
    fi

     # Get dependency order
    local error=$(resolve_dep "$path_depfile" 2>&1 1>/dev/null)
    if [ -n "$error" ]; then
        echo "$error" >&2
        exit 1
    fi
    local order_dep=($(resolve_dep "$path_depfile"))
    
    local path_prefix=""
    # Configure and build each package
    for pack in "${order_dep[@]}"; do
        echo "Building package: $pack"

        # Define paths for each package
        local path_pack="$cpath/$project_name/packages/$pack"
        local path_pack_build="$cpath/$project_name/build/$pack"
        local path_pack_install="$cpath/$project_name/install/$pack"

        # Add the new dependency path prefix/includes
        path_prefix=${path_prefix:+$path_prefix;}$path_pack_install/cmake

        # Configure package
        cmake -DCMAKE_PREFIX_PATH="$path_prefix" \
              -DCMAKE_BUILD_TYPE="${__WCX_BUILD_TYPE}" \
              -DCMAKE_INSTALL_PREFIX="$path_pack_install" \
              -DCMAKE_VERBOSE_MAKEFILE="$__WCX_VERBOSE_MAKEFILE" \
              -D__WCX_CXX_STANDARD="$__WCX_CXX_STANDARD" \
              -D__WCX_OPTIMIZATION="$__WCX_OPTIMIZATION" \
              -D__WCX_WARNING="$__WCX_WARNING" \
              -S "$path_pack" -B "$path_pack_build"

        # Build and install package
        cmake --build "$path_pack_build"
        cmake --install "$path_pack_build"
    done
}

run_project() {
    local project_name=$1
    local executable_name=$2
    local path_build="$project_name/build"
    local path_install="$project_name/install"
    
    if [ ! -d "$path_build" ]; then
        echo "[ERROR] Build directory not found. Please build the project first." >&2
        exit 1
    fi

    if [ -z "$executable_name" ]; then
        echo "[ERROR] Executable name required" >&2
        exit 1
    fi

    # Find and run executables - exclude all non-executable types
    local executables=($(/usr/bin/find "$path_build" -type f -executable -name "$executable_name"))
    if [ ${#executables[@]} -eq 0 ]; then
        echo "No executables found in build directory"
        exit 1
    fi
    
    local library_paths=$(/usr/bin/find "$path_install" -type d \( -name "lib" -o -name "bin" \) \
                        -exec find {} -type f \( -name "*.so" -o -name "*.dylib" -o -name "*.dll" \) \
                        -printf "%h\n" \; | sort -u | tr '\n' ':' | sed 's/:$//')

    # Run the first executable found
    echo "Running executable: ${executables[0]}"
    export LD_LIBRARY_PATH="$library_paths:$LD_LIBRARY_PATH"
    export DYLD_LIBRARY_PATH="$library_paths:$DYLD_LIBRARY_PATH"
    export PATH="$library_paths:$PATH"
    "${executables[0]}"

}

# Check project exists
check_project() {
    local project_name="$1.wcx"
    if [ -d "$project_name" ]; then
        echo "$project_name"
    else
        echo "[ERROR] Project directory '$project_name' not found" >&2
        exit 1
    fi
}

# Clean the output build directory 
clean_project() {
    local project_name="$1"
    rm -rf "$project_name/build"
    rm -rf "$project_name/install"
}

exec() {
    local project_name=""
    local executable_name=""
    local libraries=()
    local executables=()
    local dependencies=()
    local is_dep_mode=false
    case $1 in
        -h|--help)
            show_help
            ;;
        -v|--version)
            echo "WCX - Version: ${__WCX_VERSION}"
            ;;
        -n|--new)
            shift
            if [ -z "$1" ]; then
                echo "[ERROR] Project name required" >&2
                show_help
                exit 1
            fi
            project_name="${1}.wcx"
            shift

            while [ "$1" ]; do
                case $1 in
                    -lib|--library)
                        if [ -z "$2" ]; then
                            echo "[ERROR] Library name required" >&2
                            exit 1
                        fi
                        if [ "$is_dep_mode" = true ]; then
                            dependencies+=("$2")
                        else
                            libraries+=("$2")
                        fi
                        shift 2
                        ;;
                    -exec|--executable)
                        if [ -z "$2" ]; then
                            echo "[ERROR] Executable name required" >&2
                            exit 1
                        fi
                        if [ "$is_dep_mode" = true ]; then
                            echo "[ERROR] Executable cannot be a dependency" >&2
                            exit 1
                        fi
                        executables+=("$2")
                        shift 2
                        ;;
                    -dep|--depend)
                        if [ ${#libraries[@]} -eq 0 ] && [ ${#executables[@]} -eq 0 ]; then
                            echo "[ERROR] No targets specified for dependencies" >&2
                            exit 1
                        fi
                        is_dep_mode=true
                        shift
                        ;;
                    -cxx|--c++)
                        if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                            echo "[ERROR] Valid C++ standard version required (e.g., 11, 14, 17, 20)" >&2
                            exit 1
                        fi
                        __WCX_CXX_STANDARD="$2"
                        shift 2
                        ;;
                    -opt|--optimization)
                        if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                            echo "[ERROR] Valid optimization level required (e.g., 0, 1, 2, 3)" >&2
                            exit 1
                        fi
                        __WCX_OPTIMIZATION="$2"
                        shift 2
                        ;;
                    -w|--warning)
                        __WCX_WARNING="ON"
                        shift
                        ;;
                    -verb|--verbose)
                        __WCX_VERBOSE_MAKEFILE="ON"
                        shift
                        ;;
                    *)
                        echo "Unknown option: $1"
                        show_help
                        exit 1
                        ;;
                esac
            done
            create_project "$project_name"
            for library in "${libraries[@]}"; do
                create_library "$project_name" "$library" "$library" "${dependencies[@]}"
            done
            for executable in "${executables[@]}"; do
                create_executable "$project_name" "$executable" "${dependencies[@]}"
            done
            ;;
        -b|--build|-bd|--build-debug|-br|--build-release)
            if [ "$1" = "-bd" ] || [ "$1" = "--build-debug" ]; then
                __WCX_BUILD_TYPE="Debug"
            elif [ "$1" = "-br" ] || [ "$1" = "--build-release" ]; then
                __WCX_BUILD_TYPE="Release"
            else
                __WCX_BUILD_TYPE="Release"
            fi
            shift
            if [ -z "$1" ]; then
                echo "[ERROR] Project name required" >&2
                exit 1
            fi
            project_name=$(check_project "$1")
            shift
            while [ "$1" ]; do
                case $1 in
                    -w|--warning)
                        __WCX_WARNING="ON"
                        shift
                        ;;
                    -opt|--optimization)
                        if [ -z "$2" ]; then
                            echo "[ERROR] Optimization level required" >&2
                            exit 1
                        fi
                        __WCX_OPTIMIZATION="$2"
                        shift 2
                        ;;
                    -verb|--verbose)
                        __WCX_VERBOSE_MAKEFILE="ON"
                        shift
                        ;;
                    *)
                        echo "Unknown build option: $1"
                        show_help
                        exit 1
                        ;;
                esac
            done
            build_project "$project_name"
            ;;
        -cb|--clean-build)
            shift
            if [ -z "$1" ]; then
                echo "[ERROR] Project name required" >&2
                exit 1
            fi
            project_name=$(check_project "$1")
            clean_project "$project_name"
            build_project "$project_name"
            ;;
        -r|--run)
            shift
            if [ -z "$1" ]; then
                echo "[ERROR] Project name required" >&2
                exit 1
            fi
            project_name=$(check_project "$1")
            shift

            if [ -z "$1" ]; then
                echo "[ERROR] Executable name required" >&2
                exit 1
            fi
            executable_name="$1"
            run_project "$project_name" "$executable_name"
            ;;
        -c|--clean)
            shift
            if [ -z "$1" ]; then
                echo "[ERROR] Project name required" >&2
                exit 1
            fi
            project_name=$(check_project "$1")
            clean_project "$project_name"
            ;;
        -d|--delete)
            shift
            if [ -z "$1" ]; then
                echo "[ERROR] Project name required" >&2
                exit 1
            fi 
            project_name=$(check_project "$1")
            rm -rf "$project_name"
            ;;
        -w|--warning|-opt|--optimization|-cxx|--c++|-verb|--verbose)
            echo "[ERROR] Option $1 must be used with a build or creation command" >&2
            exit 1
            ;;
        *)
            # Check if the first argument is an existing project
            if [[ -d "${1}.wcx" ]]; then
                project_name=$(check_project "$1")
                shift
                
                local libraries=()
                local executables=()
                local dependencies=()
                local is_dep_mode=false
                while [ "$1" ]; do
                    case $1 in
                        -lib|--library)
                            if [ -z "$2" ]; then
                                echo "[ERROR] Library name required" >&2
                                exit 1
                            fi
                            if [ "$is_dep_mode" = true ]; then
                                dependencies+=("$2")
                            else
                                libraries+=("$2")
                            fi
                            shift 2
                            ;;
                        -exec|--executable)
                            if [ -z "$2" ]; then
                                echo "[ERROR] Executable name required" >&2
                                exit 1
                            fi
                            if [ "$is_dep_mode" = true ]; then
                                echo "[ERROR] Executable cannot be a dependency" >&2
                                exit 1
                            fi
                            executables+=("$2")
                            shift 2
                            ;;
                        -dep|--depend)
                            if [ ${#libraries[@]} -eq 0 ] && [ ${#executables[@]} -eq 0 ]; then
                                echo "[ERROR] No targets specified for dependencies" >&2
                                exit 1
                            fi
                            is_dep_mode=true
                            shift
                            ;;                   
                        -cxx|--c++)
                            if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                                echo "[ERROR] Valid C++ standard version required (e.g., 11, 14, 17, 20)" >&2
                                exit 1
                            fi
                            __WCX_CXX_STANDARD="$2"
                            shift 2
                            ;;
                        -opt|--optimization)
                            if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                                echo "[ERROR] Valid optimization level required (e.g., 0, 1, 2, 3)" >&2
                                exit 1
                            fi
                            __WCX_OPTIMIZATION="$2"
                            shift 2
                            ;;
                        -w|--warning)
                            __WCX_WARNING="ON"
                            shift
                            ;;
                        -verb|--verbose)
                            __WCX_VERBOSE_MAKEFILE="ON"
                            shift
                            ;;
                        *)
                            echo "Unknown option: $1"
                            show_help
                            exit 1
                            ;;
                    esac
                done
                for library in "${libraries[@]}"; do
                    create_library "$project_name" "$library" "$library" "${dependencies[@]}"
                done                    
                for executable in "${executables[@]}"; do
                    create_executable "$project_name" "$executable" "${dependencies[@]}"
                done
            else
                echo "Unknown option: $1"
                show_help
                exit 1
            fi
            ;;
    esac
}

# Start the script
exec "$@"