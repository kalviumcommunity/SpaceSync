@echo off
set FLUTTER_PATH=D:\flutter\bin
set SYSTEM32_PATH=C:\Windows\System32
set PATH=%PATH%;%SYSTEM32_PATH%;%FLUTTER_PATH%
cd /d "d:\vscode\SpaceSync"
echo Running Flutter...
flutter.bat %*
