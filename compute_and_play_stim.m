function  compute_and_play_stim()
    global BpodSystem;
    
%     % for dots
%     display = BpodSystem.Data.Custom.display;
%     dots = BpodSystem.Data.Custom.dots;
%     curr_trial = BpodSystem.Data.Custom.iTrial;
%     % draw dots, note: this does not flip the screen
%     draw_dots(display,dots)
% 
%     %update the dot position
%     [dots.x,dots.y] = move_dots(dots.x,dots.y,dots.dx(curr_trial,:),dots.dy(curr_trial,:));
% 
%     % Deal with dots that move offscreen
%     [dots.x,dots.y] = compute_aperture(dots.x,dots.y,dots.center,dots.apertureSize);
% 
%     % Deal with dots that have died
%     [dots.x, dots.y, dots.life] = compute_life(dots);
% 
%     % flip the screen
%     display.vbl = Screen('Flip', display.windowPtr, display.vbl + (display.waitframes + 1.0) * display.ifi);
% 
%     BpodSystem.Data.Custom.display = display;
%     BpodSystem.Data.Custom.dots = dots;

    % for dots
    %BpodSystem.Data.Custom.display;
    %dots = BpodSystem.Data.Custom.dots;

    curr_trial = BpodSystem.Data.Custom.iTrial;
  
    % draw dots, note: this does not flip the screen
    dots = BpodSystem.Data.Custom.dots{curr_trial};
    draw_dots(BpodSystem.Data.Custom.display, dots);
 

    %update the dot position
    [dots.x, dots.y] = move_dots(dots.x, dots.y, dots.dx, dots.dy);

    % Deal with dots that move offscreen
    [dots.x, dots.y] = compute_aperture(dots.x, dots.y, dots.center, dots.apertureSize);

    % Deal with dots that have died
    [dots.x, dots.y, dots.life] = compute_life(dots);
    
    BpodSystem.Data.Custom.dots{curr_trial} = dots;
 
  
    % flip the screen
    % for dots
    
    %display fps is 60 but we are presenting stimuli at 30. waitframes
    %should be .5*ifi but now it's 1*ifi because the ifi is already half
    %waht we want
    BpodSystem.Data.Custom.display.vbl = Screen('Flip', ...
                                                BpodSystem.Data.Custom.display.windowPtr, ...
                                                BpodSystem.Data.Custom.display.vbl + (BpodSystem.Data.Custom.display.waitframes) * BpodSystem.Data.Custom.display.ifi);

                                           
    %BpodSystem.Data.Custom.display = display;
    %BpodSystem.Data.Custom.dots = dots;
                
end