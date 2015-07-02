# ubuntu-config
A series of modular bash scripts to configure a fresh Ubuntu install. Can be run in interactive mode or automated using saved responses.

## Usage
-i <response-file.rf> = Run interactively and save responses given to <response-file.rf>. If an existing response file is given, new responses will be apprnded and old responses overwritten on an individual basis. If no response file is given, configurations will be applied but not saved.

-a <response-file.rf> = Run in automated mode and load responses from <response-file.rf>. 

