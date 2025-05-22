#!/bin/bash

PS3="Select an operation [1-5]: "

# check if ran with sudo or as root (both resulting in a user id of 0)
if [ "$(id -u)" != 0 ]
then
  echo -e "aptman does not have superuser permissions!\nmost operations will likely fail!\n(quit and run \"sudo !!\" or switch to root (UID 0) to fix)"

fi

select op in install remove upgrade search exit
do
  case $op in
  install)
    read -p "Install what? " package_to_install
    pacman -S "$package_to_install"
    ;;
  remove)
    read -p "Remove what? " package_to_remove
    pacman -Rn package_to_remove
    ;;
  upgrade)
    pacman -Syu
    ;;
  search)
    read -p "Search for what? " search_term
    # check if search output exceeds 25 lines (max on some old hardware) and ask wether or not to use less
    if [ "$(pacman -Ss "$search_term" | wc -l)" -ge 25 ]
    then
      read -p "Search output has more lines than an usual terminal, use less? (Y/n) " use_less
      case $use_less in
      [Yy]* )
      pacman -Ss "$search_term" | less -R
      ;;
      [Nn]* )
      pacman -Ss "$search_term"
      ;;
      "")
      pacman -Ss "$search_term" | less -R
      ;;
      *)
      echo "Invalid option"
      ;;
    esac
  fi

    ;;
  exit)
    exit 0
    ;;
  "")
    echo "No operation specified, quitting..."
    exit 0
    ;;
  *)
    echo "Invalid operation, quitting..."
    exit 0
    ;;

  esac
  break
done
