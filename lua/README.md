# Config File Structure

## youzark

1. Plugin/FileType Independent options
2. command / autocommand / options / variables
3. All plugins

## Other Directories

tayler made functions for different usage   
Only one interface can be exposed per directory, should cut dependencies between different  
modules and between modules and configuration files by define Commands(Write plugin-like helpers)  

### 1 programming: 

define helpers for programming automation for different languages:  

> Expected Feature:
> 1. Global : layout config, floating windows, terminal
> 2. LSP : auto-completetion, linting, snippets
> 3. DAP : scope, local, watch, pretty printer, stack, terminal, remote ,Per function debug
> 4. Build : local bulid, project build, automation.
> 5. Test : per-case test, test automation
> 6. Documentation : auto document, quick cheatsheet

### 2 office:
1. MarkDown:
    1. automate screen cut

2. Latex:
    1. automate taking screen cut

### 3 util:
