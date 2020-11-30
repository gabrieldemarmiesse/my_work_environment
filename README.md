Windows terminal changes:

```
"copyOnSelect": false,

...
{ 
    "command": "copy", 
    "keys": ["ctrl+c"] 
},
{ 
    "command": "paste", 
    "keys": ["ctrl+v"]
},


        {
            "acrylicOpacity" : 0.5,
            "closeOnExit" : true,
            "colorScheme" : "Campbell",
            "commandline" : "wsl.exe -d Ubuntu-18.04 --user root -- bash /projects/open_source/my_work_environment/get_in_env.sh",
            "cursorColor" : "#FFFFFF",
            "cursorShape" : "bar",
            "fontFace" : "Delugia Nerd Font",
            "fontSize" : 10,
            "guid" : "{c6eaa9f4-32a7-5fdc-b5cf-066e8a4b1e40}",
            "backgroundImage": "C:/Users/yolo/Pictures/terminal_background.jpg",
            "backgroundImageOpacity" : 0.87,
            "historySize" : 9001,
            "icon" : "ms-appx:///ProfileIcons/{9acb9455-ca41-5af7-950f-6bca1bc9722f}.png",
            "name" : "Docker work env",
            "padding" : "0, 0, 0, 0",
            "snapOnInput" : true,
            "useAcrylic" : false,
            "startingDirectory": "C:/Users/yolo/Desktop/projects/"
        },


```


```
# cat /etc/wsl.conf
[user]
default=root
```


