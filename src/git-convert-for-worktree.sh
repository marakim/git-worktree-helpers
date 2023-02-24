GitRepo=$1

Directory="$(realpath "${GitRepo}")"

DirectoryExists="$(test -d "${Directory}.git"; echo $?)"
if [ $DirectoryExists -eq 1 ]
then
    echo "fatal: '${Directory}' not a git repo"
fi

if [ "${Directory:0:${#CWD}}" -eq "${CWD}" ]
then
    echo "fatal: Run this command from outside the repo"
fi

mv "$Directory" "$Directory.old"
mkdir "$Directory"
cp "$Directory.old/.git" "$Directory"
echo "Old repo saved in $CWD/$Directory.old"
echo "  This may be removed safely"

pushd "$Directory"
git config --bool core.bare true
DefaultBranch="$(git rev-parse --abbrev-ref HEAD)"
git worktree add "$DefaultBranch"
popd
