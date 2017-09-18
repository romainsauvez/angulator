#!/bin/

#####################################################################
# ANGULATOR v1.0  --  Angular(2/4) file generator
#
# autor: Romain Sauvez
# github: https://github.com/romainsauvez/angulator
#
# description : generate module, component, service and routing
# for your Angular project.
#
#
# Put this script in the app folder of your
# Angular project.
#
#####################################################################



# OPTIONS ###########################################################

# prefix for the component selector
PREFIX_FOR_SELECTOR=''

# specify css file type (css, scss, sass..)
CSS_FILE_TYPE='css'

#####################################################################



# color
PURPLE='\033[0;35m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

# name of the created element
CURRENT_NAME=''

# name of the created element with first letter uppercase
CURRENT_NAME_CAPITAL=

# path of the created element
CURRENT_PATH=''

# type element : module, component or service
CURRENT_ELEMENT=''

# should module/component contain service
WITH_SERVICE=0

# should module contain routing
WITH_ROUTING=0

WITH_HTML=1



# creation of html file
function generateHtml {

 completeFilePath=$CURRENT_PATH$CURRENT_NAME'.component.html'

 touch $completeFilePath
 cat <<EOT >> $completeFilePath
   <div style="color:red">$CURRENT_NAME_CAPITAL</div>

EOT

}


# creation of css file
function generateCss {

 completeFilePath=$CURRENT_PATH$CURRENT_NAME'.component.'$CSS_FILE_TYPE

 touch $completeFilePath
 cat <<EOT >> $completeFilePath


EOT

}

# creation of routing file
function generateRouting {

 completeFilePath=$CURRENT_PATH$CURRENT_NAME'-routing.module.ts'

 touch $completeFilePath

 cat <<EOT >> $completeFilePath
import { NgModule } from '@angular/core';
import { Routes, RouterModule, PreloadAllModules } from '@angular/router';
import { ${CURRENT_NAME_CAPITAL}Component } from './$CURRENT_NAME.component';

export const ROUTES: Routes = [
    { path: '', component: ${CURRENT_NAME_CAPITAL}Component}
];

@NgModule({
  imports: [RouterModule.forChild(ROUTES)],
  exports: [RouterModule]
})

export class ${CURRENT_NAME_CAPITAL}RoutingModule {
}

EOT

}

# creation of directive file
function generateDirective {

 completeFilePath=$CURRENT_PATH$CURRENT_NAME'.directive.ts'

 touch $completeFilePath

 cat <<EOT >> $completeFilePath
import { Directive, ElementRef, Renderer } from '@angular/core';


@Directive({ selector: '[${CURRENT_NAME}]' })
export class ${CURRENT_NAME_CAPITAL}Directive {

    constructor(el: ElementRef, renderer: Renderer) {

    }

}


EOT
}
# creation of service file
function generateService {

 completeFilePath=$CURRENT_PATH$CURRENT_NAME'.service.ts'

 touch $completeFilePath

 cat <<EOT >> $completeFilePath
import { Injectable } from '@angular/core';

@Injectable()
export class ${CURRENT_NAME_CAPITAL}Service {

  constructor() {

  }

}


EOT

}


# creation of component file
function generateComponent {

 if [ $WITH_SERVICE -eq 1 ]; then
    generateService
 fi

 if [ $WITH_HTML -eq 1 ]; then
    generateHtml
    generateCss
 fi

completeFilePath=$CURRENT_PATH$CURRENT_NAME'.component.ts'

touch $completeFilePath

cat <<EOT >> $completeFilePath
import { Component } from '@angular/core';
EOT

if [ $WITH_SERVICE -eq 1 ]; then
cat <<EOT >> $completeFilePath
import { ${CURRENT_NAME_CAPITAL}Service } from './$CURRENT_NAME.service';
EOT
fi

cat <<EOT >> $completeFilePath

@Component({
  selector: '$PREFIX_FOR_SELECTOR$CURRENT_NAME',
EOT

if [ $WITH_SERVICE -eq 1 ]; then
cat <<EOT >> $completeFilePath
  providers: [${CURRENT_NAME_CAPITAL}Service],
EOT
fi

if [ $WITH_HTML -eq 1 ]; then
cat <<EOT >> $completeFilePath
  templateUrl: './$CURRENT_NAME.component.html',
  styleUrls:  ['./$CURRENT_NAME.component.css']
EOT
fi

cat <<EOT >> $completeFilePath
})

export class ${CURRENT_NAME_CAPITAL}Component {

EOT


if [ $WITH_SERVICE -eq 1 ]; then
cat <<EOT >> $completeFilePath
    constructor(private ${CURRENT_NAME}Service: ${CURRENT_NAME_CAPITAL}Service) {

    }
}
EOT
else
cat <<EOT >> $completeFilePath
    constructor() {

    }
}
EOT
fi

}



