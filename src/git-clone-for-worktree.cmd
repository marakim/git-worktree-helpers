@echo off & setlocal

set scriptPath=%~dp0
set scriptName=git-clone-for-worktree.ps1

powershell.exe -file "%scriptPath%%scriptName%" %*