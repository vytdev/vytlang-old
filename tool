#!/bin/sh

#
# Copyright (c) 2023 VYT. All rights reserved.
#
# This project is distributed and available under the terms of MIT License.
# See LICENSE for more information.
#

################################################################################
#
#   Developer Tool
#
#   Use this script to do build and package the binary
#
################################################################################

# variables
compiler_args="-std=c++11"
installer_boundary="# --- START OF THE BINARY --- #"

# cd this subshell on the workspace folder
cd $( dirname $0 )

# paths
license_file=./LICENSE                         # license file
source_folder=./src                            # source folder
build_folder=./build                           # build folder
# cache
source_record=$build_folder/.watcher           # for checking file changes
objects_folder=$build_folder/obj               # where .o files is saved
# distribution files
executable_file=$build_folder/vyt              # the built binary
installer_file=$build_folder/installer         # distribution installer
integrity_file=$build_folder/checksums.txt     # integrity file

# get version name from 'main.cc'
version_name=$( \
    cat $source_folder/main.cc | \
    sed -n "s/.*#define VYT_VERSION \"\(.*\)\".*/\1/p" \
)

# fail function
fail() {
    echo $*
    exit 1
}

# create build files
if [ ! -d $build_folder ] ; then
    mkdir $build_folder
fi

# arguments
has_flag=false
arg_help=false
arg_version=false
arg_clean=false
arg_build=false
arg_pack=false

# process arguments
for arg in "$@" ; do
    case $arg in
        -- )
            # stop parsing of flags
            shift
            break
        ;;
        --* )
            # long flags
            case $( echo "$arg" | cut -c 3- ) in
                help    ) arg_help=true             ;;
                version ) arg_version=true          ;;
                clean   ) arg_clean=true            ;;
                build   ) arg_build=true            ;;
                pack    ) arg_pack=true             ;;
                *       ) fail "Unknown flag: $arg" ;;
            esac
        ;;
        -* )
            # process short flags
            length=$( echo "$arg" | wc -c )
            length=$(( length - 1 ))
            # iterate through chars
            i=2
            while [ "$i" -le "$length" ] ; do
                char=$( echo "$arg" | cut -c "$i" )
                case $char in
                    h ) arg_help=true               ;;
                    v ) arg_version=true            ;;
                    c ) arg_clean=true              ;;
                    b ) arg_build=true              ;;
                    p ) arg_pack=true               ;;
                    * ) fail "Unknown flag: -$char" ;;
                esac
                i=$(( i + 1 ))
            done
        ;;
        * )
            # not a flag
            break
        ;;
    esac
    # remove this arg
    shift
    # flag found
    has_flag=true
done

# no arguments specified, do build
if ! "$has_flag" ; then
    arg_build=true
fi

# print help and exit
if "$arg_help" ; then
    echo "Workspace Developer Tool"
    echo
    echo "Usage:"
    echo "    $0 [options] [--] [compiler-arguments]"
    echo
    echo "Options:"
    echo "    --                        End of options"
    echo "    -h, --help                Show this help and exit"
    echo "    -v, --version             Show version name from 'main.cc'"
    echo "    -c, --clean               Clean up to refresh build"
    echo "    -b, --build               Build the source files"
    echo "    -p, --pack                Create distribution files"
    echo "Arguments:"
    echo "    compiler-arguments        Arguments to pass on compiler"
    
    exit 0
fi

# show version
if "$arg_version" ; then
    echo "v$version_name"
    exit 0
fi

