# kill WSL if it's running
$terminalProcess = (Get-Process -ErrorAction SilentlyContinue | where {$_.Description -like 'Terminal'})
if($terminalProcess){
  Write-Output "[Killed] WSL before backup starts"
  $terminalProcess.closeMainWindow() | out-null
  Start-Sleep -s 2
}

# backup the current default (it's assuming it's Ubuntu bionic for now)
Write-Output "[Backup] Starting"
lxrunoffline e -n Ubuntu-bionic -f "D:\Backups\VMs\Systems\Ubuntu-18.04-bionic_$(get-date -f yyyyMMddHHmmss).tar.gz"
Write-Output "[Backup] Complete"
pause