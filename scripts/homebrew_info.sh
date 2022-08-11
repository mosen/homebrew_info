#!/bin/sh
# Made by tuxudo

# homebrew_info

# Skip manual check
if [ "$1" = 'manualcheck' ]; then
	echo 'Manual check: skipping'
	exit 0
fi

# Check if homebrew is installed
CURRENTUSER=$(echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }')

if [[ $CURRENTUSER != "" ]]; then
    brew=$(sudo -i -u $CURRENTUSER command -v brew)

    if [[ $? = 1 ]] && [[ -f "/usr/local/bin/brew" ]] ; then
        # If Intel Mac
        brew="/usr/local/bin/brew"
    elif [[ $? = 1 ]] && [[ -f "/opt/homebrew/bin/brew" ]] ; then
        # Else if Apple Silicon Mac
        brew="/opt/homebrew/bin/brew"
    fi
else
    if [[ -f "/usr/local/bin/brew" ]] ; then
        # If Intel Mac
        brew="/usr/local/bin/brew"
    elif [[ -f "/opt/homebrew/bin/brew" ]] ; then
        # Else if Apple Silicon Mac
        brew="/opt/homebrew/bin/brew"
    fi
fi



if [[ -f $brew ]]; then

    # The sudo is needed to escape brew.sh's UID of 0 check
    BREWCONFIG='[{"'
    BREWCONFIG="$BREWCONFIG$(cd /; sudo -HE -u nobody $brew config | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/", "/g' -e 's/: /": "/g')"
    BREWCONFIG="$BREWCONFIG\"}]"

    homebrewfile="$DIR/cache/homebrew_info.json"
    echo "${BREWCONFIG}" > "${homebrewfile}"

else
    echo "Homebrew is not installed, skipping"
fi
exit 0
