# Dependences

* [yq](https://github.com/mikefarah/yq) v. 4.x

# Nomenclature Best Practices

## Packages and Files

1. There is no formal naming rules for the directory of a package. However, it is recommended to use a descriptive single word. If it is not possible, we recommend to use underscores: `my_bpm_package/`. 
2. Try to use a descriptive single word to name a package. If it is not possible, use underscores to separate the words: `package_name`.
    * This is important because, by construction, the ID of the package is the uppercase version of its name. Thus, using camel case should create unreadable IDs.
    * The best option would be to have package name equal to directory name.
3. Similarly, try to use a descriptive single word to name a file `filename.sh`. If it is not possible, use underscores: `file_name.sh`
    * Again, this is importante because, when the file is a data file, its name is used in uppercase to call the data, so that a camel case could create unreadable calls. 

## Functions and Variables 
 
4. The main function in `my_bpm_package/utils/file_name.sh` should be named `PACKAGE_NAME::file_name`
    * This forces to use a descriptive `file_name.sh`
5. The additional functions should use the pattern `PACKAGE_NAME::file_name::functionName`
6. Use camel case `variableName` to define variables inside the function `PACKAGE_NAME::file_name::functionName`

## Data

7. Try to always declare data in external files `my_bpm_package/data/file_name.sh` inside the data directory `my_bpm_package/data`
8. Use the pattern `PACKAGE_NAME::FILE_NAME::DATA_NAME` to declare arrays and associative arrays.
9. If there is some "main data" in `my_bpm_package/data/file_name.sh` it should be named `PACKAGE_NAME::FILE_NAME`

# To Do

* fix some way to recognize the aliases in modules when doing `bpm load module && some_alias`
