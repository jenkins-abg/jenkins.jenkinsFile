@echo off
(
   for %%a in ( c d e f g h) do (
      if exist "%%a:\" dir "%%a:\Apollo.exe" /b /s /a-d
   )
)>"C:\Temp\list.txt"
set /P Variable=<"C:\Temp\list.txt"
