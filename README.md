# Angulator - Angular (2+) file generator

Bash script for generate angular(2+) files

![alt text](https://github.com/romainsauvez/angulator/blob/master/angulator1.png)
![alt text](https://github.com/romainsauvez/angulator/blob/master/angulator3.png)
![alt text](https://github.com/romainsauvez/angulator/blob/master/angulator2.png)

## Install 

Add the script in the root folder of your Angular Project, near the src folder
1
##  Use

In the Terminal of your IDE or computer, just enter :

```bash
$ bash angulator.sh
```

##  Description

Generate angular(2+) files : 

- Module
  - Basic (module, component, html, css)
  - Basic with service
  - Basic with routing
  - Global (basic, service, routing)
  - Module + component only
  
- Component
  - Basic (component, html, css)
  - Basic with service
  - Component only
  
- Service (basic)

- Directive (basic)


## Options

Open the script in your text editor and modify : 

- PREFIX_FOR_SELECTOR : choose a custom prefix for the component selector(default:'')

- CSS_FILE_TYPE : choose the css file type : css, scss, sass...(default:css)


## Next

  - add broadcaster file for event
  - add basic route guard
  - add basic master/detail module
  - add more complete routing
  
