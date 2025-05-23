#!/bin/bash

lines_till_prompt=25

install(){
  target="$1"
  if [ "$target" == "" ]
  then
    read -p "Install what? " package_to_install
    pacman -S "$package_to_install"
  else
    pacman -S "$target"
  fi
}
remove(){
  target="$1"
  if [ "$target" == "" ]
  then
    read -p "Remove what? " package_to_remove
    pacman -Rn "$package_to_remove"
  else
    pacman -S "$target"
  fi
}
upgrade(){
    pacman -Syu
}
search() {
    target="$1"
    if [ "$target" == "" ]
    then
      read -p "Search for what? " search_term
      # check if search output exceeds
      # the value of $lines_till_prompt (25 lines)
      # (maximum on some old hardware) and ask
      # wether or not to use less
      if [ "$(pacman -Ss "$search_term" | wc -l)" -ge $lines_till_prompt ]
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

    else
      pacman -Ss "$target"
    fi
}
query(){
  target="$1"
  if [ "$target" == "" ]
  then
    read -p "Find what package? (leave empty for all installed packages) " query_query # haha get it because it's the query of the query or something im really tired
    pacman -Q "$query_query"
  else
    pacman -Q "$target"
  fi
}
if [ "$1" != "" ]
then
case "$1" in
  install) install "$2" ;;
  remove) remove "$2" ;;
  upgrade) upgrade "$2" ;;
  search) search "$2" ;;
  query) query "$2" ;;
esac
else
PS3="Select an operation [1-5]: "

# check if ran with sudo or as root (both resulting in a user id of 0)
if [ "$(id -u)" != 0 ]
then
  echo -e "aptman does not have superuser permissions!\nmost operations will likely fail!\n(quit and run \"sudo !!\" or switch to root (UID 0) to fix)"

fi

select op in install remove upgrade search exit
do
  case $op in
  install) install ;;
  remove) remove ;;
  upgrade) upgrade ;;
  search) search ;;
  query) query ;;
  exit)
    exit 0
    ;;
  *)
    echo "Invalid or empty operation, quitting..."
    exit 0
    ;;

  esac
  break
done
fi
