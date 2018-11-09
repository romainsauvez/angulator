# Angulator - Angular (2+) file generator

Bash script for generate angular 2+ files

![alt text](https://github.com/romainsauvez/angulator/blob/master/angulator1.PNG)


## Install 

Add the script in the root folder of your Angular Project, near the src folder.

##  Use

In the Terminal of your IDE or computer, just enter :

```bash
$ bash angulator.sh
```

##  Description

Generate angular(2+) files : 

- Module
  - Module only
  - Module full (compo/html/css/routing)
  
- Component
  - Component only
  - Component full (html/css)
  
- Service
  -Basic (angular 2/4/5)
  -Root (angular 6+) : use {providedIn: 'root'} in @Injectable
 
- Directive

- Custom FormControl 


## Options

Open the script in your text editor and modify : 

- PREFIX_FOR_SELECTOR : choose a custom prefix for the component selector(default:'')

- CSS_FILE_TYPE : choose the css file type : css, scss, sass...(default:css)



