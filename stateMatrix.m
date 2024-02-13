function sma = stateMatrix(iTrial)
global BpodSystem
global TaskParameters

%% Define ports
LeftPort = floor(mod(TaskParameters.GUI.Ports_LMR/100,10));
CenterPort = floor(mod(TaskParameters.GUI.Ports_LMR/10,10));
RightPort = mod(TaskParameters.GUI.Ports_LMR,10);
LeftPortOut = strcat('Port',num2str(LeftPort),'Out');
CenterPortOut = strcat('Port',num2str(CenterPort),'Out');
RightPortOut = strcat('Port',num2str(RightPort),'Out');
LeftPortIn = strcat('Port',num2str(LeftPort),'In');
CenterPortIn = strcat('Port',num2str(CenterPort),'In');
RightPortIn = strcat('Port',num2str(RightPort),'In');



%% Define ports
BLeftPort = floor(mod(TaskParameters.GUI.Ports_BLMR/100,10));
BCenterPort = floor(mod(TaskParameters.GUI.Ports_BLMR/10,10));
BRightPort = mod(TaskParameters.GUI.Ports_BLMR,10);

BLeftPortOut = strcat('Port',num2str(BLeftPort),'Out');
BCenterPortOut = strcat('Port',num2str(BCenterPort),'Out');
BRightPortOut = strcat('Port',num2str(BRightPort),'Out');
BLeftPortIn = strcat('Port',num2str(BLeftPort),'In');
BCenterPortIn = strcat('Port',num2str(BCenterPort),'In');
BRightPortIn = strcat('Port',num2str(BRightPort),'In');


%reward ports and amount
BLeftValve = 2^(BLeftPort-1);
BRightValve = 2^(BRightPort-1);
BCenterValve = 2^(BCenterPort-1);

%make GUI
bleft_amount = TaskParameters.GUI.BL_ra;
bcenter_amount = TaskParameters.GUI.BC_ra;
bright_amount = TaskParameters.GUI.BR_ra;

BLeftValveTime  = GetValveTimes(bleft_amount, BLeftPort);
BRightValveTime  = GetValveTimes(bright_amount, BRightPort);
BCenterValveTime  = GetValveTimes(bcenter_amount, BRightPort);

%port LEDs
if TaskParameters.GUI.PortLEDs
    PortLEDs = 255;
else
    PortLEDs = 0;
end

if BpodSystem.Data.Custom.AuditoryTrial(iTrial) %auditory trial
    LeftRewarded = BpodSystem.Data.Custom.LeftRewarded(iTrial);
else %olfactory trial
    LeftRewarded = BpodSystem.Data.Custom.OdorID(iTrial) == 1;
end

if LeftRewarded == 1
    LeftPokeAction1 = 'Rewarded_Bin_Wait1';
    RightPokeAction1 = 'unRewarded_Bin_Wait1';
    LeftPokeAction2 = 'Rewarded_Bin_Wait2';
    RightPokeAction2 = 'unRewarded_Bin_Wait2';
    LeftPokeAction3 = 'Rewarded_Bin_Wait3';
    RightPokeAction3 = 'unRewarded_Bin_Wait3';
elseif LeftRewarded == 0
    LeftPokeAction1 = 'unRewarded_Bin_Wait1';
    RightPokeAction1 = 'Rewarded_Bin_Wait1';
    LeftPokeAction2 = 'unRewarded_Bin_Wait2';
    RightPokeAction2 = 'Rewarded_Bin_Wait2';
    LeftPokeAction3 = 'unRewarded_Bin_Wait3';
    RightPokeAction3 = 'Rewarded_Bin_Wait3';
else
    error('Bpod:Olf2AFC:unknownStim','Undefined stimulus');
end


FlipBlankScreen = 26;
FlipTimeoutScreen = 25;
PlayStim = 24;

%no catch trials, just one timer for feedback needed AC - 12/10

%if TaskParameters.GUI.CatchError
 %   FeedbackDelayError = 20;
%else
%    FeedbackDelayError = TaskParameters.GUI.FeedbackDelay;
%end






