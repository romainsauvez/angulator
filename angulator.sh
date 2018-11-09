#!/bin/bash

#####################################################################
# ANGULATOR  --  Angular(2+) file generator
#
# autor: Romain Sauvez
# github: https://github.com/romainsauvez/angulator
#
# description : generate module, component, service and routing
# for your Angular project.
#
# Put this script in the app folder of your
# Angular project.
#
# For install globaly : 
# chmod +x angulator.sh
# sudo cp angulator.sh /usr/local/bin/angulator
#
#####################################################################

# version of this script
VERSION='1.0.0'

# prefix for the component selector
PREFIX_FOR_SELECTOR='app'

# specify css file type (css, scss, sass..)
CSS_FILE_TYPE='scss'

# color
PURPLE='\033[0;35m'
YELLOW='\033[0;33m'
RED='\033[1;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'
UNDERLINE='\033[4m'

# name of the created element
CURRENT_NAME=''

# name of the created element with first letter uppercase
CURRENT_NAME_CAPITAL=

# path of the created element
CURRENT_PATH=''

# type element : module, component or service
CURRENT_ELEMENT=''

# should module contain routing
WITH_ROUTING=0

# should component contain html template
WITH_HTML=1

# should module contain component
WITH_COMPONENT=0

# service name
SERVICE_NAME=''

ROOT_SERVICE=0

# name of the config file
CONFIG_FILE_NAME='angulator.cfg'

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

# generate custom form control
function  generateCustomFormCtrl {

generateHtml
generateCss

completeFilePath=$CURRENT_PATH$CURRENT_NAME'.component.ts'

touch $completeFilePath

cat <<EOT >> $completeFilePath
import { Component, Input, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR, NG_VALIDATORS, FormControl } from '@angular/forms';

@Component({
  selector: '$PREFIX_FOR_SELECTOR-$CURRENT_NAME',
  templateUrl: './$CURRENT_NAME.component.html',
  styleUrls:  ['./$CURRENT_NAME.component.$CSS_FILE_TYPE'],
  providers: [
    { provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => ${CURRENT_NAME_CAPITAL}Component), multi: true },
    { provide: NG_VALIDATORS, useExisting: forwardRef(() => ${CURRENT_NAME_CAPITAL}Component), multi: true }
  ]
})

export class ${CURRENT_NAME_CAPITAL}Component implements ControlValueAccessor {

  private _value: any;

  @Input('value')
  set value(val) {
    this._value = val;
    this.onChange(this._value);
    this.onTouched();
  }

  get value() {
    return this._value;
  }

  onChange: any = () => { };
  onTouched: any = () => { };
  propagateChange: any = () => {};
  validateFn: any = () => {};

  constructor() {}

  registerOnChange(fn) {
    this.onChange = fn;
  }

  registerOnTouched(fn) {
    this.onTouched = fn;
  }

  writeValue(value) {
    if (value) {
      this.value = value;
    }
  }

  validate(c: FormControl) {
    return this.validateFn(c);
  }

}

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
EOT
if [ $ROOT_SERVICE -eq 1 ]; then
cat <<EOT >> $completeFilePath

@Injectable({
  providedIn: 'root',
})
EOT
else
cat <<EOT >> $completeFilePath

@Injectable()
EOT
fi
cat <<EOT >> $completeFilePath
export class ${CURRENT_NAME_CAPITAL}Service {

  constructor() {}

}


EOT
}

# creation of component file
function generateComponent {

 if [ $WITH_HTML -eq 1 ]; then
    generateHtml
    generateCss
 fi

completeFilePath=$CURRENT_PATH$CURRENT_NAME'.component.ts'

touch $completeFilePath

cat <<EOT >> $completeFilePath
import { Component } from '@angular/core';

@Component({
  selector: '$PREFIX_FOR_SELECTOR-$CURRENT_NAME',
EOT


if [ $WITH_HTML -eq 1 ]; then
cat <<EOT >> $completeFilePath
  templateUrl: './$CURRENT_NAME.component.html',
  styleUrls:  ['./$CURRENT_NAME.component.$CSS_FILE_TYPE']
EOT
fi

cat <<EOT >> $completeFilePath
})

export class ${CURRENT_NAME_CAPITAL}Component {

    constructor() {}

}


EOT
}

