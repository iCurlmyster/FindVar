# FindVar
FindVar is a simple VIM plugin that allows a user to search for a word in file(s) with configurable settings and displays the results in a scratch window.

This project is mainly for learning purposes of vimscript and VIM plugins.

This project will more than likely evolve as I learn about new things that I would like to add to this plugin to make it better.

## Usage

There are four commands:
- `FindVar`
- `FindVarWithWord`
- `FindVarInFiles`
- `FindVarOpenFile`

### FindVar

FindVar is the main command to use, which accepts 3 optional arguments.

This command performs a grep command to look for the usage of a given word in a given directory against all files or certain given types of files.

By default each grep search is recursive, displays the line number the word was found on, and is case-insensitive.

*see Global Variables to see how to configure this*

#### Arguments
The function takes up to three optional arguments.

Arguments:
- Base directory to start looking at
- The word to look through the file(s) for
- String with comma separated GLOB patterns for matching files

Example usage:
```
:FindVar "~/Documents/project", "parseArguments", "*.hpp,*cpp"
```

This call will start searching for the word `parseArguments` in the `~/Documents/project` directory but only display results where the file was a `.hpp` or `.cpp` file.

Default values for the arguments:
- The directory is set to the level that VIM was started at
- The word will be the current word the is under the cursor in VIM
- Searches through all files

### FindVarWithWord

FindVarWithWord is just like FindVar except it only accepts 2 optional arguments (which are the last 2 arguments in FindVar)

Example usage:
```
:FindVarWithWord "parseArguments", "*.hpp,*.cpp"
```

### FindVarInFiles

FindVarInFiles is just like FindVarWithWord and FindVar except it only accepts 1 optional argument (which is the last argument in FindVar)

Example Usage:
```
:FindVarInFiles "*.hpp,*.cpp"
```

### FindVarOpenFile

FindVarOpenFile command will grab and open a file at the given line number from the current line the cursor is on in the results buffer created from FindVar (FindVarWithWord and FindVarInFiles).

*this command only works inside the FindVar results buffer*

Example usage:
```
:FindVarOpenFile
```

### Global Variables

There are three global variables that can be customized in a user's `.vimrc` file.
- `g:findvar_base_cmds` The base flags used in the grep command. Default value is `-rni`
- `g:findvar_extra_cmds` Extra flags that a user would want to tag on. Default is nothing
- `g:findvar_default_file_matching` Default string with comma separated GLOB patterns for matching files. Default is nothing. This value always gets added if set.

Example usage:
```
let g:findvar_base_cmds = '-rni'
let g:findvar_extra_cmds = '-E'
let g:findvar_default_file_matching = '*.hpp,*.cpp'
```