sma = NewStateMatrix();
sma = SetGlobalTimer(sma,1,TaskParameters.GUI.FeedbackDelay1);
sma = SetGlobalTimer(sma,2,TaskParameters.GUI.MinSample);
sma = SetGlobalTimer(sma,3,TaskParameters.GUI.StimDelay);
sma = SetGlobalTimer(sma,4,TaskParameters.GUI.FeedbackDelay2);
sma = SetGlobalTimer(sma,5,TaskParameters.GUI.FeedbackDelay3);

sma = AddState(sma, 'Name', 'preITI',...
    'Timer', TaskParameters.GUI.PreITI,...
    'StateChangeConditions', {'Tup','wait_Cin'},...
    'OutputActions',{'SoftCode', FlipBlankScreen});
sma = AddState(sma, 'Name', 'wait_Cin',...
    'Timer', TaskParameters.GUI.CenterWaitMax,...
    'StateChangeConditions', {CenterPortIn, 'stay_Cin','Tup','ITI'},...
    'OutputActions', {'SoftCode', FlipBlankScreen, strcat('PWM',num2str(CenterPort)),PortLEDs});

sma = AddState(sma, 'Name', 'broke_fixation',...
    'Timer',0.01,...
    'StateChangeConditions',{'Tup','timeOut_BrokeFixation'},...
    'OutputActions',{'SoftCode',FlipBlankScreen});

sma = AddState(sma, 'Name', 'start_Cin',...
    'Timer',0.001,...
    'StateChangeConditions', {CenterPortOut,'Cin_grace','Tup', 'stay_Cin'},...
    'OutputActions',{'GlobalTimerTrig',3});

sma = AddState(sma, 'Name', 'stay_Cin',...
    'Timer', TaskParameters.GUI.StimDelay,...
    'StateChangeConditions', {CenterPortOut,'Cin_grace','Tup', 'stimulus_delivery_trigger', 'GlobalTimer3_End', 'stimulus_delivery_trigger'},...
    'OutputActions',{ 'WireState', 1});

if TaskParameters.GUI.TimeOutBrokeFixation > 0
        sma = AddState(sma, 'Name', 'Cin_grace',...
        'Timer', 0.3,...
        'StateChangeConditions', {CenterPortIn,'stay_Cin','Tup', 'broke_fixation','GlobalTimer3_End', 'stimulus_delivery_trigger'},...
        'OutputActions',{strcat('PWM',num2str(CenterPort)),50});
else
    sma = AddState(sma, 'Name', 'Cin_grace',...
        'Timer', 0.3,...
        'StateChangeConditions', {CenterPortIn,'stay_Cin','Tup', 'wait_Cin','GlobalTimer3_End', 'stimulus_delivery_trigger'},...
        'OutputActions',{strcat('PWM',num2str(CenterPort)),50});
end

sma = AddState(sma, 'Name', 'stimulus_delivery_trigger',...
    'Timer', 0.001,...
    'StateChangeConditions', {CenterPortOut,'stim_delivery_grace','Tup','stimulus_delivery_1'},...
    'OutputActions', {'GlobalTimerTrig',2 });%play stim

sma = AddState(sma, 'Name', 'stimulus_delivery_1',...
    'Timer', .001,...
    'StateChangeConditions', {CenterPortOut,'stim_delivery_grace','Tup','stimulus_delivery_2', 'GlobalTimer2_End','wait_Sin'},...
    'OutputActions', {'SoftCode',PlayStim});

 sma = AddState(sma, 'Name', 'stimulus_delivery_2',...
    'Timer', 0.1,...
    'StateChangeConditions', {CenterPortOut,'stim_delivery_grace','SoftCode2','stimulus_delivery_1', 'GlobalTimer2_End','wait_Sin', 'Tup','stimulus_delivery_error'},...
    'OutputActions', {});

sma = AddState(sma, 'Name', 'stimulus_delivery_error',...
    'Timer', .001,...
    'StateChangeConditions', {'Tup', 'exit'},...
    'OutputActions',{'SoftCode', FlipTimeoutScreen});
    
