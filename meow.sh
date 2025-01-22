#!/bin/bash
# meow: curiosity

# check dependencies: python3/pip, rich, & bat
check_bash_dependency() {
	command -v "$1" &>/dev/null || {
		echo "dependency $1 is missing, installing ..."
		sudo dnf install -y "$1"
	}
}

check_bash_dependency pip3
check_bash_dependency bat

# rich import
python3 - <<EOF
from rich.console import Console
console = Console()
console.print("[cyan]\nmeow 0.1\n[/]")
EOF

# Filename check
if [[ -z $1 ]]; then
	echo "to err is to meow: meow needs a target argument: $0 <ur_file>"
	exit 1
fi

# Assign arg to var
filename="$1"

# Check if the file exists
if [[ ! -f $filename ]]; then
	echo "to err is to meow: '$filename' was not found"
	exit 1
fi

# Display file
batcat --paging=never $filename

# Await carriage return
python3 - <<EOF
from rich.console import Console
console = Console()
console.print("[cyan]\n<return> or <v> to open in vim\n\n<backspace> or <q> to close meow\n[/]")
EOF
while true; do
	# read a single char (-n 1)
	read -n 1 -r -s key 
	if [[ $key == $'\x7f' || $key == "q" ]]; then
		exit 0
	elif [[ -z $key || $key == "v" ]]; then
		vim "$filename"
		break
	else 
		echo -e "\nu hit neither ! enter to vim \"$filename\", backspace to cancel"
	fi
done
exit

