# By default there are remote assistance tasks in task scheduler this script is intended to remove them. 
# Get all scheduled tasks under the "Windows" folder that contain "RemoteAssistance"
$tasks = Get-ScheduledTask -TaskPath "\Microsoft\Windows\RemoteAssistance\" -ErrorAction SilentlyContinue

# Check if any tasks exist
if ($tasks) {
    # Disable and delete each task
    foreach ($task in $tasks) {
        Write-Host "Removing task: $($task.TaskName)"
        Disable-ScheduledTask -TaskName $task.TaskName -TaskPath "\Microsoft\Windows\RemoteAssistance\"
        Unregister-ScheduledTask -TaskName $task.TaskName -TaskPath "\Microsoft\Windows\RemoteAssistance\" -Confirm:$false
    }
    Write-Host "All Remote Assistance tasks removed."
} else {
    Write-Host "No Remote Assistance tasks found."
}
