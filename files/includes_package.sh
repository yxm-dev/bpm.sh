#! /bin/bash

# including core scripts
this_file_path=${BASH_SOURCE%/*}
main_dir=${this_file_path%/*} 
cores=($(find $main_dir/core -type f -name "*.sh" ))
for core in ${cores[@]}; do
    source $core
done

# including modules
config_file=$main_dir/config.yml
modules_dir=$main_dir/modules

check_modules=$(yq '.modules' $config_file | sed 's/\"//g')
if [[ -z "$check_modules" ]]; then
    return
elif [[ "$check_modules" == "all" ]]; then
    modules=($(find $module_dir -mindepth 2 -type f -name "main.sh"))
    for module in ${modules[@]}; do
        source $module
    done
elif [[ "$check_modules" == *$'\n'* ]]; then
    first_line=$(echo "$check_modules" | head -n 1)
    last_line=$(echo "$check_modules" | tail -n 1)
    if [[ "$first_line" == "[" ]] && [[ "$last_line" == "]" ]]; then
        mapfile -t modules < <(yq '.modules[]' $config_file | sed 's/\"//g')
        for module in ${modules[@]}; do
            if [[ -d "$modules_dir/$module" ]]; then
                if [[ -f "$modules_dir/$module/main.sh" ]]; then
                    source $modules_dir/$module/main.sh
                else
                    echo "error: file \"main.sh\" was not found in module \"$module\"."
                fi
            else
                echo "error: module \"$module\" not found."
            fi
        done
    else
        echo "error: wrong syntax in the field \".modules\" in $config_file."
    fi
else
    echo "error: wrong syntax in the field \".modules\" in $config_file."
fi

# undeclaring variables
unset this_file_path
unset main_dir
unset config_file
unset modules_dir
unset check_modules
unset first line
