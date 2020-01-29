#!/bin/bash
### simple screenshotter (selected area, active window or entire screen)

###
# default variables
verbose="false"
mode="full"
silent="false"
upload="false"
screenshot_subdir="Screenshots/ShareX"

# script info
help_dialog="Simple script for making screenshots

example usage:      ./screenshots.sh -w -l /home/$USER/Pictures
                    will create a screenshot of currently focused window and 
                    save it to the Pictures folder of a current user

options:
-h | --help         print this dialog
-v | --verbose      output more info
-a | --area         screenshot an area
-w | --window       screenshot current window
-f | --full         screenshot entire screen
-l | --location     select location for a screenshot file
-s | --silent       don't show notification after successful screenshot
-u | --upload       upload resulting image with a given command"

###
#
function file_init() {
  # file format and location
  curr_proc=$(cat /proc/$(xdotool getwindowpid $(xdotool getwindowfocus))/comm)

  if [ "${curr_proc}" = "" ] || [ "${mode}" = "full" ] || [ "${mode}" = "" ]; then
    filename_format="$(date +"%Y-%m-%d_%H-%M-%S").png"
  else
    filename_format="${curr_proc}_$(date +"%Y-%m-%d_%H-%M-%S").png"
  fi

  pictures_folder=$(xdg-user-dir PICTURES)
  location="$pictures_folder/$screenshot_subdir"

  # create filename
  file_dir="${location}/$(date +%Y)/$(date +%m)"
  if [ ! -e ${file_dir} ]; then
    mkdir -p ${file_dir}
    if [ "${?}" != "0" ]; then
      notify error "Couldn't create given directory"
      if [ "${verbose}" = "true" ]; then
        echo "mkdir failed"
      fi
      exit 1
    fi
  fi
  img_file="${file_dir}/${filename_format}"
}

function take_screenshot() {
  if [ "${mode}" = "area" ] && [ "${verbose}" = "true" ]; then
    echo "Waiting for area selection"
  fi
  cmd="screenshot_${mode}_command"
  cmd=${!cmd//\%img/${1}}

  shot_err="$(${cmd} &>/dev/null)"
  if [ "${?}" != "0" ]; then
    notify error "Error while taking a screenshot"
    if [ "${verbose}" = "true" ]; then
      echo "Executing '${cmd}' has failed"
    fi
    exit 1
  fi
}

function notify() {
  if [ "${1}" = "error" ]; then
    notify-send --hint=int:transient:1 -a Screenshot -u low -c "im.error" -i error -t 2000 "${2}"
  elif [ "${silent}" = "false" ]; then
    notify-send --hint=int:transient:1 -a Screenshot -u low -c "transfer.complete" -t 2000 "${2}" "${3}"
  fi
}

function verify() {
  if [ ! -f "${img_file}" ]; then
    if [ "${verbose}" = "true" ]; then
      echo "File '${img_file}' doesn't exist!"
    fi
    exit 1
  else
    if [ "${upload}" = "false" ]; then
      xclip -selection clipboard -t image/png -i ${img_file}
      notify ok "Screenshot succesfully taken:" "${img_file}"
    fi
    if [ "${verbose}" = "true" ]; then
      echo "Success. File location: ${img_file}"
    fi
  fi
}

function upload() {
  upload_cmd=""
  output=$(eval "${upload_cmd}")
  if [[ $output = *"https"* ]]; then
    echo "${output}" | xclip -selection clipboard
    notify ok "Screenshot succesfully uploaded:" "${output}"
    if [ "${verbose}" = "true" ]; then
      echo "${output}"
    fi
  else
    notify error "Error while uploading the screenshot"
    if [ "${verbose}" = "true" ]; then
      echo "Executing '${upload_cmd}' has failed"
      echo "${output}"
    fi
    exit 1
  fi
}

###
# script options
while [ ${#} != 0 ]; do
  case ${1} in
    -h | --help)
      echo "${help_dialog}"
      exit 1
      break;;
    -v | --verbose)
      verbose="true"
      shift;;
    -a | --area)
      mode="area"
      shift;;
    -w | --window)
      mode="window"
      shift;;
    -f | --full)
      mode="full"
      shift;;
    -l | --location)
      location="${2}"
      shift;;
    -s | --silent)
      silent="true"
      shift;;
    -u | --upload)
      upload="true"
      shift;;
    *)
      break;;
  esac
done

###
#
file_init

# commands
screenshot_area_command="maim -m 10 -s ${img_file}"
screenshot_window_command="maim -m 10 -i $(xdotool getactivewindow) ${img_file}"
screenshot_full_command="maim -m 10 ${img_file}"

#
take_screenshot "${img_file}"

#
verify

#
if [ "${upload}" = "true" ]; then
  upload
fi
