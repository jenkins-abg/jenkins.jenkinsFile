function myScript

fprintf('launching script...\n');

fprintf('launching GUI......\n');

myGui;
hGui = findobj('Tag','tformChoiceGui');
waitfor(hGui);

fprintf('continuing script..\n');