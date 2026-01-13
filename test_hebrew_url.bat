@echo off
chcp 65001
echo Testing Hebrew URL...
echo Running with URL: otzaria://book/ברכות
"build\windows\x64\runner\Debug\otzaria.exe" "otzaria://book/ברכות"
pause