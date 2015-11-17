#!/bin/bash

# BaTbot current version
VERSION="1.2"

# default token and chatid
# or run BaTbot with option: -t <token>
TELEGRAMTOKEN="<Your Bot Token>";

# how many seconds between check for new messages
# or run Batbot with option: -c <seconds>
CHECKNEWMSG=5;

# Commands
# you have to use this exactly syntax: ["/mycommand"]='<system command>'
declare -A botcommands
botcommands=(

	["/myid"]='echo Your user id is: @USERID'

	["/myuser"]='echo Your username is: @USERNAME'

	["/ping ([0-9]+)"]='echo Pong: @R1'

	["/hello"]='echo Hi @FIRSTNAME, pleased to meet you :)'

	["/auth ([a-zA-Z0-9\.\=]+)"]='/usr/local/bin/auth.sh @R1'

	["/w"]="uptime"

)

# + end config
# +
# +
# +

FIRSTTIME=0;
BOTPATH="`dirname \"$0\"`";

echo "+"
while getopts :ht:c: OPTION; do
	case $OPTION in
		h)
			echo " BaTbot: Bash Telegram Bot"
			echo "+"
			echo " Usage: ${0} [-t <token>]"
			exit;
		;;
		t)
			echo "Set Token to: ${OPTARG}";
			TELEGRAMTOKEN=$OPTARG;
		;;
		c)
			echo "Check for new messages every: ${OPTARG} seconds";
			CHECKNEWMSG=$OPTARG;
		;;
	esac
done
echo "+"

#curl -s "https://api.telegram.org/bot${TELEGRAMTOKEN}/getUpdates"
#exit


echo -e "\nInitializing BaTbot v${VERSION}"
ABOUTME=`curl -s "https://api.telegram.org/bot${TELEGRAMTOKEN}/getMe"`
if [[ "$ABOUTME" =~ \"ok\"\:true\, ]]; then
	if [[ "$ABOUTME" =~ \"username\"\:\"([^\"]+)\" ]]; then
		echo "Username: ${BASH_REMATCH[1]}";
	fi

	if [[ "$ABOUTME" =~ \"first_name\"\:\"([^\"]+)\" ]]; then
		echo "First name: ${BASH_REMATCH[1]}";
	fi

	if [[ "$ABOUTME" =~ \"id\"\:([0-9\-]+), ]]; then
		echo "Bot ID: ${BASH_REMATCH[1]}";
		BOTID=${BASH_REMATCH[1]};
	fi

else
	echo "Error: maybe wrong token... exit.";
	exit;
fi

if [ -e "${BOTPATH}/${BOTID}.lastmsg" ]; then
	FIRSTTIME=0;
else
	touch ${BOTPATH}/${BOTID}.lastmsg;
	FIRSTTIME=1;
fi

echo -e "Done. Waiting for new messages...\n"

while true; do
	MSGOUTPUT=$(curl -s "https://api.telegram.org/bot${TELEGRAMTOKEN}/getUpdates");
	MSGID=0;
	TEXT=0;
	FIRSTNAME="";
	LASTNAME="";
	echo "${MSGOUTPUT}" | while read -r line ; do
		if [[ "$line" =~ \"chat\"\:\{\"id\"\:([\-0-9]+)\, ]]; then
			CHATID=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ \"message\_id\"\:([0-9]+)\, ]]; then
			MSGID=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ \"text\"\:\"(.+)\"\}\} ]]; then
			TEXT=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ \"username\"\:\"([^\"]+)\" ]]; then
			USERNAME=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ \"first_name\"\:\"([^\"]+)\" ]]; then
			FIRSTNAME=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ \"last_name\"\:\"([^\"]+)\" ]]; then
			LASTNAME=${BASH_REMATCH[1]};
		fi

		if [[ "$line" =~ \"from\"\:\{\"id\"\:([0-9\-]+), ]]; then
			FROMID=" ${BASH_REMATCH[1]}";
		fi


		if [[ $MSGID -ne 0 && $CHATID -ne 0 ]]; then
			LASTMSGID=$(cat "${BOTID}.lastmsg");
			if [[ $MSGID -gt $LASTMSGID ]]; then
				echo "[chat ${CHATID}, from ${FROMID}] <${USERNAME} - ${FIRSTNAME} ${LASTNAME}> ${TEXT}";
				echo $MSGID > "${BOTID}.lastmsg";

				for s in "${!botcommands[@]}"; do
					if [[ "$TEXT" =~ \\${s} ]]; then
						CMDORIG=${botcommands["$s"]};
						CMDORIG=${CMDORIG//@USERID/$FROMID};
						CMDORIG=${CMDORIG//@USERNAME/$USERNAME};
						CMDORIG=${CMDORIG//@FIRSTNAME/$FIRSTNAME};
						CMDORIG=${CMDORIG//@R1/${BASH_REMATCH[1]}};

						echo "Command ${s} received, running cmd: ${CMDORIG}"
						CMDOUTPUT=`$CMDORIG`;

						if [ $FIRSTTIME -eq 1 ]; then
							echo "old message, i will not send any answer to user.";
						else
							curl -s -d "text=${CMDOUTPUT}&chat_id=${CHATID}" "https://api.telegram.org/bot${TELEGRAMTOKEN}/sendMessage" > /dev/null
						fi
					fi
				done
			fi
		fi
	done

	FIRSTTIME=0;

	read -t $CHECKNEWMSG answer;
	if [[ "$answer" =~ ^\.msg.([\-0-9]+).(.*) ]]; then
		CHATID=${BASH_REMATCH[1]};
		MSGSEND=${BASH_REMATCH[2]};
		curl -s -d "text=${MSGSEND}&chat_id=${CHATID}" "https://api.telegram.org/bot${TELEGRAMTOKEN}/sendMessage" > /dev/null;
	elif [[ "$answer" =~ ^\.msg.([a-zA-Z]+).(.*) ]]; then
		CHATID=${BASH_REMATCH[1]};
		MSGSEND=${BASH_REMATCH[2]};
		curl -s -d "text=${MSGSEND}&chat_id=@${CHATID}" "https://api.telegram.org/bot${TELEGRAMTOKEN}/sendMessage" > /dev/null;
	fi

done

exit 0
