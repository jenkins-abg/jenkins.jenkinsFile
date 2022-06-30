function myGui

 % create the figure
 hFig = figure('Position',[0 0 400 200],'Visible','off');
 movegui(hFig,'center');
 set(hFig,'Tag','tformChoiceGui','HandleVisibility','on','Visible','on');
 
 % create the buttons
 hBtn1 = uicontrol(hFig,'Style','pushbutton','String','TForm 1',...
                   'Position',[30 110 100 30]);
                
 hBtn2 = uicontrol(hFig,'Style','pushbutton','String','TForm 2',...
                   'Position',[140 110 100 30]);
               
 hBtn3 = uicontrol(hFig,'Style','pushbutton','String','TForm 3',...
                   'Position',[250 110 100 30]);
                   
                   
                   function PU = testfun
H = figure;
uicontrol('Style',...
          'pushbutton',...
          'String',' 1 ',...
          'Position',[10 350 100 30],...
          'HandleVisibility','on',...
          'Callback', {@PushB, 1});
uicontrol('Style','pushbutton',...
          'String',' 2 ',...
          'Position',[10 150 100 30],...
          'HandleVisibility','on',...
          'Callback', {@PushB, 2});
set(H, 'UserData', 0);
uiwait(H);  % Let Matlab wait until UIRESUME is called
PU = get(H, 'UserData');
end
function PushB(ButtonH, ~, Num)  % Same callback for both buttons
H = ancestor(ButtonH, 'figure');
set(H, 'UserData', Num);
uiresume(H);
end
