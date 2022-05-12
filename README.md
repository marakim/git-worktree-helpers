# git-clone for git-worktree

Clone a git repository for use with
[git-worktree](https://www.git-scm.com/docs/git-worktree)


## Usage

### Bash

```bash
git-clone-for-worktree.sh [--single-branch] <repo> [<dir>]
```

### PowerShell

```powershell
git-clone-for-worktree.ps1 [-Repository] <string> [[-Directory] <string>] [-SingleBranch]
```

### Arguments

* **Repository**: The repository to clone from.
* **Directory**: The directory to clone into. By default the basename of the repository without extension.
* **SingleBranch**: Only fetch the main branch.


## Using Worktrees

You can clone a repository similar to using `git-clone` with:

```bash
git-clone-for-worktree git@github.com:my-project/my-repo.git
```

This creates a git repository in `my-repo` with a folder
containing one worktree tracking the primary branch (usually `main`).

Once you enter this worktree, you can use normal commands like `git checkout`
to checkout new and existing branches.

### Creating New Worktrees

If a pressing change requires a hotfix, you can create a new `hotfix` worktree in the repository root with:

```bash
git worktree add -b urgent-bugfix hotfix main
```

This creates a new `urgent-bugfix` branch in the new `hotfix` worktree
based off the `main` branch without disturbing your other worktrees.

For more information on worktrees, see the documentation for [git-worktree](https://git-scm.com/docs/git-worktree).


## Single Branch Clone

Projects with many contributors can have large numbers of branches.
Syncing every branch on these repositories takes a long time,
so it is useful to limit which branches to sync.

Common practice is to prefix branch names with your username.
To setup a repository to have `git pull` sync only the main branch and branches with the prefix `USERNAME/`:

```bash
git-clone-for-worktree --single-branch git@github.com:my-project/my-repo.git
cd my-repo
git config --add remote.origin.fetch '+refs/heads/USERNAME/*:refs/remotes/origin/USERNAME/*'
```

You can fetch and checkout other branches, for example `OTHERUSER/their-branch`, with:

```bash
git fetch origin OTHERUSER/their-branch:refs/remotes/origin/OTHERUSER/their-branch
git checkout origin/OTHERUSER/their-branch
```