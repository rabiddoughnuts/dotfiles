# Shell dotfiles

This folder is a set of config files for my fish shell setup with aliases and functions that I like to use. There are several files, so I will break each into its own subheader. The file structer is made to mirror their actual install location to make it easier to make the install script place things correctly, to include the ability to add files and them be included without much rework

## Config.fish

This is the main fish config file, and it sources the other two files. It updates my modprobed-db, runs a greeting that either displays a maintenance report I use or fastfetch, and has several other functions and variables I can't explain without getting heavy into other projects and things I run. I then have aliases seperated by broad categories of what they are for.

## cachyos-config.fish && done.fish

These are actually both default files, except I changes some very small stuff. I changed the specific eza premades to be the styles I wanted and I changed the cd commands to use z to make sure z keeps track of all my movement for expedient movement later.
