# BaTbot v1.2 - Bash Telegram Bot

batbot.sh is a simple Telegram Bot written in Bash
that can reply to user messages, execute commands, 
and others cool features.

<img src="https://waf.blue/img/bat.gif" width="100" />

## Index
- [Usage](#usage)
- [Simple Commands](#simple-commands)
- [Variables](#variables)
- [Commands with regex](#command-with-regex)
- [Send Message](#send-message)
- [TODO](#todo)

## Usage
```
./botbat.sh [-t "<token>"] [-c <seconds>]

./botbat.sh -h
```
- `-t  ` Set Telegram Bot Token (see https://core.telegram.org/bots/api)
- `-c  ` Check for new messages every (n) seconds

## Simple Commands
inside the script botbat.sh you will find a list of example commands
that you can configure. For Example:
```
	["/hello"]="echo Hi"
```
this command trigger the /hello message from a user, 
execute the system command **echo Hi** and return the 
command output to the user via message.

Do you want to know your server uptime? no problem:
```
	["/uptime"]="/usr/bin/uptime" 
```

Free disk space via Telegram? let's do it:
```
	["/disks"]="/bin/df -h"
```

Execute external script:
```
	["/auth ([a-zA-Z0-9]+)"]="/usr/local/bin/auth.sh @R1"
```

**Don't try this at home**:
```
	["/exec (.*)"]="exec @R1"
```


## Variables
You can use variables! for example:
```
	["/hello"]="echo Hi @FIRSTNAME, pleased to meet you :)"
```

BaTbot show in console, and in real time, all received messages: 
```
+
Set Token to: ****
Check for new messages every: 3 seconds
+

Initializing BaTbot v1.2
Username: wafblue_bot
First name: wafblue
Bot ID: ****
Done. Waiting for new messages...

[chat **, from  **] <theMiddle - Andrea Menin> \/hello
Command /hello received, running cmd: echo Hi Andrea, pleased to meet you :)
```

### Varibales List
```
@USERID 	(int) ID of user who sent the triggered command
@USERNAME 	(string) Telegram Username of user
@FIRSTNAME	(string) The first name of user
@LASTNAME	(string) The last name of user
@CHATID 	(int) The chat ID where user sent a command
@MSGID 		(int) ID of message that triggered a command
@TEXT		(string) The full text of a received message
@FROMID		(int) ID of user that sent a message

Regex group extract
@R1 		Content of first group (.*)
@R2 		Content of second group (.*)
@R3 		Content of third group (.*)
```
![screenshot](https://waf.blue/img/batbot_sc1.jpg)

### Command with regex
You can also configure a command with arguments, 
for example: "/ping 1234". All arguments can be 
regular expressions, For example:
```
	["/ping ([0-9]+)"]="echo Pong: @R1"

	["/blacklist ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)"]="/sbin/iptables -A INPUT -s @R1 -j DROP"

	["/whois ([a-zA-Z0-9\.\-]+)"]="/usr/bin/whois @R1"

	["/host ([a-zA-Z0-9\.\-]+)"]="/usr/bin/host @R1"
```
![screenshot](https://waf.blue/img/batbot_sc2.jpg)

## Send message
When BaTbot is running, you can send message to chat id, by use the command **.msg** directly on console.
For example:
```
[chat 110440209, from  110440209] <theMiddle - Andrea Menin> hi bot :)
.msg 110440209 hey!!!
```
![screenshot](https://waf.blue/img/batbot_sc3.png)

## TODO
- 2015-11-17 `[high  ]` Dynamic Regular Expression Group extraction