if TaskParameters.GUI.TimeOutEarlyWithdrawal > 0 % if there is a timeout for early withdrawal then go to the early withdrawal sta
        sma = AddState(sma, 'Name', 'stim_delivery_grace',...
        'Timer', .1,...
        'StateChangeConditions', {CenterPortIn,'stimulus_delivery_1','Tup','early_withdrawal', 'GlobalTimer2_End','wait_Sin'},...
        'OutputActions', {'SoftCode', FlipBlankScreen, strcat('PWM',num2str(CenterPort)),PortLEDs/2});
else
    sma = AddState(sma, 'Name', 'stim_delivery_grace',...%otherwise just go back to wait_cin
        'Timer', .1,...
        'StateChangeConditions', {CenterPortIn,'stimulus_delivery_1','Tup','wait_Cin', 'GlobalTimer2_End','wait_Sin'},...
        'OutputActions', {'SoftCode', FlipBlankScreen, strcat('PWM',num2str(CenterPort)),PortLEDs/2});
end
  

sma = AddState(sma, 'Name', 'early_withdrawal',...
    'Timer', 0.01, ...
    'StateChangeConditions',{'Tup', 'timeOut_EarlyWithdrawal'},...
    'OutputActions',{'SoftCode',FlipTimeoutScreen});%stop stim   


if TaskParameters.GUI.finite_play
    sma = AddState(sma, 'Name', 'wait_Sin',... %adding a beep to tell the rat it can go to the side ports now
        'Timer', 0.001,...
        'StateChangeConditions', {'Tup','wait_Sin2','SoftCode2','wait_Sin1', CenterPortOut,'nostim_wait_Sin',},...
        'OutputActions', {'SoftCode', 12, strcat('PWM',num2str(LeftPort)),255, strcat('PWM',num2str(RightPort)),255});

    sma = AddState(sma, 'Name', 'wait_Sin1',...
        'Timer', .001,...
        'StateChangeConditions', {CenterPortOut,'nostim_wait_Sin', LeftPortIn,'start_Lin',RightPortIn,'start_Rin','Tup','wait_Sin2'},...
        'OutputActions', {'SoftCode',PlayStim,strcat('PWM',num2str(LeftPort)),255, strcat('PWM',num2str(RightPort)),255});

    sma = AddState(sma, 'Name', 'wait_Sin2',...
        'Timer', 0.5,...
        'StateChangeConditions', {CenterPortOut,'nostim_wait_Sin',LeftPortIn,'start_Lin',RightPortIn,'start_Rin','SoftCode2','wait_Sin1'},...
        'OutputActions', {strcat('PWM',num2str(LeftPort)),255, strcat('PWM',num2str(RightPort)),255});
    if TaskParameters.GUI.Resample
        sma = AddState(sma, 'Name', 'nostim_wait_Sin',...
            'Timer',TaskParameters.GUI.ChoiceDeadLine,...
            'StateChangeConditions', {CenterPortIn, 'start_Cin', LeftPortIn,'start_Lin',RightPortIn,'start_Rin','Tup','missed_choice'},...
             'OutputActions',{'SoftCode', FlipBlankScreen, strcat('PWM',num2str(LeftPort)),PortLEDs,strcat('PWM',num2str(RightPort)),PortLEDs});
    else
        sma = AddState(sma, 'Name', 'nostim_wait_Sin',...
            'Timer',TaskParameters.GUI.ChoiceDeadLine,...
            'StateChangeConditions', {LeftPortIn,'start_Lin',RightPortIn,'start_Rin','Tup','missed_choice'},...
             'OutputActions',{'SoftCode', FlipBlankScreen, strcat('PWM',num2str(LeftPort)),PortLEDs,strcat('PWM',num2str(RightPort)),PortLEDs});

    end
else
    sma = AddState(sma, 'Name', 'wait_Sin',... %adding a beep to tell the rat it can go to the side ports now
        'Timer', .001,...
        'StateChangeConditions', {'SoftCode2','wait_Sin1', 'Tup','wait_Sin2'},...
        'OutputActions', {'SoftCode', 12,strcat('PWM',num2str(LeftPort)),255, strcat('PWM',num2str(RightPort)),255});

    sma = AddState(sma, 'Name', 'wait_Sin1',...
        'Timer', .001,...
        'StateChangeConditions', {LeftPortIn,'start_Lin',RightPortIn,'start_Rin','Tup','wait_Sin2'},...
        'OutputActions', {'SoftCode',PlayStim,strcat('PWM',num2str(LeftPort)),255, strcat('PWM',num2str(RightPort)),255});

    sma = AddState(sma, 'Name', 'wait_Sin2',...
        'Timer', 0.5,...
        'StateChangeConditions', {LeftPortIn,'start_Lin',RightPortIn,'start_Rin','SoftCode2','wait_Sin1'},...
        'OutputActions', {strcat('PWM',num2str(LeftPort)),255, strcat('PWM',num2str(RightPort)),255});   
