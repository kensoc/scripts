#! /bin/bash
#==========================================================================
#	File:		git-workon.sh
#	Author:		Hardik Patel
#	Date:		03/04/2013
#	Version:	0.3
#	Usage:		This shell scripts parses the input xml file
#			and clone all the repos available in the xml file. 
#			Copy this tool in your manifest files and change the
#			tool to read your xxx.xml file
#
#	NOTE:		This tool is written based on Git Commands
#===========================================================================

#Getting 2nd Argument with below command
#PATH_LIST=` cat manifest.xml | awk '{print $2}' | grep "path=" | cut -d '=' -f2 | cut -d '"' -f2`
#Getting 3nd Argument with below command
REPO_LIST=` cat default.xml | awk '{print $3}' | grep "name=" | cut -d '=' -f2 | cut -d '"' -f2`

option=
PRODUCT=
TOOLS_DIR=`pwd`
WORKSPACE_DIR=${TOOLS_DIR}/../${PRODUCT}
REPO_DIR=
BRANCH=
NEW_BRACH=
NEW_TAG=

#Color code for Echo stements
if tty -s; then
  R='\e[0;31m'
  B='\e[0;34m'
  G='\e[0;32m'
  P='\e[0;35m'
  NC='\e[0m' # No Color
else
  R=''
  B=''
  G=''
  P=''
  NC=''
fi

#Check if Workspace Dir is Present or not
if [ ! -d $WORKSPACE_DIR ]; then
  echo -e "${G}Creating $PRODUCT Workspace $WORKSPACE_DIR ${NC}"
  mkdir $WORKSPACE_DIR
fi

