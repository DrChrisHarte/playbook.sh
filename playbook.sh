#!/bin/bash

# playbook.sh 
# 
# run through a runbook formatted as a markdown file 
# use heading 1 as document title, use heading 2 and 3 as steps
# execute code in triple quotes if proceeded by an execute tag
# 
# 
# usage: 
# 
# playbook.sh [--format] <markdown.md>
# 
# without format:
# 
# display TOC of markdown and ask which step to start on - default to 1
# 
# on each step, output the markdown section and ask the user to if they want to continue, skip, or abort.
# 
# continue - execute any automation and move to next section
# skip - move to next section without executing automation
# abort - exit the script
# 
# 
# read each line, extract headings keep track of numbering, print TOC to screen.
# prompt user to choose section number to start on or press enter to start from the top.
# 
# with --format
# read the markdown file and add section numbers to each heading automatically. Remove existing numbering if necessary


# terminal colours
RED="\033[31m"
BOLDBLUE="\033[1;34m"
ENDCOLOR="\033[0;0m"

myfile=$1

{
read -r -u 3 t
    echo -e "${BOLDBLUE}"
    printf '%s\n' "$t"
    echo -e "${ENDCOLOR}"
while IFS="" read -r -u 3 p || [ -n "$p" ]
do
  if [[ $p = \#* ]]
  then
    echo -e "${RED}"
    read -p "Press enter to continue, s to skip, a to abort, or enter a heading number " next
    echo -e "${ENDCOLOR}"
    if [[ $next = s ]] 
    then
       continue
    elif [[ $next = a ]]
        then 
        echo "exiting"
        break
    fi
    echo -e "${BOLDBLUE}"
    printf '%s\n' "$p"
    echo -e "${ENDCOLOR}"  
  else	  
    printf '%s\n' "$p"
  fi
  
done 
} 3< $myfile