# creation of module file
function generateModule {

if [ $WITH_SERVICE -eq 1 ]; then
    generateService
fi

if [ $WITH_HTML -eq 1 ]; then
    generateHtml
    generateCss
fi

if [ $WITH_ROUTING -eq 1 ]; then
    generateRouting
fi

generateComponent

completeFilePath=$CURRENT_PATH$CURRENT_NAME'.module.ts'

touch $completeFilePath

cat <<EOT >> $completeFilePath
import {NgModule} from '@angular/core';
EOT

if [ $WITH_ROUTING -eq 1 ]; then
cat <<EOT >> $completeFilePath
import {${CURRENT_NAME_CAPITAL}RoutingModule} from './${CURRENT_NAME}-routing.module';
EOT
fi

cat <<EOT >> $completeFilePath
import {${CURRENT_NAME_CAPITAL}Component} from './$CURRENT_NAME.component';

@NgModule({
EOT

if [ $WITH_ROUTING -eq 1 ]; then
cat <<EOT >> $completeFilePath
    imports: [
        ${CURRENT_NAME_CAPITAL}RoutingModule
    ],
EOT
else
cat <<EOT >> $completeFilePath
    imports: [],
EOT
fi

cat <<EOT >> $completeFilePath
    declarations: [
        ${CURRENT_NAME_CAPITAL}Component
    ],
    exports: [
      ${CURRENT_NAME_CAPITAL}Component
    ]

})
export class ${CURRENT_NAME_CAPITAL}Module {
}


EOT

}

# show header/title
function displayHeader {
 clear
 echo -e ""
 echo -e ""
 echo -e "               ${BOLD}${PURPLE}ANGULATOR${RESET}"
 echo -e ""
}

# creation of files
function displayFinalProcess {

 displayHeader

 echo -e "               Initialisation..."
 echo -e "               File generation..."

 case $CURRENT_ELEMENT in
    "module")

        if [ $TEMP_PATH ]; then
            path=$TEMP_PATH$CURRENT_NAME'/'
        else
            path=$CURRENT_NAME'/'
        fi
        mkdir -p $path
        CURRENT_PATH=$path

        generateModule
        ;;

    "component")

        if [ $TEMP_PATH  ]; then
            if [ $WITH_HTML -eq 1 ]; then
                path=$TEMP_PATH$CURRENT_NAME'/'
            else
                path=$TEMP_PATH'/'
            fi
        else
            if [ $WITH_HTML -eq 1 ]; then
                path=$CURRENT_NAME'/'
            fi
        fi

        if [ $path ]; then
            mkdir -p $path
            CURRENT_PATH=$path
        fi

        generateComponent
    ;;

    "service")

        if [ $TEMP_PATH ]; then
            path=$TEMP_PATH
            mkdir -p $path
        else
            path=''
        fi

        CURRENT_PATH=$path

        generateService
    ;;
    "directive")

        if [ $TEMP_PATH ]; then
            path=$TEMP_PATH
            mkdir -p $path
        else
            path=''
        fi

        CURRENT_PATH=$path

        generateDirective
    ;;
    *)

    ;;
 esac

 echo -e ""
 echo -e "               ${GREEN}Creation complete !${RESET}"
 echo -e ""
 echo -e ""
 echo -e ""
}

# show name forms
function displayNameForms {
 displayHeader

 echo -e "               Define name of the" $CURRENT_ELEMENT ":"
 echo -e ""
 echo -e "                 ${RED}Can not be empty.${RESET}"
 echo -e "                 ${RED}Must be camel case or dash case${RESET}"
 echo -e "                 ${RED}Must not contain any special characters or dot (exept -).${RESET}"
 echo -e ""
 read -p '               Enter the name (and press enter) : ' element_names

 if [ -z $element_names ]; then
    clear
    break
 fi

 name=$element_names

 IFS='-' read -ra ROOTNAME <<< "$name"
 for i in "${ROOTNAME[@]}"; do
    nameup=`echo ${i:0:1} | tr  '[a-z]' '[A-Z]'`${i:1}
    nameCapital="$nameCapital$nameup"
 done

 CURRENT_NAME=$name
 CURRENT_NAME_CAPITAL=$nameCapital

 displayPathForms

}

