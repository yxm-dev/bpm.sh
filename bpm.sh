#! /bin/bash

function bpm() {
    source ${BASH_SOURCE%/*}/src/global-packages

    function BPM_create_package() {
        mkdir $PWD/$1
        mkdir $PWD/$1/utils
        mkdir $PWD/$1/core
        mkdir $PWD/$1/modules
        mkdir $PWD/$1/.src
        main_dir=${BASH_SOURCE%/*}
        cp $main_dir/files/main_package.sh $PWD/$1/main.sh
        cp $main_dir/files/includes_package.sh $PWD/$1/.src/includes.sh
        cp $main_dir/files/config_package.yml $PWD/$1/config.yml
        echo "The package \"$1\" has been created."
    }

    function BPM_create_module_core() {
        mkdir $PWD/modules/$1
        mkdir $PWD/modules/$1/utils
        mkdir $PWD/modules/$1/core
        mkdir $PWD/modules/$1/.src
        main_dir=${BASH_SOURCE%/*}
        cp $main_dir/files/main_module.sh $PWD/modules/$1/main.sh
        cp $main_dir/files/includes_module.sh $PWD/modules/$1/.src/includes.sh
        cp $main_dir/files/config_module.yml $PWD/modules/$1/.src/config.yml
    }   

    function BPM_create_module(){
        if [[ -f "$PWD/config.yml" ]]; then
            if [[ -f "$PWD/main.sh" ]]; then
                if [[ -d "$PWD/modules" ]]; then
                    BPM_create_module_core $1
                    echo "The module \"$1\" has been created."
                else
                    mkdir $PWD/moodules
                    BPM_create_module_core $1
                    echo "The module \"$1\" has been created."
                fi
            else
                echo "error: file \"main.sh\" not found."
                echo "> Are you in the root directory of a bpm package?"
            fi
        else
            echo "error: file \".config.yml\" not found."
            echo "> Are you in the root directory of a bpm package?"
        fi
    }

    function BPM_install_core(){
        load=$(yq '.info.load' $PWD/config.yml | sed 's/\"//g')
        version=$(yq '.info.version' $PWD/config.yml | sed 's/\"//g')
        echo "load: $load" >> ${BASH_SOURCE%/*}/src/packages.yml
        echo "  version: $version" >> ${BASH_SOURCE%/*}/src/packages.yml
        echo "  path: $PWD/main.sh" >> ${BASH_SOURCE%/*}/src/packages.yml
    }
    
    function BPM_install(){
        if [[ -z "$1" ]]; then
            if [[ -f "$PWD/config.yml" ]]; then
                if [[ -f "$PWD/main.sh" ]]; then
                    BPM_install_core
                else
                    echo "error: file \"main.sh\" not found."
                    echo "> Are you in the root directory of a bpm package?"
                fi
            else
                echo "error: file \".config.yml\" not found."
                echo "> Are you in the root directory of a bpm package?"
            fi
        elif [[ "$1" == "global" ]]; then
            BPM_install_core
            echo "source $PWD/main.sh" >> ${BASH_SOURCE%/*}/src/global-packages
        else
            echo "error: Option not defined for bpm()."
        fi                
    }

    function BPM_load(){
        statement
    }
    
    

    if [[ -z "$1" ]]; then
        echo "usage: bpm new package/module name"
    elif [[ "$1" == "new" ]] || [[ "$1" == "-n" ]] || [[ "$1" == "--new" ]]; then
        if [[ -z "$2" ]]; then
            echo "interactive"
        elif [[ "$2" == "package" ]] || [[ "$2" == "-p" ]] || [[ "$2" == "--package" ]]; then
            if [[ -n "$3" ]]; then
                BPM_create_package "$3"
            else 
                echo "interactive ..."
            fi
        elif [[ "$2" == "module" ]] || [[ "$2" == "-m" ]] || [[ "$2" == "--module" ]]; then
            if [[ -n "$3" ]]; then
                BPM_create_module "$3"
            else 
                echo "interactive ..."
            fi
        else
            echo "error: option not defined for bpm()."
        fi
    elif [[ "$1" == "install" ]] || [[ "$1" == "-i" ]] || [[ "$1" == "--install" ]]; then
        if [[ -z "$2" ]]; then
            BPM_install
        elif [[ "$2" == "--global" ]]; then
            BPM_install global
        else
            echo "error: option not defined for bpm()."
        fi
    else
        echo "error: option not defined for bpm()."
    fi
}
