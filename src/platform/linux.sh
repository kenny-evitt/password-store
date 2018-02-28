# This file is actually for Bash on Ubuntu on Windows!

clip() {
    echo "TODO: Clip!"
}

read_from_clipboard() {
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::GetText()"
}

fancy_read_from_clipboard() {
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; $data = [System.Windows.Forms.Clipboard]::GetDataObject(); "
}

write_to_clipboard() {
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::SetText(\"$1\")"
}

#read_from_clipboard   # Works!
write_to_clipboard "Ha ha ha ha ha"
