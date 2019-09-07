# FindVar
FindVar is a simple VIM plugin that allows a user to search for a word in file(s) with configurable settings and displays the results in a scratch window.

This project is mainly for learning purposes of vimscript and VIM plugins.

This project will more than likely evolve as I learn about new things that I would like to add to this plugin to make it better.

## Usage

There is a simple FindVar command and function to call.

```
:call FindVar()
```

By default each search is recursive, displays the line number the word was found on, and is case-insensitive.

### Arguments
The function takes up to three optional arguments.

Arguments:
- Base directory to start looking at
- The word to look through the file(s) for
- String with comma separated GLOB patterns for matching files

Example usage:
```
:call FindVar("~/Documents/project", "parseArguments", "*.hpp,*cpp")
```

This call will start searching for the word `parseArguments` in the `~/Documents/project` directory but only display results where the file was a `.hpp` or `.cpp` file.

Default values for the arguments:
- The directory is set to the level that VIM was started at
- The word will be the current word the is under the cursor in VIM
- Searches through all files