# creation of module file
function generateModule {

if [ $WITH_ROUTING -eq 1 ]; then
    generateRouting
fi

if [ $WITH_COMPONENT -eq 1 ]; then
    generateComponent
fi


completeFilePath=$CURRENT_PATH$CURRENT_NAME'.module.ts'

touch $completeFilePath

cat <<EOT >> $completeFilePath
import { NgModule } from '@angular/core';
EOT

if [ $WITH_ROUTING -eq 1 ]; then
cat <<EOT >> $completeFilePath
import { ${CURRENT_NAME_CAPITAL}RoutingModule } from './${CURRENT_NAME}-routing.module';
EOT
fi

if [ $WITH_COMPONENT -eq 1 ]; then
cat <<EOT >> $completeFilePath
import { ${CURRENT_NAME_CAPITAL}Component } from './$CURRENT_NAME.component';

EOT
else
cat <<EOT >> $completeFilePath

EOT
fi

cat <<EOT >> $completeFilePath
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

if [ $WITH_COMPONENT -eq 1 ]; then
cat <<EOT >> $completeFilePath
    declarations: [
      ${CURRENT_NAME_CAPITAL}Component
    ],
    exports: [
      ${CURRENT_NAME_CAPITAL}Component
    ]
EOT
else
cat <<EOT >> $completeFilePath
    declarations: [],
    exports: []
EOT
fi

cat <<EOT >> $completeFilePath
})

export class ${CURRENT_NAME_CAPITAL}Module {
}


EOT
}

# generate config file angulator.cfg
function generateConfigFile {
touch $CONFIG_FILE_NAME
cat <<EOT >> $CONFIG_FILE_NAME
prefix=$PREFIX_FOR_SELECTOR
cssType=$CSS_FILE_TYPE
EOT

displayMainMenu
}

# write config file
function writeConfig {
 displayHeader

 echo -e "             ${PURPLE}[Configuration 1/2]${RESET} Define prefix for component (default: app)"
 echo -e ""
 echo -e ""
 read -p '             Enter prefix : ' prefix

 #on test si l'emplacement est vide
 if [ $prefix ]; then
    PREFIX_FOR_SELECTOR=$prefix
 else
    PREFIX_FOR_SELECTOR='app'
 fi

 displayHeader

 echo -e "             ${PURPLE}[Configuration 2/2]${RESET} Choose css type (default: scss)"
 echo -e ""
 echo -e "              ${PURPLE}1${RESET}  css"
 echo -e "              ${PURPLE}2${RESET}  scss"
 echo -e "              ${PURPLE}3${RESET}  sass"
 echo -e ""
 read -s -p "             Your choice [1-3] " -n1 choice

case $choice in
    "1")
    CSS_FILE_TYPE='css'
    ;;
    "2")
    CSS_FILE_TYPE='scss'
    ;;
    "3")
    CSS_FILE_TYPE='sass'
    ;;
    *)
    CSS_FILE_TYPE='scss'
    ;;
 esac

rm $CONFIG_FILE_NAME
generateConfigFile

}

#read the config file
function readConfig {
 . angulator.cfg

 #parse data
 CSS_FILE_TYPE=$cssType
 PREFIX_FOR_SELECTOR=$prefix

 displayMainMenu
}

#manage configuration
function manageConfig {
if [ -f angulator.cfg ]; then
echo "file ok"
 readConfig
else
echo "file ko"
 writeConfig
fi
}


# show header/title
function displayHeader {
 clear
 echo -e ""
 echo -e "          ${BOLD}${CYAN}ANGULATOR${RESET} ${CYAN}[Angular file generator]${RESET}"
 echo -e ""
 echo -e ""
}

# creation of files
function displayFinalProcess {
 displayHeader

 echo -e "             Initialisation..."
 echo -e "             File generation..."

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
    "formControl")
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

        generateCustomFormCtrl
    ;;
    *)
    ;;
 esac

 echo -e ""
 echo -e "             ${GREEN}Creation complete !${RESET}"
 echo -e ""
 echo -e ""
 echo -e ""
 read -rsn1 -p"         --- Press any key to continue ---";
 displayMainMenu
}

# show name forms
function displayNameForms {
 displayHeader

 echo -e "             ${PURPLE}Define name of "$CURRENT_ELEMENT" :${RESET}"
 echo -e ""
 echo -e "             ${YELLOW}Use camelCase or dash-case.${RESET}"
 read -p '             Enter name (and press enter) : ' element_names

 if [ -z $element_names ]; then
    displayNameForms
 fi

 name=$element_names

 IFS='-' read -ra ROOTNAME <<< "$name"
 for i in "${ROOTNAME[@]}"; do
    nameup=`echo ${i:0:1} | tr  '[a-z]' '[A-Z]'`${i:1}
    nameCapital="$nameCapital$nameup"
 done

 CURRENT_NAME=$name
 CURRENT_NAME_CAPITAL=$nameCapital

COUNT=0
for i in "${ROOTNAME[@]}"; do
    if [ $COUNT -eq 0 ]; then
    namelow=`echo ${i:0:1} | tr  '[a-z]' '[a-z]'`${i:1}
    else
    namelow=`echo ${i:0:1} | tr  '[a-z]' '[A-Z]'`${i:1}
    fi
    nameService="$nameService$namelow"

    COUNT=1
 done

 SERVICE_NAME=$nameService

 displayPathForms

}

# show path forms
function displayPathForms {
 displayHeader

 echo -e "             ${PURPLE}Define path of the" $CURRENT_ELEMENT ":${RESET}"
 echo -e ""
 read -p '             Enter path (and press enter) : src/app/' path_names

 #on test si l'emplacement est vide
 if [ $path_names ]; then
    TEMP_PATH='src/app/'$path_names'/'
    else
    TEMP_PATH='src/app/'
 fi

 displayFinalProcess
}

