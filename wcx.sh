#!/bin/bash

# _________________________________________________________________________
# Script to organize the workflow of creating and building C/C++ with CMake
# _________________________________________________________________________
# Author: 	KDZ7
# _________________________________________________________________________

show_help() {
    echo "Usage: $0 [option...] "
    echo "__________________________________________________________________________"
    echo "__________________________________________________________________________"
    echo "                  WCX - Workflow C/C++ with CMake                         "
    echo "           Script to manage and build C/C++ projects using CMake          "
    echo "                            Author: KDZ7                                  "
    echo "                             Version: ${__WCX_VERSION}                    "
    echo "                         License: Apache 2.0                              "
    echo "__________________________________________________________________________"
    echo "__________________________________________________________________________"
    echo "Requirements:                                                             "
    echo "  - CMake                                                                 "
    echo "  - Make                                                                  "
    echo "  - C/C++ Compiler (GCC, Clang, MINGW, or MSVC)                           "
    echo "  - Bash Command Line Tools (WSL, MSYS2, Cygwin, Git Bash, etc.)          "
    echo "__________________________________________________________________________"
    echo "!!!   Not professional, Just create quick libraries and executables    !!!"
    echo "__________________________________________________________________________"
    echo "Options:                                                                  "
    echo "  -h, --help            Display this help and exit                        "
    echo "  -n, --new             Create a new project                              "
    echo "  -lib, --library       Create a new library                              "
    echo "  -exec, --executable   Create a new executable                           "
    echo "  -b, --build           Build the project                                 "
    echo "  -bd, --build-debug    Build the project in debug mode                   "
    echo "  -br, --build-release  Build the project in release mode                 "
    echo "  -w,  --warning        Enable the warnings while building                "
    echo "  -opt, --optimization  Specify the optimization level (default: 2)       "
    echo "  -cb, --clean-build    Rebuild the project (clean and build)             "
    echo "  -r, --run             Run the executable                                "
    echo "  -c, --clean           Clean the build                                   "
    echo "  -d, --delete          Delete the project                                "
    echo "  -v, --version         Display the version of the script                 "
    echo "  -cxx, --c++           Specify the C++ standard version (default: 17)    "
    echo "  -verb, --verbose      Enable verbose while building                     "
    echo "__________________________________________________________________________"
    echo "       Examples to quick start a project with libraries/executables       "
    echo "__________________________________________________________________________"
    echo "                         Create a new project                             "
    echo "__________________________________________________________________________"
    echo "      - wcx.sh -n [project]                                               "
    echo "      - wcx.sh -n [project] -lib [library_1] -exec [executable_1]         "
    echo "      - wcx.sh -n [project] -lib [library_1] -lib [library_2] -cxx 20     "
    echo "      - wcx.sh -n [project] -exec [executable_1] -exec [executable_2]     "
    echo "__________________________________________________________________________"
    echo "                       Build/Run/Clean the project                        "
    echo "__________________________________________________________________________"
    echo "      - wcx.sh -b [project] -opt 3                                        "
    echo "      - wcx.sh -b [project] -opt 3 -w                                     "
    echo "      - wcx.sh -b [project] -opt 3 -w -verb                               "   
    echo "      - wcx.sh -bd [project]                                              "
    echo "      - wcx.sh -br [project]                                              "
    echo "      - wcx.sh -cb [project]                                              "
    echo "      - wcx.sh -r [project] [executable]                                  "
    echo "      - wcx.sh -c [project]                                               "
    echo "      - wcx.sh -d [project]                                               "
    echo "__________________________________________________________________________"
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

__template_section_dependencies_configuration='
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                 SECTION: Dependencies Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________
# Add the dependencies packages if needed
# find_package(package_name REQUIRED)

# Link the external libraries if needed
# target_link_libraries(
#   ${__TARGET_NAME}
#   PUBLIC
#   external_library
#   namespace::external_library
# )
'

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
set(__WCX_EXPORT_DESTINATION \${__TARGET_NAME}/bin/cmake/)                                                

# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                     SECTION: Library Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________

# Create the shared library \${__TARGET_NAME} 
add_library(
    \${__TARGET_NAME}
    SHARED
    src/\${__TARGET_NAME}.cpp
) 

# Include the header files in the library \${__TARGET_NAME}
target_include_directories(
    \${__TARGET_NAME}                                                      
    PUBLIC                                                                   # Make these include directories available or not to other targets (PUBLIC, PRIVATE, INTERFACE)
    \$<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include>                 # Build-time: Headers are found in 'include' dir relative to CMakeLists.txt
    \$<INSTALL_INTERFACE:include>                                            # Install-time: Headers will be installed to 'include' dir in install prefix
)
${__template_section_compiler_configuration}
$(__template_section_preprocessor_configuration ${library_name})
${__template_section_dependencies_configuration}
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                  SECTION: Installation Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________
# Install the library
install(
    TARGETS \${__TARGET_NAME}
    EXPORT \${__TARGET_NAME}-targets
    LIBRARY DESTINATION \${__TARGET_NAME}/lib
    ARCHIVE DESTINATION \${__TARGET_NAME}/lib
    RUNTIME DESTINATION \${__TARGET_NAME}/bin
    INCLUDES DESTINATION \${__TARGET_NAME}/include
)

# Install the header files
install(
    DIRECTORY include/
    DESTINATION \${__TARGET_NAME}/include
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
set(__WCX_EXPORT_DESTINATION \${__TARGET_NAME}/bin/cmake/)

# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                     SECTION: Executable Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________

# Create the executable "\${__TARGET_NAME}
add_executable(
    \${__TARGET_NAME}
    src/\${__TARGET_NAME}.cpp
)

# Include the header files in the library \${__TARGET_NAME}
target_include_directories(
    \${__TARGET_NAME}                                                      
    PRIVATE                                                                  # Make these include directories available or not to other targets (PUBLIC, PRIVATE, INTERFACE)
    \$<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include>                 # Build-time: Headers are found in 'include' dir relative to CMakeLists.txt
)
${__template_section_compiler_configuration}
$(__template_section_preprocessor_configuration ${executable_name})
${__template_section_dependencies_configuration}
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                                  SECTION: Installation Configuration
# ___________________________________________________________________________________________________________________________________________________________________________________________
# Install the executable
install(
    TARGETS \${__TARGET_NAME}
    EXPORT \${__TARGET_NAME}-targets
    LIBRARY DESTINATION \${__TARGET_NAME}/lib
    ARCHIVE DESTINATION \${__TARGET_NAME}/lib
    RUNTIME DESTINATION \${__TARGET_NAME}/bin
)
${__template_version_configuration}
${__template_export_configuration}
${__template_build_information}
EOF
}

 template_cmake_project() {
    local project_name=$1
    local min_version=$(estimate_cmake_minimum_required)

    cat > CMakeLists.txt << EOF
${__template_header}
cmake_minimum_required(VERSION ${min_version})

set(__PROJECT_NAME ${project_name})

project(\${__PROJECT_NAME})

# Set global configuration variables
set(__WCX_CXX_STANDARD ${__WCX_CXX_STANDARD})
set(__WCX_OPTIMIZATION ${__WCX_OPTIMIZATION})
set(__WCX_WARNING ${__WCX_WARNING})
${__template_section_dependencies_configuration}
# ___________________________________________________________________________________________________________________________________________________________________________________________
#                                     SECTION: Add subdirectories for packages (libraries/executables)
# ___________________________________________________________________________________________________________________________________________________________________________________________

file(GLOB_RECURSE packages_cmake_files RELATIVE \${CMAKE_CURRENT_SOURCE_DIR} "packages/*/CMakeLists.txt")
foreach(cmake_file \${packages_cmake_files})
    get_filename_component(package_dir \${cmake_file} DIRECTORY)
    add_subdirectory(\${package_dir})
endforeach()
${__template_build_information}
EOF
}

template_class_library() {
    local project_name=$1
    local library_name=$2
    local class_name=$3

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

namespace ${library_name} {
    class ${library_name^^}_API ${class_name} {
    public:
        explicit ${class_name}(int count = 0);
        virtual ~${class_name}();

        void hello();

    private:
        int _count;
    };
} // namespace ${library_name}

#endif // __${class_name^^}_HPP__
EOF

    cat > "src/${class_name}.cpp" << EOF
#include <iostream>
#include "${class_name}.hpp"

namespace ${library_name} {
    ${class_name}::${class_name}(int count) : _count(count) {}

    ${class_name}::~${class_name}() {}

    void ${class_name}::hello() {
        std::cout << std::endl << _count << ". Hello from ${class_name}!" << std::endl;
        _count++;
    }
} // namespace ${library_name}
EOF
}

template_executable() {
    local project_name=$1
    local executable_name=$2

    cat > "src/${executable_name}.cpp" << EOF
#include <iostream>
#include <chrono>
#include <thread>

int main() {
    while(true) {
        std::cout << "Hello from ${executable_name}!" << std::endl;
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
    local current_dir="$(pwd)"
    local path_project="$current_dir/$project_name"

    # Create the source packages directory tree
    mkdir -p "$path_project"/packages

    # Create project's CMakeLists.txt
    cd "$path_project"
    template_cmake_project "$project_name"

    cd "$current_dir"

    echo "Project '$project_name' created"
}


create_library() {
    local project_name=$1
    local library_name=$2
    local class_name=$3
    local current_dir="$(pwd)"
    local path_target="$current_dir/$project_name/packages/$library_name"

    # Create the target directory tree
    mkdir -p "$path_target"/{include,src}
    
    # Create library's CMakeLists.txt
    cd "$path_target"
    template_cmake_library "$project_name" "$library_name"

    # Create a class for the library
    template_class_library "$project_name" "$library_name" "$class_name"

    cd "$current_dir"

    echo "Library '$library_name' created"
}

create_executable() {
    local project_name=$1
    local executable_name=$2
    local current_dir="$(pwd)"
    local path_target="$current_dir/$project_name/packages/$executable_name"

    # Create the target directory tree
    mkdir -p "$path_target"/{include,src}
    
    # Create target's CMakeLists.txt
    cd "$path_target"
    template_cmake_executable "$project_name" "$executable_name"

    # Create the executable
    template_executable "$project_name" "$executable_name"

    cd "$current_dir"

    echo "Executable '$executable_name' created"
}

build_project() {
    local project_name=$1
    local current_dir="$(pwd)"
    local path_build="$current_dir/$project_name/build"
    local path_install="$current_dir/$project_name/install"
    
    if [ ! -d "$project_name" ]; then
        echo "Error: Project directory '$project_name' not found"
        exit 1
    fi
    
    # Create build directory
    mkdir -p "$path_build"
    
    # Clean old build artifacts if they exist
    if [ -d "$path_build/packages" ]; then
        /usr/bin/find "$path_build" -type d -name "*.dir" -exec rm -rf {} + 2>/dev/null
    fi

    # CMake configuration
    cd "$path_build"
    cmake -DCMAKE_BUILD_TYPE="${__WCX_BUILD_TYPE}" \
          -DCMAKE_INSTALL_PREFIX="$path_install" \
          -D__WCX_CXX_STANDARD="$__WCX_CXX_STANDARD" \
          -D__WCX_OPTIMIZATION="$__WCX_OPTIMIZATION" \
          -D__WCX_WARNING="$__WCX_WARNING" \
          -DCMAKE_VERBOSE_MAKEFILE="$__WCX_VERBOSE_MAKEFILE" \
          ..
    
    # Build
    cmake --build . -j$(nproc)
    cmake --install .
    
    cd "$current_dir"
}

run_project() {
    local project_name=$1
    local executable_name=$2
    local build_dir="$project_name/build"
    
    if [ ! -d "$build_dir" ]; then
        echo "Error: Build directory not found. Please build the project first."
        exit 1
    fi

    if [ -z "$executable_name" ]; then
        echo "Error: Executable name required"
        exit 1
    fi

    # Find and run executables - exclude all non-executable types
    local executables=($(/usr/bin/find "$build_dir/packages" -type f -executable -name "$executable_name"))
    if [ ${#executables[@]} -eq 0 ]; then
        echo "No executables found in build directory"
        exit 1
    fi

    # Run the first executable found
    echo "Running executable: ${executables[0]}"
    "${executables[0]}"
}

# Check project exists
check_project() {
    local project_name="$1.wcx"
    if [ -d "$project_name" ]; then
        echo "$project_name"
    else
        echo "Error: Project directory '$project_name' not found" >&2
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
                echo "Error: Project name required"
                show_help
                exit 1
            fi
            project_name="${1}.wcx"
            shift

            while [ "$1" ]; do
                case $1 in
                    -lib|--library)
                        if [ -z "$2" ]; then
                            echo "Error: Library name required"
                            exit 1
                        fi
                        libraries+=("$2")
                        shift 2
                        ;;
                    -exec|--executable)
                        if [ -z "$2" ]; then
                            echo "Error: Executable name required"
                            exit 1
                        fi
                        executables+=("$2")
                        shift 2
                        ;;
                    -cxx|--c++)
                        if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                            echo "Error: Valid C++ standard version required (e.g., 11, 14, 17, 20)"
                            exit 1
                        fi
                        __WCX_CXX_STANDARD="$2"
                        shift 2
                        ;;
                    -opt|--optimization)
                        if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                            echo "Error: Valid optimization level required (e.g., 0, 1, 2, 3)"
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
                create_library "$project_name" "$library" "$library"
            done
            for executable in "${executables[@]}"; do
                create_executable "$project_name" "$executable"
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
                echo "Error: Project name required"
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
                            echo "Error: Optimization level required"
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
                echo "Error: Project name required"
                exit 1
            fi
            project_name=$(check_project "$1")
            clean_project "$project_name"
            build_project "$project_name"
            ;;
        -r|--run)
            shift
            if [ -z "$1" ]; then
                echo "Error: Project name required"
                exit 1
            fi
            project_name=$(check_project "$1")
            shift

            if [ -z "$1" ]; then
                echo "Error: Executable name required"
                exit 1
            fi
            executable_name="$1"
            run_project "$project_name" "$executable_name"
            ;;
        -c|--clean)
            shift
            if [ -z "$1" ]; then
                echo "Error: Project name required"
                exit 1
            fi
            project_name=$(check_project "$1")
            clean_project "$project_name"
            ;;
        -d|--delete)
            shift
            if [ -z "$1" ]; then
                echo "Error: Project name required"
                exit 1
            fi  
            project_name=$(check_project "$1")
            rm -rf "$project_name"
            ;;
        -w|--warning|-opt|--optimization|-cxx|--c++|-verb|--verbose)
            echo "Error: Option $1 must be used with a build or creation command"
            exit 1
            ;;
        *)
            # Check if the first argument is an existing project
            if [[ -d "${1}.wcx" ]]; then
                project_name=$(check_project "$1")
                shift
                
                local libraries=()
                local executables=()
                while [ "$1" ]; do
                    case $1 in
                        -lib|--library)
                            if [ -z "$2" ]; then
                                echo "Error: Library name required"
                                exit 1
                            fi
                            libraries+=("$2")
                            shift 2
                            ;;
                        -exec|--executable)
                            if [ -z "$2" ]; then
                                echo "Error: Executable name required"
                                exit 1
                            fi
                            executables+=("$2")
                            shift 2
                            ;;                        
                        -cxx|--c++)
                            if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                                echo "Error: Valid C++ standard version required (e.g., 11, 14, 17, 20)"
                                exit 1
                            fi
                            __WCX_CXX_STANDARD="$2"
                            shift 2
                            ;;
                        -opt|--optimization)
                            if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                                echo "Error: Valid optimization level required (e.g., 0, 1, 2, 3)"
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
                    create_library "$project_name" "$library" "$library"
                done                    
                for executable in "${executables[@]}"; do
                    create_executable "$project_name" "$executable"
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