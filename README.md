## Step to create virtualenv for local
``` shell 
python3 -m venv robot_venv 
```
``` shell 
source robot_venv/bin/activate
```
``` shell 
pip3 install -r requirements.txt
```
#### Clean old browser binaries and node dependencies
``` shell 
rfbrowser clean-node
```
#### Initialize the Browser library with new node dependencies
``` shell 
rfbrowser init
```

``` shell 
pip3 list
```

#### Script run
``` shell 
robot test.robot
```

#### Browser with this engine
- chromium	Google Chrome, Microsoft Edge (since 2020), Opera
- firefox	Mozilla Firefox
- webkit	Apple Safari, Mail, AppStore on MacOS and iOS