# show module menu
function displayModuleMenu {
 displayHeader

 echo -e "             ${PURPLE}Choose module type :${RESET}"
 echo -e ""
 echo -e "              ${PURPLE}1${RESET}  Module only"
 echo -e "              ${PURPLE}2${RESET}  Module full (compo/html/css/routing)"
 echo -e ""
 echo -e "              ${PURPLE}3${RESET}  Back"
 echo -e ""
 read -s -p "             Enter your choice [1-3] " -n1 choice

 CURRENT_ELEMENT='module'

 case $choice in
    "1")
     displayNameForms
    ;;
    "2")
     WITH_COMPONENT=1
     WITH_HTML=1
     WITH_ROUTING=1
     displayNameForms
    ;;
    "3")
     displayMainMenu
    ;;
    *)
     displayModuleMenu      
    ;;
esac
}

# show component menu
function displayComponentMenu {
 displayHeader

 echo -e "             ${PURPLE}Choose component type :${RESET}"
 echo -e ""
 echo -e "              ${PURPLE}1${RESET}  Component only"
 echo -e "              ${PURPLE}2${RESET}  Component full (html, css)"

 echo -e ""
 echo -e "              ${PURPLE}3${RESET}  Back"
 echo -e ""
 read -s -p "             Enter your choice [1-3] " -n1 choice

 CURRENT_ELEMENT='component'

 case $choice in
    "1")
     WITH_HTML=0  
     displayNameForms
    ;;
    "2")
     WITH_HTML=1
     displayNameForms
    ;;
    "3")
     displayMainMenu
    ;;
    *) 
     displayComponentMenu     
    ;;
 esac
}

# show service menu
function displayServiceMenu {
 displayHeader

 echo -e "             ${PURPLE}Configuration: choose service${RESET}"
 echo -e ""
 echo -e "              ${PURPLE}1${RESET}  Basic service"
 echo -e "              ${PURPLE}2${RESET}  Root service (Angular 6+)"
 echo -e ""
 echo -e "              ${PURPLE}3${RESET}  Back"
 echo -e "              ${PURPLE}4${RESET}  Quit"
 echo -e ""
 read -s -p "             Enter your choice [1-4] " -n1 choice

 case $choice in
    "1")
    ROOT_SERVICE=0 
    CURRENT_ELEMENT='service'
    displayNameForms
    ;;
    "2")
    ROOT_SERVICE=1
    CURRENT_ELEMENT='service'
    displayNameForms
    ;;
    "3")
    displayMainMenu
    ;;
    "4")
    clear
    ;;
    *)
    displayServiceMenu
    ;;
 esac
}

# show config menu
function displayConfigMenu {
 displayHeader

 echo -e "             ${PURPLE}Configuration: choose process${RESET}"
 echo -e ""
 echo -e "              ${PURPLE}1${RESET}  Edit configuration"
 echo -e ""
 echo -e "              ${PURPLE}2${RESET}  Back"
 echo -e "              ${PURPLE}3${RESET}  Quit"
 echo -e ""
 read -s -p "             Enter your choice [1-3] " -n1 choice

 case $choice in
    "1")
    writeConfig  
    ;;
    "2")
    displayMainMenu
    ;;
    "3")
    clear
    ;;
    *)
    displayConfigMenu
    ;;
 esac
}

# show main/first menu
function displayMainMenu {
 displayHeader

 echo -e "             ${PURPLE}Choose file type : ${RESET}"
 echo -e ""
 echo -e "              ${PURPLE}1${RESET}  Module\t\t ${PURPLE}4${RESET}  Directive"
 echo -e "              ${PURPLE}2${RESET}  Component\t ${PURPLE}5${RESET}  Custom FormControl"
 echo -e "              ${PURPLE}3${RESET}  Service"
 echo -e ""
 echo -e "              ${PURPLE}6${RESET}  Config"
 echo -e "              ${PURPLE}7${RESET}  Quit"
 echo -e ""
 echo -e ""
 read -s -p "             Enter your choice [1-7] " -n1 choice

 case $choice in
    "1")
     displayModuleMenu
    ;;
    "2")
     displayComponentMenu
    ;;
    "3")
     displayServiceMenu
    ;;
    "4")
     CURRENT_ELEMENT='directive'
     displayNameForms
    ;;
    "5")
     CURRENT_ELEMENT='formControl'
     displayNameForms
    ;;
    "6")
     displayConfigMenu
    ;;
    "7")
     clear
    ;;
    *)
     displayMainMenu
    ;;
 esac
}

# startup application 
function startup {
 case $1 in
    "-v")
    echo ${VERSION}
    ;;
    "-env")
    clear
    ;;
    *)
    manageConfig
    ;;
 esac
}

# start application ==============================================
startup $1
# ================================================================
