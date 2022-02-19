# git-clone for git-worktree

Clone a git repository for use with
[git-worktree](https://www.git-scm.com/docs/git-worktree)


## Usage

```powershell
git-clone-for-worktree [-Repository] <string> [[-Directory] <string>] [-SingleBranch]
```

### Arguments

* **Repository**: The repository to clone from.
* **Directory**: The directory to clone into. By default the basename of the repository without extension.
* **SingleBranch**: Only fetch the main branch.


## Examples

### Single Branch with Topics

Projects with many contributors can have a large number of branches.
In these cases, it is common to prefix branch names with your username.
Sync times on these repositories can be improved by cloning in single branch mode
and specifying explicit topic branches to sync.

To setup a repository to have `git pull` sync only the main branch and branches with the prefix `USERNAME/`:

```powershell
git-clone-for-worktree -SingleBranch git@github.com:my-project/my-repo.git
cd my-repo
git config --add remote.origin.fetch '+refs/heads/USERNAME/*:refs/remotes/origin/USERNAME/*'
```

You can still fetch individual branches, for example `OTHERUSER/their-branch`, with:

```powershell
git fetch origin OTHERUSER/their-branch:refs/remotes/origin/OTHERUSER/their-branch
```