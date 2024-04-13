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

modules_all=$(yq '.modules' $config_file)
modules_array=($(yq '.modules[]' $config_file))

if [[ -z "$modules_all" ]] && [[ -z "$modules_array" ]]; then
    return
elif [[ "$modules_all" == "all" ]]; then
    modules=($(find $module_dir -mindepth 2 -type f -name "main.sh"))
    for module in ${modules[@]}; do
        source $module
    done
elif [[ -n "$modules_array" ]]; then
    for module in ${modules_array[@]}; do
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

# undeclaring variables
unset this_file_path
unset main_dir
unset config_file
unset modules_dir
unset modules_all
unset modules_array
