#! /bin/bash

function bpm() {

    function BPM_create_package() {
        mkdir $PWD/$1
        mkdir $PWD/$1/utils
        mkdir $PWD/$1/core
        mkdir $PWD/$1/modules
        mkdir $PWD/$1/.src
        this_file_path=${BASH_SOURCE%/*}
        main_dir=${this_file_path%/*}
        cp $main_dir/files/main_package.sh $PWD/$1/main.sh
        cp $main_dir/files/includes_package.sh $PWD/$1/.src/includes.sh
        cp $main_dir/files/config.yml $PWD/$1/config.yml
    }

    function BPM_create_module_core() {
        mkdir $PWD/modules/$1
        mkdir $PWD/modules/$1/utils
        mkdir $PWD/modules/$1/core
        mkdir $PWD/modules/$1/.src
        this_file_path=${BASH_SOURCE%/*}
        main_dir=${this_file_path%/*}
        cp $main_dir/files/main_module.sh $PWD/modules/$1/main.sh
        cp $main_dir/files/includes_module.sh $PWD/modules/$1/.src/includes.sh
    }

    function BPM_create_module(){
        if [[ -f "$PWD/.config.yml" ]]; then
            if [[ -f "$PWD/.main.sh" ]]; then
                if [[ -d "$PWD/modules" ]]; then
                    BPM_create_module_core $1
                else
                    mkdir $PWD/moodules
                    BPM_create_module_core
                fi
            else
                echo "error: file \"main.sh\" not found."
                echo "> Are you in the root directory of a bpm package?"
            fi
            echo "error: file \".config.yml\" not found."
            echo "> Are you in the root directory of a bpm package?"
        fi
    }

    if [[ "$1" == "new" ]] || [[ "$1" == "-n" ]] || [[ "$1" == "--new" ]]; then
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
    fi
}