# show path forms
function displayPathForms {


 displayHeader

 echo -e "               Define path of the" $CURRENT_ELEMENT ":"
 echo -e ""
 echo -e "                 ${RED}If empty, will be created at the same level as this script.${RESET}"
 echo -e "                 ${RED}Do not specify the folder name of the" $CURRENT_ELEMENT", it will be created by default.${RESET}"
 echo -e ""
 read -p '               Enter the path (and press enter) : ' path_names

 #on test si l'emplacement est vide
 if [ $path_names ]; then
    TEMP_PATH=$path_names'/'
 fi

 displayFinalProcess
}

# show module menu
function displayModuleMenu {

 displayHeader

 echo -e "               Choose your module type :"
 echo -e ""
 echo -e "               ${YELLOW}1${RESET}  Basic (module, component, html, css)"
 echo -e "               ${YELLOW}2${RESET}  Basic with service"
 echo -e "               ${YELLOW}3${RESET}  Basic with routing"
 echo -e "               ${YELLOW}4${RESET}  Global (basic, service, routing)"
 echo -e "               ${YELLOW}5${RESET}  Module + component"
 echo -e ""
 echo -e "               6  Back to main menu"
 echo -e "               7  Quit"
 echo -e ""
 read -s -p "               Enter your choice [1-6] " -n1 choice

 CURRENT_ELEMENT='module'

 case $choice in
    "1")
        displayNameForms
        ;;
    "2")
        WITH_SERVICE=1
        displayNameForms
    ;;
    "3")
        WITH_ROUTING=1
        displayNameForms
    ;;
    "4")
        WITH_SERVICE=1
        WITH_ROUTING=1
        displayNameForms
        ;;
    "5")
        WITH_HTML=0
        displayNameForms
        ;;
    "6")
        displayMainMenu
    ;;
    *)
        clear
    ;;
esac
}

# show component menu
function displayComponentMenu {

 displayHeader

 echo -e "               Choose your component type :"
 echo -e ""
 echo -e "               ${YELLOW}1${RESET}  Basic (component, html, css)"
 echo -e "               ${YELLOW}2${RESET}  Basic with service"
 echo -e "               ${YELLOW}3${RESET}  Component only"
 echo -e ""
 echo -e "               4  Back to main menu"
 echo -e "               5  Quit"
 echo -e ""
 read -s -p "               Enter your choice [1-5] " -n1 choice

 CURRENT_ELEMENT='component'

 case $choice in
    "1")
        displayNameForms
        ;;
    "2")
        WITH_SERVICE=1
        displayNameForms
    ;;
    "3")
        WITH_HTML=0
        displayNameForms
    ;;
    "4")
        displayMainMenu
    ;;
    *)
        clear
    ;;
 esac
}

# show main/first menu
function displayMainMenu {

 displayHeader

 echo -e "               What do you want to create ?"
 echo -e ""
 echo -e "               ${YELLOW}1${RESET}  Module"
 echo -e "               ${YELLOW}2${RESET}  Component"
 echo -e "               ${YELLOW}3${RESET}  Service"
 echo -e "               ${YELLOW}4${RESET}  Directive"
 echo -e ""
 echo -e "               5  Quit"
 echo -e ""
 read -s -p "               Enter your choice [1-5] " -n1 choice

 case $choice in
    "1")
        displayModuleMenu
        ;;
    "2")
        displayComponentMenu
    ;;
    "3")
        CURRENT_ELEMENT='service'
        displayNameForms
    ;;
    "4")
        CURRENT_ELEMENT='directive'
        displayNameForms
    ;;
    *)
        clear
    ;;
 esac
}

# detect if this script is in the app folder
# of an AngularJs project
function detectAppFolder {

 clear

 # get the parent folder of this script
 completPath="$PWD"
 IFS='/' read -ra ROOTNAME <<< "$completPath"
 currentFolder=${ROOTNAME[${#ROOTNAME[@]}-1]}

 # folder to detect
 folderNeeded='app'

 if [ "$currentFolder" == "$folderNeeded" ]; then
    displayMainMenu
 else
    displayHeader
    echo -e "               ${RED}Warning :${RESET} this script is not in the app folder "
    echo -e "               of your Angular project."
    echo -e ""
    read -p "               Press enter to continue..."
    displayMainMenu

 fi
}

# start application ==============================================

detectAppFolder

#displayMainMenu

# ==============================================