end


sma = AddState(sma, 'Name','start_Lin',...
    'Timer',0,...
    'StateChangeConditions', {'Tup','Lin'},...
    'OutputActions',{'GlobalTimerTrig',1, 'SoftCode', FlipBlankScreen});

sma = AddState(sma, 'Name','start_Rin',...
    'Timer',0,...
    'StateChangeConditions', {'Tup','Rin'},...
    'OutputActions',{'GlobalTimerTrig',1, 'SoftCode', FlipBlankScreen});

sma = AddState(sma, 'Name', 'Lin',...
    'Timer', TaskParameters.GUI.FeedbackDelay1,...
    'StateChangeConditions', {LeftPortOut,'Lin_grace','Tup','left_acheived_2','GlobalTimer1_End','left_acheived_2'},...
    'OutputActions', {});

sma = AddState(sma, 'Name', 'Rin',...
    'Timer', TaskParameters.GUI.FeedbackDelay1,...
    'StateChangeConditions', {RightPortOut,'Rin_grace','Tup','right_acheived_2','GlobalTimer1_End','right_acheived_2'},...
    'OutputActions', {});

sma = AddState(sma, 'Name', 'Lin_grace',...
    'Timer', TaskParameters.GUI.FeedbackDelayGrace,...
    'StateChangeConditions',{'Tup','skipped_feedback',LeftPortIn,'start_Lin'},...
    'OutputActions', {strcat('PWM',num2str(LeftPort)),50});

sma = AddState(sma, 'Name', 'Rin_grace',...
    'Timer', TaskParameters.GUI.FeedbackDelayGrace,...
    'StateChangeConditions',{'Tup','skipped_feedback',RightPortIn,'start_Rin'},...
    'OutputActions', {strcat('PWM',num2str(RightPort)),50});

sma = AddState(sma, 'Name','left_acheived_2',...
    'Timer',0,...
    'StateChangeConditions', {'Tup','start_Lin2'},...
    'OutputActions',{'SoftCode', 13});

sma = AddState(sma, 'Name','right_acheived_2',...
    'Timer',0,...
    'StateChangeConditions', {'Tup','start_Rin2'},...
    'OutputActions',{'SoftCode', 13});

sma = AddState(sma, 'Name','start_Lin2',...
    'Timer',0,...
    'StateChangeConditions', {'Tup','Lin2'},...
    'OutputActions',{'GlobalTimerTrig',4});

sma = AddState(sma, 'Name','start_Rin2',...
    'Timer',0,...
    'StateChangeConditions', {'Tup','Rin2'},...
    'OutputActions',{'GlobalTimerTrig',4});

sma = AddState(sma, 'Name', 'Lin2',...
    'Timer', TaskParameters.GUI.FeedbackDelay2,...
    'StateChangeConditions', {LeftPortOut,'Lin2_grace','Tup','left_achieved_3','GlobalTimer4_End','left_achieved_3'},...
    'OutputActions', {});

sma = AddState(sma, 'Name', 'Rin2',...
    'Timer', TaskParameters.GUI.FeedbackDelay2,...
    'StateChangeConditions', {RightPortOut,'Rin2_grace','Tup','right_achieved_3','GlobalTimer4_End','right_achieved_3'},...
    'OutputActions', {});

sma = AddState(sma, 'Name', 'Lin2_grace',...
    'Timer', TaskParameters.GUI.FeedbackDelayGrace,...
    'StateChangeConditions',{'Tup',LeftPokeAction1,LeftPortIn,'Lin2'},...
    'OutputActions', {strcat('PWM',num2str(LeftPort)),50});

