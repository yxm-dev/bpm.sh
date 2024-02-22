#! /bin/bash

# including core scripts
this_file_path=${BASH_SOURCE%/*}
main_dir=${this_file_path%/*} 
cores=($(find $main_dir/core -type f -name "*.sh" ))
for core in ${cores[@]}; do
    source $core
done

# undeclaring variables
unset this_file_path
unset main_dir