# perform clean up
if "$arg_clean" ; then
    printf "Cleaning..."
    rm -rf $build_folder/*
    echo " done"
fi

# build the binary
if "$arg_build" ; then
    echo "Building..."
    
    # search for C++ compiler
    if   command -v clang++ >/dev/null 2>&1 ; then compiler_command=clang++ ;
    elif command -v cpp     >/dev/null 2>&1 ; then compiler_command=cpp     ;
    elif command -v g++     >/dev/null 2>&1 ; then compiler_command=g++     ;
    else fail "Cannot find C++ compiler" ; fi
    
    # make sure build folder exists
    mkdir -p "$objects_folder"
    
    # we use checksum to check for file changes (to fasten every build)
    last_checksums=$( cat "$source_record" 2>/dev/null || echo )
    echo "# don't edit this file" > $source_record
    
    # compile into objects
    for file in $( find "$source_folder" -name "*.cc" -type f ) ; do
        # get current checksum
        current_checksum=$( md5sum "$file" )
        stored_checksum=$( echo "$last_checksums" | grep -m 1 "$file" )
        
        # record current checksum
        echo "$current_checksum" >> "$source_record"
        
        # get .o path
        objpath=${file%.cc}
        objpath=${objpath#$source_folder}
        objpath=$objects_folder$objpath.o
        
        # make sure parent directory of object exists
        mkdir -p "$( dirname $objpath )"
        
        # if object exists and checksum is same, continue
        if [ -e "$objpath" ] && [ "$current_checksum" = "$stored_checksum" ] ; then
            continue
        fi
        
        echo "$file"
        
        # do compile
        eval "$compiler_command $compiler_args -c $file -o $objpath $@"
        
        if [ ! $? -eq 0 ] ; then
            # save back last checksums
            echo "$last_checksums" > "$source_record"
            fail "Aborting..."
        fi
    done
    
    echo "Linking objects..."
    
    # link executable
    eval "$compiler_command $(                       \
        find "$objects_folder" -name "*.o" -type f | \
        tr '\n' ' '                                  \
        ) -o $executable_file"
    
    if [ $? -eq 0 ] ; then echo "Compiled successfully at: $executable_file" ;
    else fail "Link failed" ; fi
fi

# package installer and create checksums
if "$arg_pack" ; then
    # check if the executable exists, if not build first
    if [ ! -f $executable_file ] ; then
        sh ./tool -b
    fi
    
    printf "Creating installer..."
    cat > $installer_file << EOF
#!/bin/sh

#
# Copyright (c) 2023 VYT. All rights reserved.
#
# This project is distributed and available under the terms of MIT License.
# See LICENSE on source repository for more information.
#

################################################################################
#
#   VYT Lang v$version_name Installer
#
#   This will automate installation of the binary on your path. Just run the
#   following command:
#
#       ./installer
#
#   Answer all the prompts and done.
#
#   NOTE:
#     Editing this file might cause the included binary to corrupt. This is
#     auto generated by the build system specifically made for the project.
#
################################################################################

# the version name
version_name=$version_name
# default installation path
install_dir=/usr/local/bin

# default installation dir not found, use current PATH
if [ ! -d \$install_dir ] ; then
    install_dir=\${PATH%:*}
fi

# line where the binary starts
linestart=\$( sed -n "/^$installer_boundary\\\$/=" \$0 )

echo "VYT Lang Installer"
echo "Package version: \$version_name"
echo "Repository: https://github.com/vytdev/vytlang"
echo "Default settings are in square brackets '[]'"
echo "Press enter to choose default value"

# introduction
echo
echo "VYT Lang is a custom programming language made by VYT"
echo

echo "This project is distributed under the MIT License."
read -p "Do you want to review the license? [y/n]: " a

# show the license
case \$a in
    y* | Y* ) less << EOT
$( cat $license_file )
EOT
    ;;
    * ) # show a link where user can have the license
        echo "Go to the following link to see the license at any time."
        echo "    https://github.com/vytdev/vytlang/blob/master/LICENSE"
    ;;
esac

while true ; do
    read -p "Do you accept the license? [y/n]: " a
    # make sure user accept the license
    case \$a in
        y* | Y* ) break                        ;;
        n* | N* ) echo "Aborting..." ; exit    ;;
        * ) echo "Please answer 'yes' or 'no'" ;;
    esac
done

# installation folder
echo "This will install the package to the following path:"
echo "    \$install_dir"
read -p "Do you want to set custom installation folder? [n]: " a

# custom install folder
case \$a in y* | Y* )
    while true ; do
        read -p "Enter install directory: " input
        # check if the folder exists
        if [ ! -d "\$input" ] ; then
            echo "Path doesn't exists, or not a folder"
            read -p "Do you want to continue to default? [y]: " a
            case \$a in n* | N* ) continue ;; esac
            break
        fi
        # verify user
        echo "It will now install the package on the following path:"
        echo "    \$input"
        read -p "Is this ok? [y]: " a
        case \$a in n* | N* ) continue ;; esac
        # set the install folder
        install_dir=\$input
        break
    done
;; esac

install_file=\$install_dir/vyt

# conflict detected
if [ -e \$install_file ] ; then
    echo "It seems that the package is already installed"
    read -p "Do you want to overwrite it? [y]: " a
    case \$a in n* | N* ) echo "Aborting..." ; exit ;; esac
fi

# confirm user before continue installation
echo "Final full path install location is at:"
echo "    \$install_file"
read -p "Do you want to proceed? [y]: " a
case \$a in n* | N* ) echo "Aborting..." ; exit ;; esac

echo "Installing..."
tail -n +"\$(( linestart + 1 ))" \$0 > \$install_file

# extract failed
if [ ! \$? -eq 0 ] ; then
    echo "Installation failed"
    echo "This might because of file permissions preventing access to install directory"
    exit 1
fi

# change permissions
chmod u+x \$install_file

# change permission failed
if [ ! \$? -eq 0 ] ; then
    echo "Failed to grant execute permission"
    exit 1
fi

echo "Install done"

printf "Performing some test..."
if ! \$install_file -v >/dev/null 2>&1 ; then
    echo " failed"
    echo "There was a problem starting the program"
    exit 1
fi
echo " succed"

echo "Install finished successfully!"
echo "Run 'vyt -h' (or the full path) for help in the command."

# stop execution here
exit 0

$installer_boundary
EOF
    echo " done"
    
    # insert the binary
    printf "Inserting binary..."
    cat $executable_file >> $installer_file
    echo " done"
    
    # create checksums
    printf "Creating checksums..."
    cat > $integrity_file << EOF
# Checksum for release v$version_name
# This checksums were generated using sha256 hash function
#
# Run the following command to verify integrity:
#       shasum -a 256 -c checksums.txt
#       # or...
#       sha256sum -c checksums.txt
#
# See the project repository for more details:
#       https://github.com/vytdev/vytlang
#
$( cd $build_folder ; sha256sum vyt       ; cd .. )
$( cd $build_folder ; sha256sum installer ; cd .. )
EOF
    echo " done"
    
    echo "Pack done, at: $build_folder"
fi
