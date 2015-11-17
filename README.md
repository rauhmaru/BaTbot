# BaTbot v1.2 - Bash Telegram Bot

batbot.sh is a simple Telegram Bot written in Bash
that can reply to user messages, execute commands, 
and others cool features.

## Index
- Usage
- Simple Commands
- Variables
- Commands with arguments
- Commands with regex
- Send Message
- TODO

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
execute the system command *echo Hi* and return the 
command output to the user via message.

## Variables
You can use variables! for example:
```
	["/hello"]="echo Hi @FIRSTNAME, please to meet you :)"
```
![screenshot](https://waf.blue/img/batbot_sc1.jpg)

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
Command /hello received, running cmd: echo Hi Andrea, please to meet you :)
```
