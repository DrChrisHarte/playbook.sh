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
YELLOW="\033[33m"
BOLDBLUE="\033[1;34m"
ENDCOLOR="\033[0;0m"

function print_codeblock () {
    echo -ne "${YELLOW}"
    printf '%s\n' "$1"
    echo -ne "${ENDCOLOR}"
}
            
    
function print_heading () {
    echo -ne "${BOLDBLUE}"
    printf '%s\n' "$1"
    echo -ne "${ENDCOLOR}"
}

function prompt_user () {
    echo -ne "${RED}"
    read -p "$1" next
    echo -e "${ENDCOLOR}"
}

function exec_codesnippet() {

    if [[ -n "${codesnippet}" ]]
        then
        if [[ $lang = "bash" ]]
        then
            print_codeblock "**** EXECUTING CODE BLOCK *****"
            eval "${codesnippet}"
            print_codeblock "**** EXECUTION COMPLETE ****"
            echo ""
            codesnippet=""
            lang=""
        else
            echo "Language in codeblock not supported by playbook.sh"
        fi
    fi
}

myfile=$1

{

fence='```'
code=false
codesnippet=""
lang=""
newline=$'\n'

# print the title out
read -r -u 3 t
print_heading "$t"

while IFS="" read -r -u 3 p || [ -n "$p" ]
do
    # read the file line by line  
   
    # check for triple backticks ``` start or end of code block
    if [[ $p = ${fence}* ]]
    then
    	if [[ ${code} = true ]]
    		then 
    			# found end of code block
			code=false
    		else
    			# found a new code block
			    codesnippet=""
                code=true
                if [[ $p = "${fence}bash" ]]
                    then
                    lang="bash"
                fi
                printf '%s\n' "$p"
    			continue
    	fi
    fi
    
    if [[ $code = true ]]
    then
        codesnippet="${codesnippet}${newline}${p}"	
    	printf '%s\n' "$p"
    else
       if [[ $p = \#* ]]
    	  then
    	    # if line starts with # then it's the start of the next heading 
    	    # and we should prompt the user
    	    if [[ $codesnippet != "" ]]
            then
                prompt_user "Press enter to continue, s to skip, a to abort "
   	        
    	        # s = skip 
    	        if [[ $next = s ]] 
    	            then
    		        print_codeblock "Skipped code block"; echo
                    print_heading "$p"
    		        codesnippet=""
                    continue
                fi
            else
                prompt_user "Press enter to continue, a to abort "
            fi
    	    
    	    # a = abort 
    	    if [[ $next = a ]]
    		    then 
    		    echo "exiting"
    		    exit
    	    
    	    else
                # if there's something in the codesnippet then run it
                exec_codesnippet
    	    fi
    	    print_heading "$p" 
    	  else	  
    	    printf '%s\n' "$p"
    	  fi
    fi
    
done 
} 3< $myfile

# final prompt
prompt_user "Press enter to continue, s to skip "

# s = skip 
if [[ $next = s ]] 
    then
    print_heading "$p"
else
    # if there's something in the codesnippet then run it
    exec_codesnippet
fi
 
