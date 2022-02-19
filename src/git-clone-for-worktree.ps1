Param (
    [Parameter(Mandatory, HelpMessage = "The repository to clone from")]
    [string]
    $Repository,

    [Parameter(HelpMessage = "The directory to clone into")]
    [string]
    $Directory,

    [switch]
    $SingleBranch
)

If (${Directory} -eq [string]::Empty) {
    # HOPE: PS v7
    # ${Directory} = Split-Path -LeafBase -Path "${Repository}"
    ${Directory} = (Split-Path -Leaf -Path "${Repository}") -replace '\..*'
}


${DirectoryExists} = Test-Path -Path "${Directory}"

If ($SingleBranch) {
    git clone --single-branch --bare "${Repository}" "${Directory}/.git"
}
Else {
    git clone --bare "${Repository}" "${Directory}/.git"
}

If (-not $?) {
    If (!${DirectoryExists}) {
        Remove-Item ${Directory}
    }
    Exit 1
}


Push-Location -Path "${Directory}"

${DefaultBranch} = git rev-parse --abbrev-ref HEAD

If ($SingleBranch) {
    git config --add remote.origin.fetch "+refs/heads/${DefaultBranch}:refs/remotes/origin/${DefaultBranch}"
}
Else {
    git config --add remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
}

git worktree add "${DefaultBranch}"

Pop-Location
