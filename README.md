# ubuntu-config
A series of modular bash scripts to configure a fresh Ubuntu install. Can be run in interactive mode or automated using saved responses.

## Usage
`-s <save-file.rf>` = Save any interactive responses given to `<save-file.rf>`. If an existing response file is given for `<save-file.rf>`,any new responses will be appended and old responses overwritten on an individual basis. If no response file is given, all configurations will be applied, but responses will not saved.

`-l <load-file.rf>` = Load responses from `<load-file.rf>`. Options contained in `<load-file.rf>` will either be applied shown as default values for interactive prompts (default behavior, or if prompt `[-p]` flag is given), or applied automatically (if `[-q]` quiet flag is given).

`-p` = Always prompt before applying configurations. If a response file is loaded using the `-l` argument, the values in that file will be shown as the default values for their respective prompts.

`-q` = Never prompt before applying configurations. Options specified in a response file loaded using the `-l` argument will be applied without prompting, and options not specified will be ignored.

`-v` = More verbose logging.

## Config Modules
* apt = Aptitude Package Manager
* * update-all alias = 
