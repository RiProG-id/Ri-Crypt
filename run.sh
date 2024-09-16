#!/bin/bash

echo "WARNING: This encryption does not support shells that require input reading mechanisms such as 'read'."
echo ""

commands=("base64" "od" "tr" "strip" "rustc" "cargo")
missing=""

for cmd in "${commands[@]}"; do
	if ! command -v "$cmd" &>/dev/null; then
		missing+="'$cmd' not found. "
	fi
done

if [ -n "$missing" ]; then
	echo "Some required commands are missing:"
	echo "$missing"
	echo "Please run 'setup.sh' to install the missing packages."
	exit 1
else
	echo "All required commands are installed."
fi

ulimit -s unlimited >/dev/null 2>&1

echo ""
echo "Ri-Crypt 2.0 by Github: RiProG-id"
echo ""
echo "Example:"
echo "/sdcard/in/example.sh"
printf "Enter the file location: "
read -r input

if [ -f "$input" ]; then
	interpreter=$(awk 'NR==1 && /^#!/ {gsub(".*/","",$1); print $1}' "$input")
	if [[ "$interpreter" == "bash" || "$interpreter" == "sh" ]]; then
		echo "Interpreter found: $interpreter"
	else
		echo "No bash or sh interpreter found."
		exit 1
	fi

	basename=$(basename -- "$input")
	basename_no_ext="${basename%.*}"
	dirname=$(dirname -- "$input")
	basefile="$dirname/$basename_no_ext.base"
	xorfile="$dirname/$basename_no_ext.xor"
	rustfile="$dirname/$basename_no_ext.rs"
	binfile="$dirname/$basename_no_ext"

	echo "Encoding file content in Base64..."
	printf "eval 'echo \"" >$basefile
	printf "$(cat $input | base64 -w 0)" >>$basefile
	printf "\" | base64 -d | $interpreter'" >>$basefile
	echo "Base64 encoding completed and saved to $basefile."

	echo "Reading the encoded file..."
	command=$(cat "$basefile")
	command_length=${#command}
	echo "File read successfully. Length of the command: $command_length characters."

	echo "Generating a random key..."
	key=$(od -An -N1 -tx1 /dev/urandom | tr -d ' ')
	echo "Key generated: 0x$key"

	echo "Encrypting the command..."
	encrypted=""
	for ((i = 0; i < command_length; i++)); do
		ascii=$(printf "%d" "'${command:$i:1}")
		encrypted_byte=$(printf "%02x" $((ascii ^ 0x$key)))
		encrypted+="$encrypted_byte "
	done
	echo "Command encryption completed."

	echo "Writing encrypted data to $xorfile..."
	{
		echo "let key: u8 = 0x$key;"
		encrypted_command_formatted=$(printf "0x%s, " $encrypted | sed 's/, $//')
		echo "let encrypted_command: [u8; $command_length] = [$encrypted_command_formatted];"
	} >"$xorfile"
	echo "Encrypted data saved to $xorfile."

	echo "Generating Rust code in $rustfile..."
	{
		echo 'use std::process::Command;'
		echo ''
		echo 'fn decrypt_command(encrypted: &[u8], key: u8) -> String {'
		echo '    encrypted.iter().map(|&b| (b ^ key) as char).collect()'
		echo '}'
		echo ''
		echo 'fn main() {'
		cat "$xorfile"
		echo '    let decrypted_command = decrypt_command(&encrypted_command, key);'
		echo '    let output = Command::new("sh")'
		echo '        .arg("-c")'
		echo '        .arg(decrypted_command)'
		echo '        .output()'
		echo '        .expect("Failed to execute shell command");'
		echo ''
		echo '    if !output.stdout.is_empty() {'
		echo '        println!("{}", String::from_utf8_lossy(&output.stdout));'
		echo '    }'
		echo '    if !output.stderr.is_empty() {'
		echo '        eprintln!("{}", String::from_utf8_lossy(&output.stderr));'
		echo '    }'
		echo '}'
	} >"$rustfile"
	echo "Rust code saved to $rustfile."

	echo "Formatting Rust code..."
	rustfmt "$rustfile"
	echo "Rust code formatted."

	echo "Compiling Rust code to $binfile..."
	rustc -C opt-level=3 "$rustfile" -o "$binfile"
	echo "Rust code compiled to $binfile."

	echo "Stripping binary..."
	strip "$binfile"
	echo "Binary stripped successfully."

	echo "Removing temporary files..."
	rm "$basefile" "$xorfile" "$rustfile"
	echo "Temporary files removed successfully."
else
	echo "File does not exist."
	exit 1
fi
