# Screenshots

This is a simple bash script for creating screenshots with filename and directory being in ShareX-like format.

## Dependencies

```
bash
xdotool
libnotify (if not built-in)
maim
xclip
```

## Usage

Basically, you use it like any other shell script.

### Instructions

First make the script executable, if already isn't, and then run e.g.

```
./screenshots.sh
```

By default it will create a screenshot of the entire screen, copy it to clipboard and save to the Pictures folder of a current user.

This script works best when binded to a key.

To upload the image, configure the `upload_cmd` command.

### Additional parameters

```
-h | --help         print help dialog
-v | --verbose      output more info
-a | --area         screenshot an area
-w | --window       screenshot current window
-f | --full         screenshot entire screen
-l | --location     select location for a screenshot file
-s | --silent       don't show notification after successful screenshot
-u | --upload       upload resulting image with a given command
```
