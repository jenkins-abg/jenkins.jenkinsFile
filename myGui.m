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