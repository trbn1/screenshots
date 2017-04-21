# Screenshots
This is a simple bash script for creating screenshots with filename and directory being in ShareX-like format.
## Dependencies
```
bash
xdotool
libnotify (if not built-in)
gnome-screenshot
xclip
```
## Usage
Basically, you use it like any other shell script
### Instructions
First make the script executable, if already isn't
Then run e.g.
```
./screenshots.sh
```
By default it will create a screenshot of the entire screen and save it to the Pictures folder of a current user
### Additional parameters
```
-h | --help         print help dialog
-v | --verbose      output more info
-a | --area         screenshot an area
-w | --window       screenshot current window
-f | --full         screenshot entire screen
-l | --location     select location for a screenshot file
```
