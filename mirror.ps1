# Powershell Script to mirror a Git repository

param(
    [Parameter(Mandatory=$true)]
    [string]$sourceRepo,

    [Parameter(Mandatory=$true)]
    [string]$destRepo,

    [Parameter(Mandatory=$true)]
    [string]$pat
)
# Encode the PAT for HTTP Basic Authentication
$B64Pat = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("`:$pat"))



# Clone the source repository with the --mirror option
Write-Host "Cloning the source repository..."
git clone --mirror $sourceRepo "tempRepo.git"


# Change to the newly created directory
Set-Location -Path "tempRepo.git"

Write-Host "Delete all refs/pull"
git for-each-ref --format '%(refname)' refs/pull | ForEach-Object { git update-ref -d $_ }

# Set the HTTP header for Git
git config http.extraheader "Authorization: Basic $B64Pat"

# Push to the destination repository with the --mirror option
Write-Host "Pushing to the destination repository..."
git push --mirror $destRepo


Write-Host "Successfully mirrored repositories."