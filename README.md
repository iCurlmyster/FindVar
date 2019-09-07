# FindVar
FindVar is a simple VIM plugin that allows a user to search for a word in file(s) with configurable settings and displays the results in a scratch window.

This project is mainly for learning purposes of vimscript and VIM plugins.

This project will more than likely evolve as I learn about new things that I would like to add to this plugin to make it better.

## Usage

There is a simple FindVar command and function to call.

```
:FindVar
```

By default each search is recursive, displays the line number the word was found on, and is case-insensitive.

*see Global Variables to see how to configure this*

### Arguments
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