sma = AddState(sma, 'Name', 'Rin2_grace',...
    'Timer', TaskParameters.GUI.FeedbackDelayGrace,...
    'StateChangeConditions',{'Tup',RightPokeAction1,RightPortIn,'Rin2'},...
    'OutputActions', {strcat('PWM',num2str(RightPort)),50});

sma = AddState(sma, 'Name','left_achieved_3',...
    'Timer',0,...
    'StateChangeConditions', {'Tup','start_Lin3'},...
    'OutputActions',{'SoftCode', 14});

sma = AddState(sma, 'Name','right_achieved_3',...
    'Timer',0,...
    'StateChangeConditions', {'Tup','start_Rin3'},...
    'OutputActions',{'SoftCode', 14});

sma = AddState(sma, 'Name','start_Lin3',...
    'Timer',0,...
    'StateChangeConditions', {'Tup','Lin3'},...
    'OutputActions',{'GlobalTimerTrig',5});

sma = AddState(sma, 'Name','start_Rin3',...
    'Timer',0,...
    'StateChangeConditions', {'Tup','Rin3'},...
    'OutputActions',{'GlobalTimerTrig',5});

sma = AddState(sma, 'Name', 'Lin3',...
    'Timer', TaskParameters.GUI.FeedbackDelay3,...
    'StateChangeConditions', {LeftPortOut,'Lin3_grace','Tup',LeftPokeAction3,'GlobalTimer5_End',LeftPokeAction3},...
    'OutputActions', {});
 
sma = AddState(sma, 'Name', 'Rin3',...
    'Timer', TaskParameters.GUI.FeedbackDelay3,...
    'StateChangeConditions', {RightPortOut,'Rin3_grace','Tup',RightPokeAction3,'GlobalTimer5_End',RightPokeAction3},...
    'OutputActions', {});

sma = AddState(sma, 'Name', 'Lin3_grace',...
    'Timer', TaskParameters.GUI.FeedbackDelayGrace,...
    'StateChangeConditions',{'Tup',LeftPokeAction2,LeftPortIn,'Lin3',},...
    'OutputActions', { strcat('PWM',num2str(BCenterPort)),50});

sma = AddState(sma, 'Name', 'Rin3_grace',...
    'Timer', TaskParameters.GUI.FeedbackDelayGrace,...
    'StateChangeConditions',{'Tup',RightPokeAction2,RightPortIn,'Rin3'},...
    'OutputActions', {strcat('PWM',num2str(BCenterPort)),50});

sma = AddState(sma, 'Name', 'Rewarded_Bin_Wait1',...
    'Timer', TaskParameters.GUI.ChoiceDeadLine,...
    'StateChangeConditions', {'Tup','ITI', BLeftPortIn,  'water_L'},...
    'OutputActions', {strcat('PWM',num2str(BLeftPort)),PortLEDs});
sma = AddState(sma, 'Name', 'Rewarded_Bin_Wait2',...
    'Timer', TaskParameters.GUI.ChoiceDeadLine,...
    'StateChangeConditions', {'Tup','ITI', BCenterPortIn, 'water_C'},...
    'OutputActions', {strcat('PWM',num2str(BCenterPort)),PortLEDs});

sma = AddState(sma, 'Name', 'Rewarded_Bin_Wait3',...
    'Timer', TaskParameters.GUI.ChoiceDeadLine,...
    'StateChangeConditions', {'Tup','ITI', BRightPortIn, 'water_R'},...
    'OutputActions', {'SoftCode', 15, strcat('PWM',num2str(BRightPort)),PortLEDs});

sma = AddState(sma, 'Name', 'water_L',...
    'Timer', BLeftValveTime,...
    'StateChangeConditions', {'Tup','Drinking'},...
    'OutputActions', {'ValveState', BLeftValve, 'SoftCode', 13});
sma = AddState(sma, 'Name', 'water_C',...
    'Timer', BCenterValveTime,...
    'StateChangeConditions', {'Tup','Drinking'},...
    'OutputActions', {'ValveState', BCenterValve, 'SoftCode', 14});
sma = AddState(sma, 'Name', 'water_R',...
    'Timer', BRightValveTime,...
    'StateChangeConditions', {'Tup','Drinking'},...
    'OutputActions', {'ValveState', BRightValve, 'SoftCode', 15});