if [ $# -gt 3 ]; then
	echo -e "${R}More Arguments are provided ${NC}"
exit 1
fi

NEW_BRANCH=$2
NEW_TAG=$2
MESSAGE="$3"

#Menu Help
print_command_lists_help()
{
	clear
	echo "************ Menu Help ************************"
	echo "==============================================="
	echo "`date` "
	echo 
	echo " Below Git commands are supported "
	echo
	echo " c	- Clone the project git repos"
	echo " p	- Print the project git repos list"
	echo " u	- Update the project git repos"
	echo " d	- Diff the two labels/Tags of project git repos"
	echo " s	- Check the current status of the project git repos"
	echo " F	- Force push of all project git repos"
	echo " b	- Creat new branch on all the project git repos. Takes Branch name as 2nd argument and switch to new branch"
	echo " S	- Switch to new specified branch/tag on all the project git repos. Takes branch/tag name as 2nd argument and switch to new branch"
	echo " L	- List all the branchs available on all the project git repos."
	echo " t	- Creat new tag on all the project git repos. Takes tag name as 2st argument and annotation as 3rd argument in string format"
	echo " h	- Menu command usage help"
	echo 
	return
}

#Print Repos
repo_print()
{

	for repo in $REPO_LIST

	do
	  echo -e "${B}The repo is $repo ${NC}"
	done

	return
}

#Clone the Repos
repo_clone()
{

	for repo in $REPO_LIST
	do
	  REPO_DIR=$(dirname ${repo})	  
	  
	  mkdir -p ${WORKSPACE_DIR}/${REPO_DIR}
	  cd  ${WORKSPACE_DIR}/${REPO_DIR}
	  echo ""
	  echo -e "${G}Cloning the $PRODUCT project git repo:$repo into $REPO_DIR ${NC}"
	  echo "=============================================================================================================="
	  	#Change the server address/path for your requirement/need
		git clone git@git.kensoc.com:$repo
	  cd - 
	  echo "--------------------------------------------------------------------------------------------------------------"
	  echo ""
	done
	echo -e "${G}Clone of $PRODUCT project repo is done !!! ${NC}"
	
	return
}

#Update reps
repo_update()
{

	for repo in $REPO_LIST

	do

	  cd ${WORKSPACE_DIR}/$repo
	  echo ""
	  echo -e "${B}Updating the $PRODUCT project git repo: $repo ${NC}"
	  echo "=============================================================================================================="
	  	git pull
	  cd -
	  echo "--------------------------------------------------------------------------------------------------------------"
	  echo ""
	done

	echo -e "${G}Update of $PRODUCT project repo is done !!! ${NC}"
	return
}

#Diff the two Labels/tags
repo_tag_diff()
{

	  echo -e "${R} TAGS DIFF is NOT WORKING. NEED TO FIX THIS COMMAND @@ HARDIK"
	#for repo in $REPO_LIST

	#do
	  #cd ${WORKSPACE_DIR}/$repo
	  #echo ""
	  #echo -e "${B}Diff the two Labels/Tags and generate the Change List: $repo ${NC}"
	  #echo "=============================================================================================================="
	  	#git diff
	  #cd -
	  #echo "--------------------------------------------------------------------------------------------------------------"
	  #echo ""

	#done
        #echo -e "${G}"Diff the two Labels/Tags and generate the Change List is done !!! ${NC}"

	#return
}

#Current status of the  Repos
repo_status()
{

        for repo in $REPO_LIST

        do

	  cd ${WORKSPACE_DIR}/$repo
	  echo ""
          echo -e "${B}Current status of $PRODUCT project git repo:$repo ${NC}"
	  echo "=============================================================================================================="
	  	git status
	  cd -
	  echo "--------------------------------------------------------------------------------------------------------------"
	  echo ""
	done
	
	echo -e "${G}Status of  $PRODUCT project repo is done !!! ${NC}"
        return
}

#Force push of all the project repos
repo_force_push()
{

        for repo in $REPO_LIST

        do

	  cd ${WORKSPACE_DIR}/$repo
	  echo ""
          echo -e "${R}Force push of all the $PRODUCT project repos:$repo on branch:$BRANCH ${NC}"
	  echo "=============================================================================================================="
	        BRANCH=`git branch | cut -d ' ' -f2`
	        #git add .
	        #git commit -a -m "Force push made on $repo"
	  	git push -u origin $BRANCH
          cd -
	  echo "--------------------------------------------------------------------------------------------------------------"
	  echo ""

        done
          echo -e "${G}Force push of all the $PRODUCT project repos on branch $BRANCH is Done !!! ${NC}"

        return
}

#Create new brach on all the project repos
repo_create_branch()
{
	for repo in $REPO_LIST

        do

          cd ${WORKSPACE_DIR}/$repo
	  echo ""
	  echo  -e "${B}Creating new branch $NEW_BRANCH in $repo ${NC}"
	  echo "=============================================================================================================="
          	git checkout -b $NEW_BRANCH
	  cd -
	  echo "--------------------------------------------------------------------------------------------------------------"
	  echo ""

        done
	  echo  -e "${G}Creating new branch $NEW_BRANCH is done !!! ${NC}"

        return
}


# Switch to new branch Specified on all the project repos
repo_switch_branch()
{
	for repo in $REPO_LIST

        do

          cd ${WORKSPACE_DIR}/$repo
	  echo ""
	  echo  -e "${B}Switching to new branch/tag $NEW_BRANCH in $repo ${NC}"
	  echo "=============================================================================================================="
          	git checkout $NEW_BRANCH
	  cd -
	  echo "--------------------------------------------------------------------------------------------------------------"
	  echo ""

        done
	  echo  -e "${G}Switch to new branch/tag $NEW_BRANCH is done !!! ${NC}"

        return
}


# Listdown All the branchs Specified on all the project repos
repo_list_branch()
{
	for repo in $REPO_LIST

        do

          cd ${WORKSPACE_DIR}/$repo
	  echo ""
	  echo  -e "${B}List All the branches available in:$repo ${NC}"
	  echo "=============================================================================================================="
          	git branch -a
	  cd -
	  echo "--------------------------------------------------------------------------------------------------------------"
	  echo ""

        done
	  echo  -e "${G}List all the  branchs is done !!! ${NC}"

        return
}
#Create new Tag with Tag message on all the project repos
repo_create_tag()
{
	  echo -e "${R} TAGS DIFF is NOT WORKING. NEED TO FIX THIS COMMAND @@ HARDIK"
	#for repo in $REPO_LIST

	#do
	  #cd ${WORKSPACE_DIR}/$repo
	  #echo ""
	  #echo -e "${B}Creat the Tag/Label specified on the :$repo ${NC}"
	  #echo "=============================================================================================================="
	 	#git tag -a $NEW_TAG -m $MESSAGE
          	#git tag $NEW_TAG
	  #cd -
	  #echo "--------------------------------------------------------------------------------------------------------------"
	  #echo ""

	#done
	#echo -e "${G}Creat the Tag/Label specified is done !!! ${NC}"

	#return
}
#If no option is provided then print help menu
if [ $# -eq 0 ] ; then
	print_command_lists_help
	exit 1
fi

# main git command option loop
while getopts cpudsFbSLth0 option
do
	case "$option" in
		c)	
			echo -e "${G}Cloning the $PRODUCT project repos ${NC}"
			echo "==============================================="
			repo_clone;;
		p)
			echo -e "${B}Printing the $PRODUCT project repos ${NC}"
			echo "================================================"
			repo_print;;
		u)
			echo -e "${B}Updating the $PRODUCT project repos ${NC}"
			echo "================================================"
			repo_update;;
		d)	
			echo -e "${B}Diff the two labels/tags of $PRODUCT project repos ${NC}"
			echo "==============================================================="
			repo_tag_diff;;
		s)	
			echo -e "${B}Check the current status of the $PRODUCT project git repos ${NC}"
			echo "======================================================================="
			repo_status;;
		F)	
			echo -e "${R}Force push of all the $PRODUCT project git repos ${NC}"
			echo "============================================================="
			repo_force_push;;
		b)	
			echo -e "${R}Creat New branch on all the $PRODUCT project git repos ${NC}"
			echo "==================================================================="
			repo_create_branch;;
		S)	
			echo -e "${R}Switch to New specified branch on all the $PRODUCT project git repos ${NC}"
			echo "================================================================================="
			repo_switch_branch;;
		L)	
			echo -e "${R}Switch to New specified branch on all the $PRODUCT project git repos ${NC}"
			echo "================================================================================="
			repo_list_branch;;
		t)	
			echo -e "${R}Creat tag on all the $PRODUCT project git repos ${NC}"
			echo "============================================================"
			repo_create_tag;;
		h)
			print_command_lists_help;;
	esac
	#break

done
