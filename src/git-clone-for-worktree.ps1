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


If (!(Test-Path -Path "${Directory}")) {
    New-Item -ItemType Directory -Path "${Directory}"
}
Elseif (Test-Path -Path "${Directory}") {
    If (!((Get-ChildItem -Path "${Directory}" | Select-Object -First 1 | Measure-Object).Count -eq 0)) {
        Write-Error -Message "fatal: destination path '${Directory}' already exists and is not an empty directory."
        Exit 1
    }
}
Else {
    Write-Error -Message "fatal: destination path '${Directory}' is not a directory."
    Exit 1
}


Push-Location -Path "${Directory}"

Try {
    If ($SingleBranch) {
        git clone --single-branch --bare "${Repository}" .git
    }
    Else {
        git clone --bare "${Repository}" .git
    }

    ${DefaultBranch} = git rev-parse --abbrev-ref HEAD

    If ($SingleBranch) {
        git config --add remote.origin.fetch "+refs/heads/${DefaultBranch}:refs/remotes/origin/${DefaultBranch}"
    }
    Else {
        git config --add remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    }
    git worktree add "${DefaultBranch}"
}
Finally {
    Pop-Location
}
