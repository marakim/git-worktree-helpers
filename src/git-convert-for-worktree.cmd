@echo off & setlocal

set scriptPath=%~dp0
set scriptName=git-convert-for-worktree.ps1

powershell.exe -file "%scriptPath%%scriptName%" %*