sma = AddState(sma, 'Name', 'unRewarded_Bin_Wait1',...
    'Timer', TaskParameters.GUI.ChoiceDeadLine,...
    'StateChangeConditions', {'Tup','ITI', BLeftPortIn,  'unRewarded_Bin_L'},...
    'OutputActions', {  strcat('PWM',num2str(BLeftPort)),PortLEDs});
sma = AddState(sma, 'Name', 'unRewarded_Bin_Wait2',...
    'Timer', TaskParameters.GUI.ChoiceDeadLine,...
    'StateChangeConditions', {'Tup','ITI',BCenterPortIn, 'unRewarded_Bin_C'},...
    'OutputActions', {  strcat('PWM',num2str(BCenterPort)),PortLEDs});

sma = AddState(sma, 'Name', 'unRewarded_Bin_Wait3',...
    'Timer', TaskParameters.GUI.ChoiceDeadLine,...
    'StateChangeConditions', {'Tup','ITI', BRightPortIn, 'unRewarded_Bin_R'},...
    'OutputActions', {'SoftCode', 15, strcat('PWM',num2str(BRightPort)),PortLEDs});

sma = AddState(sma, 'Name', 'unRewarded_Bin_L',...
    'Timer', 0.05,...
    'StateChangeConditions', {'Tup','timeOut_IncorrectChoice_Start'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'unRewarded_Bin_C',...
    'Timer', 0.05,...
    'StateChangeConditions', {'Tup','timeOut_IncorrectChoice_Start'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'unRewarded_Bin_R',...
    'Timer', 0.05,...
    'StateChangeConditions', {'Tup','timeOut_IncorrectChoice_Start'},...
    'OutputActions', {});

sma = AddState(sma, 'Name', 'Drinking',...
    'Timer', 0.05,...
    'StateChangeConditions', {'Tup','ITI'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'timeOut_BrokeFixation',...
    'Timer',TaskParameters.GUI.TimeOutBrokeFixation,...
    'StateChangeConditions',{'Tup','ITI'},...
    'OutputActions',{'SoftCode',FlipBlankScreen});
sma = AddState(sma, 'Name', 'timeOut_EarlyWithdrawal',...
    'Timer',TaskParameters.GUI.TimeOutEarlyWithdrawal,...
    'StateChangeConditions',{'Tup','ITI'},...
    'OutputActions',{'SoftCode',FlipBlankScreen});
sma = AddState(sma, 'Name', 'timeOut_IncorrectChoice_Start',...
        'Timer',0.01,...
        'StateChangeConditions',{'Tup','timeOut_IncorrectChoice'},...
        'OutputActions',{'SoftCode',FlipTimeoutScreen});

sma = AddState(sma, 'Name', 'timeOut_IncorrectChoice',...
        'Timer',TaskParameters.GUI.TimeOutIncorrectChoice,...
        'StateChangeConditions',{'Tup','ITI'},...
        'OutputActions',{'SoftCode',FlipTimeoutScreen});


sma = AddState(sma, 'Name', 'timeOut_SkippedFeedback',...
        'Timer',TaskParameters.GUI.TimeOutSkippedFeedback,...
        'StateChangeConditions',{'Tup','ITI'},...
        'OutputActions',{'SoftCode', FlipBlankScreen});

sma = AddState(sma, 'Name', 'skipped_feedback',...
    'Timer', 0.001,...
    'StateChangeConditions', {'Tup','timeOut_SkippedFeedback'},...
    'OutputActions', {'SoftCode', FlipBlankScreen});

sma = AddState(sma, 'Name', 'missed_choice',...
    'Timer',0.001,...
    'StateChangeConditions',{'Tup','ITI'},...
    'OutputActions',{'SoftCode', FlipBlankScreen});


sma = AddState(sma, 'Name', 'ITI',...
    'Timer',TaskParameters.GUI.ITI,...
    'StateChangeConditions',{'Tup','exit'},...
    'OutputActions',{ 'SoftCode', FlipBlankScreen, 'SoftCode', 42}); % Sets flow rates for next trial

    % sma = AddState(sma, 'Name', 'state_name',...
%     'Timer', 0,...
%     'StateChangeConditions', {},...
%     'OutputActions', {});
end
