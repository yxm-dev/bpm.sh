#! /bin/bash

function bpm() {
    source ${BASH_SOURCE%/*}/src/global-packages

    function BPM_create() {
        if [[ "$1" == "package" ]]; then
            core="$2"
        elif [[ "$1" == "module" ]]; then
            core="modules/$2"
        else
            echo "error: option \"$2\" not defined"
        fi
        mkdir $PWD/$core
        mkdir $PWD/$core/utils
        mkdir $PWD/$core/core
        mkdir $PWD/$core/modules
        mkdir $PWD/$core/data
        mkdir $PWD/$core/.src
        main_dir=${BASH_SOURCE%/*}
        cp $main_dir/files/$2/main.sh $PWD/$core/main.sh
        cp $main_dir/files/$2/includes.sh $PWD/$core/.src/includes.sh
        cp $main_dir/files/$2/config.yml $PWD/$core/config.yml
        cp $main_dir/files/env $PWD/$core/.env
        uppercase=${2^^}
        sed -i "s/NAME/$uppercase/g" $PWD/$core/.env
        echo "The $1 \"$2\" has been created."
    } 

    function BPM_create_module(){
        if [[ -f "$PWD/config.yml" ]]; then
            if [[ -f "$PWD/main.sh" ]]; then
                if [[ -d "$PWD/modules" ]]; then
                    BPM_create module $1
                    echo "The module \"$1\" has been created."
                else
                    mkdir $PWD/moodules
                    BPM_create module $1
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
        load=$(yq '.info.load' $PWD/config.yml)
        version=$(yq '.info.version' $PWD/config.yml)
        echo "load: $load" >> ${BASH_SOURCE%/*}/src/packages.yml
        echo "version: $version" >> ${BASH_SOURCE%/*}/src/packages.yml
        echo "path: $PWD/main.sh" >> ${BASH_SOURCE%/*}/src/packages.yml
        echo "---" >> ${BASH_SOURCE%/*}/src/packages.yml
    }
    
    function BPM_install(){
        if [[ -z "$1" ]]; then
            if [[ -f "$PWD/config.yml" ]]; then
                if [[ -f "$PWD/main.sh" ]]; then
                    BPM_install_core
                    name=$(yq '.metadata.name' $PWD/config.yml)
                    echo "The package \"$name\" has been installed"
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
            name=$(yq '.metadata.name' $PWD/config.yml)
            echo "The package \"$name\" has been installed globally."
        else
            echo "error: Option not defined for bpm()."
        fi                
    }

    function BPM_load(){
        array_of_sizes=($(yq eval 'length' ${BASH_SOURCE%/*}/src/packages.yml))
        number_of_blocks=${#array_of_sizes[@]}
        for (( i=0; i<$number_of_blocks; i++ )); do
            load=$(yq eval "select(documentIndex == $i).load" ${BASH_SOURCE%/*}/src/packages.yml)
            if [[ "$load" == "$1" ]]; then
                path=$(yq eval "select(documentIndex == $i).path" ${BASH_SOURCE%/*}/src/packages.yml)
                source $path
                echo "The bpm package \"$1\" has been sourced."
                has_load="yes"
                break
            else
                has_load="no"
                continue
            fi
        done
        if [[ "$has_load" == "no" ]]; then
            echo "error: there is no installed bpm package corresponding to \"$1\"."
        fi
    }
    
    if [[ -z "$1" ]] || 
       [[ "$1" == "help" ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        echo "usage:"
        echo "> bpm new package/module name"
        echo "> bpm install [--global]"
        echo "> bpm load name"
    elif [[ "$1" == "new" ]] || [[ "$1" == "-n" ]] || [[ "$1" == "--new" ]]; then
        if [[ -z "$2" ]]; then
            echo "interactive"
        elif [[ "$2" == "package" ]] || [[ "$2" == "-p" ]] || [[ "$2" == "--package" ]]; then
            if [[ -n "$3" ]]; then
                BPM_create package "$3"
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
    elif [[ "$1" == "load" ]] || [[ "$1" == "-l" ]] || [[ "$1" == "--load" ]]; then
        if [[ -n "$2" ]]; then
            BPM_load "$2"
        else
            echo "interactive..."
        fi
    else
        echo "error: option not defined for bpm()."
    fi
}
