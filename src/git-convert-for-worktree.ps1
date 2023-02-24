Param (
    [Parameter(HelpMessage = "The git repo to convert")]
    [string]
    $Directory
)

${DirectoryExists} = Test-Path -Path "${Directory}/.git"
If (!${DirectoryExists}) {
    Write-Error "fatal: '${Directory}' not a git repo"
    Exit 1
}

$GitRepo = Resolve-Path "$Directory"
$CurrLocation = (Get-Location).Name
If ($GitRepo.Substring(0, $CurrLocation.Length) = = $CurrLocation) {
    Write-Error "fatal: Run this command from outside the repo"
    Exit 1
}

Move-Item "$GitRepo" -Destination "$GitRepo.old"
New-Item -Path . -Name "$GitRepo" -ItemType "directory"
Copy-Item "$GitRepo.old/.git" -Destination "$GitRepo"


Push-Location -Path "${Directory}"

git config --bool core.bare true
${DefaultBranch} = git rev-parse --abbrev-ref HEAD
git worktree add "${DefaultBranch}"

Pop-Location
