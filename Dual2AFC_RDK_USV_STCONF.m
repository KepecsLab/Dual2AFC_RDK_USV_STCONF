function Dual2AFC_RDK_USV_STCONF

% 2-AFC olfactory and auditory discrimination task implented for Bpod fork https://github.com/KepecsLab/bpod
% This project is available on https://github.com/KepecsLab/BpodProtocols_Olf2AFC/

global BpodSystem
global nidaq
global channel

%%Prep avisoft and stupid dde 
channel=ddeinit('RECORDER','main');

try
ddeexec(channel,'start')
catch
end
    
%% Task parameters
global TaskParameters
TaskParameters = BpodSystem.ProtocolSettings;
if isempty(fieldnames(TaskParameters))
    %% General
    TaskParameters.GUI.ITI = .1; 
    TaskParameters.GUI.PreITI = .1; 
    TaskParameters.GUI.CenterWaitMax = 2000; 
    TaskParameters.GUI.BL_ra =5;
    TaskParameters.GUI.BC_ra =15;
    TaskParameters.GUI.BR_ra =30;
    TaskParameters.GUI.DrinkingTime = 1;
    TaskParameters.GUI.DrinkingGrace = 0.1;
    TaskParameters.GUI.ChoiceDeadLine = 2000;
    TaskParameters.GUI.TimeOutIncorrectChoice = 10; % (s)
    TaskParameters.GUI.TimeOutBrokeFixation = 0; % (s)
    TaskParameters.GUI.TimeOutEarlyWithdrawal = 0; % (s)
    TaskParameters.GUI.TimeOutSkippedFeedback = 0; % (s)
    TaskParameters.GUI.Resample = true;
    TaskParameters.GUIMeta.Resample.Style = 'checkbox';
    TaskParameters.GUI.PercentAuditory = 1;
    TaskParameters.GUI.StartEasyTrials = 30;
    TaskParameters.GUI.Percent50Fifty = 0;
    TaskParameters.GUI.PercentCatch = 0;
    TaskParameters.GUI.CatchError = false;
    TaskParameters.GUIMeta.CatchError.Style = 'checkbox';
    TaskParameters.GUI.Ports_LMR = 123;
    TaskParameters.GUI.Ports_BLMR = 567;
    TaskParameters.GUI.MaxSessionTime = 180;
    TaskParameters.GUI.PortLEDs = true;
    TaskParameters.GUIMeta.PortLEDs.Style = 'checkbox';
    TaskParameters.GUI.PortLEDs = true;
    TaskParameters.GUIMeta.PortLEDs.Style = 'checkbox';
    

    
    TaskParameters.GUIPanels.General = {'MaxSessionTime','CenterWaitMax','ITI','PreITI', 'BL_ra', 'BC_ra', 'BR_ra','DrinkingTime','DrinkingGrace','ChoiceDeadLine','TimeOutIncorrectChoice','TimeOutBrokeFixation','TimeOutEarlyWithdrawal','TimeOutSkippedFeedback','Resample', 'PercentAuditory','StartEasyTrials','Percent50Fifty','PercentCatch','CatchError',...
        'Ports_LMR','Ports_BLMR','PortLEDs'};
    %% BiasControl
    TaskParameters.GUI.TrialSelection = 1;
    TaskParameters.GUIMeta.TrialSelection.Style = 'popupmenu';
    TaskParameters.GUIMeta.TrialSelection.String = {'Flat','Manual','BiasCorrecting','Competitive'};
    TaskParameters.GUIPanels.BiasControl = {'TrialSelection'};
    %% StimDelay
    TaskParameters.GUI.StimDelayAutoincrement = 0;
    TaskParameters.GUIMeta.StimDelayAutoincrement.Style = 'checkbox';
    TaskParameters.GUIMeta.StimDelayAutoincrement.String = 'Auto';
    TaskParameters.GUI.StimDelayMin = 0.1;
    TaskParameters.GUI.StimDelayMax = 0.2;
    TaskParameters.GUI.StimDelayIncr = 0.01;
    TaskParameters.GUI.StimDelayDecr = 0.01;
    TaskParameters.GUI.StimDelay = TaskParameters.GUI.StimDelayMin;
    TaskParameters.GUIMeta.StimDelay.Style = 'text';
    TaskParameters.GUIPanels.StimDelay = {'StimDelayAutoincrement','StimDelayMin','StimDelayMax','StimDelayIncr','StimDelayDecr','StimDelay'};
    %% FeedbackDelay

    TaskParameters.GUI.FeedbackDelay1min = .25;
    TaskParameters.GUI.FeedbackDelay1max = .5;
    TaskParameters.GUI.FeedbackDelay1 = .25;
    TaskParameters.GUIMeta.FeedbackDelay1.Style = 'text';
    TaskParameters.GUI.FeedbackDelay2min = .25;
    TaskParameters.GUI.FeedbackDelay2max = .75;
    TaskParameters.GUI.FeedbackDelay2 = .5;
    TaskParameters.GUIMeta.FeedbackDelay2.Style = 'text';
    TaskParameters.GUI.FeedbackDelay3min = .5;
    TaskParameters.GUI.FeedbackDelay3max = 1.5;
    TaskParameters.GUI.FeedbackDelay3 = 1.0;
    TaskParameters.GUIMeta.FeedbackDelay3.Style = 'text';
    TaskParameters.GUI.FeedbackDelayGrace = .3;
    TaskParameters.GUI.IncorrectChoiceFeedbackType = 2;
    TaskParameters.GUIMeta.IncorrectChoiceFeedbackType.Style = 'popupmenu';
    TaskParameters.GUIMeta.IncorrectChoiceFeedbackType.String = {'None','Tone','PortLED'};
    TaskParameters.GUI.SkippedFeedbackFeedbackType = 2;
    TaskParameters.GUIMeta.SkippedFeedbackFeedbackType.Style = 'popupmenu';
    TaskParameters.GUIMeta.SkippedFeedbackFeedbackType.String = {'None','Tone','PortLED'};


    TaskParameters.GUIPanels.FeedbackDelay = {'FeedbackDelay1min','FeedbackDelay1max','FeedbackDelay1','FeedbackDelay2min','FeedbackDelay2max','FeedbackDelay2',...
        'FeedbackDelay3min','FeedbackDelay3max','FeedbackDelay3','FeedbackDelayGrace','IncorrectChoiceFeedbackType','SkippedFeedbackFeedbackType'};

    %% Auditory Params
    %clicks
    TaskParameters.GUI.AuditoryAlpha = 1;
    TaskParameters.GUI.LeftBias = 0.5;
    TaskParameters.GUIMeta.LeftBiasAud.Style = 'text';
    TaskParameters.GUI.SumRates = 100;
    
    %dots
    
    %dots
    TaskParameters.GUI.finite_play = false;
    TaskParameters.GUIMeta.finite_play.Style = 'checkbox';
    TaskParameters.GUI.coherence_type = 2; % k of exponential distribution to determine coherence distribution
    TaskParameters.GUIMeta.coherence_type.Style = 'popupmenu';
    TaskParameters.GUIMeta.coherence_type.String = {'training','one value', 'testing', 'remedial'};
    TaskParameters.GUI.color = 255;      % color of the dots [128,128,128];%
    TaskParameters.GUI.size = 16;                   % size of dots (pixels)
    TaskParameters.GUI.centerX = 0; 
    TaskParameters.GUI.centerY = 10; % center of the field of dots (x,y)
    TaskParameters.GUI.apertureX = 70;
    TaskParameters.GUI.apertureY = 50;     % size of rectangular aperture [w,h] in degrees.
    TaskParameters.GUI.speed = 100;       %degrees/second, we must multiply by 2 because we are halving the framerate
    TaskParameters.GUI.nDots = 250;
    TaskParameters.GUI.lifetime = 30;  %lifetime of each dot (frames)
    TaskParameters.GUIPanels.Dots= {'finite_play', 'coherence_type', 'color', 'size', 'centerX','centerY', 'apertureX', 'apertureY' 'speed', 'lifetime', 'nDots'}; 
    
    
    %zador freq stimuli
    TaskParameters.GUI.Aud_nFreq = 18;
    TaskParameters.GUI.Aud_NoEvidence = 0;
    TaskParameters.GUI.Aud_minFreq = 200;
    TaskParameters.GUI.Aud_maxFreq = 20000;
    TaskParameters.GUI.Aud_Volume = 70;
    TaskParameters.GUI.Aud_ToneDuration = 0.03;
    TaskParameters.GUI.Aud_ToneOverlap = 0.6667;
    TaskParameters.GUI.Aud_Ramp = 0.003;
    TaskParameters.GUI.Aud_SamplingRate = 192000;
    TaskParameters.GUI.Aud_UseMiddleOctave=0;
    TaskParameters.GUI.Aud_Levels.AudFracHigh = [5, 30, 45, 55, 70, 95]';
    TaskParameters.GUI.Aud_Levels.AudPFrac = ones(size(TaskParameters.GUI.Aud_Levels.AudFracHigh))/numel(TaskParameters.GUI.Aud_Levels.AudFracHigh);
    TaskParameters.GUIMeta.Aud_Levels.Style = 'table';
    TaskParameters.GUIMeta.Aud_Levels.String = 'Freq probabilities';
    TaskParameters.GUIMeta.Aud_Levels.ColumnLabel = {'a = Frac high','P(a)'};
    %min auditory stimulus and general stuff
    TaskParameters.GUI.StimulusType = 3;
    TaskParameters.GUIMeta.StimulusType.Style = 'popupmenu';
    TaskParameters.GUIMeta.StimulusType.String = {'Clicks','Freqs', 'Dots'};
    TaskParameters.GUI.MinSampleMin = 0.35;
    TaskParameters.GUI.MinSampleMax = 0.35;
    TaskParameters.GUI.MinSampleAutoincrement = false;
    TaskParameters.GUIMeta.MinSampleAutoincrement.Style = 'checkbox';
    TaskParameters.GUI.MinSampleIncr = 0.05;
    TaskParameters.GUI.MinSampleDecr = 0.02;
    TaskParameters.GUI.MinSample = TaskParameters.GUI.MinSampleMin;
    TaskParameters.GUIMeta.MinSample.Style = 'text';
    TaskParameters.GUIPanels.StimGeneral = {'StimulusType'};
    TaskParameters.GUIPanels.AudClicks = {'AuditoryAlpha','LeftBias','SumRates'};
    TaskParameters.GUIPanels.AudFreq = {'Aud_nFreq','Aud_NoEvidence','Aud_minFreq','Aud_maxFreq','Aud_Volume','Aud_ToneDuration','Aud_ToneOverlap','Aud_Ramp','Aud_SamplingRate','Aud_UseMiddleOctave'};
    TaskParameters.GUIPanels.AudFreqLevels = {'Aud_Levels'};
    TaskParameters.GUIPanels.MinSample= {'MinSampleMin','MinSampleMax','MinSampleAutoincrement','MinSampleIncr','MinSampleDecr','MinSample'};
    %% Block structure
    TaskParameters.GUI.BlockTable.BlockNumber = [1, 2, 3, 4]';
    TaskParameters.GUI.BlockTable.BlockLen = ones(4,1)*5000;
    TaskParameters.GUI.BlockTable.RewL = [1 randsample([1 .6],2) 1]';
    TaskParameters.GUI.BlockTable.RewR = flipud(TaskParameters.GUI.BlockTable.RewL);
    TaskParameters.GUIMeta.BlockTable.Style = 'table';
    TaskParameters.GUIMeta.BlockTable.String = 'Block structure';
    TaskParameters.GUIMeta.BlockTable.ColumnLabel = {'Block#','Block Length','Rew L', 'Rew R'};
    TaskParameters.GUIPanels.BlockStructure = {'BlockTable'};
    %% Plots
    %Show Plots
    TaskParameters.GUI.ShowPsycOlf = 0;
    TaskParameters.GUIMeta.ShowPsycOlf.Style = 'checkbox';
    TaskParameters.GUI.ShowPsycAud = 1;
    TaskParameters.GUIMeta.ShowPsycAud.Style = 'checkbox';
    TaskParameters.GUI.ShowVevaiometric = 1;
    TaskParameters.GUIMeta.ShowVevaiometric.Style = 'checkbox';
    TaskParameters.GUI.ShowTrialRate = 1;
    TaskParameters.GUIMeta.ShowTrialRate.Style = 'checkbox';
    TaskParameters.GUI.ShowFix = 1;
    TaskParameters.GUIMeta.ShowFix.Style = 'checkbox';
    TaskParameters.GUI.ShowST = 1;
    TaskParameters.GUIMeta.ShowST.Style = 'checkbox';
    TaskParameters.GUI.ShowFeedback = 1;
    TaskParameters.GUIMeta.ShowFeedback.Style = 'checkbox';
    TaskParameters.GUIPanels.ShowPlots = {'ShowPsycOlf','ShowPsycAud','ShowVevaiometric','ShowTrialRate','ShowFix','ShowST','ShowFeedback'};
    %Vevaiometric
    TaskParameters.GUI.VevaiometricMinWT = 2;
    TaskParameters.GUI.VevaiometricNBin = 8;
    TaskParameters.GUI.VevaiometricShowPoints = 1;
    TaskParameters.GUIMeta.VevaiometricShowPoints.Style = 'checkbox';
    TaskParameters.GUIPanels.Vevaiometric = {'VevaiometricMinWT','VevaiometricNBin','VevaiometricShowPoints'};
    %% Laser
    TaskParameters.GUI.LaserTrials = false;
    TaskParameters.GUI.LaserSoftCode = false;
    TaskParameters.GUIMeta.LaserSoftCode.Style='checkbox';
    TaskParameters.GUI.LaserAmp = 5;
    TaskParameters.GUI.LaserStimFreq = 0;
    TaskParameters.GUI.LaserPulseDuration_ms = 1;
    TaskParameters.GUI.LaserTrainDuration_ms = 0;
    TaskParameters.GUI.LaserRampDuration_ms = 0;
    TaskParameters.GUI.LaserTrainRandStart = false;
    TaskParameters.GUIMeta.LaserTrainRandStart.Style='checkbox';
    TaskParameters.GUI.LaserTrainStartMin_s = 0;
    TaskParameters.GUI.LaserTrainStartMax_s = 5;
    TaskParameters.GUI.LaserITI = 0; TaskParameters.GUIMeta.LaserITI.Style = 'checkbox';
    TaskParameters.GUI.LaserPreStim = 0; TaskParameters.GUIMeta.LaserPreStim.Style = 'checkbox';
    TaskParameters.GUI.LaserStim = 0; TaskParameters.GUIMeta.LaserStim.Style = 'checkbox';
    TaskParameters.GUI.LaserMov = 0; TaskParameters.GUIMeta.LaserMov.Style = 'checkbox';
    TaskParameters.GUI.LaserTimeInvestment = 1; TaskParameters.GUIMeta.LaserTimeInvestment.Style = 'checkbox';
    TaskParameters.GUI.LaserRew = 0; TaskParameters.GUIMeta.LaserRew.Style = 'checkbox';
    TaskParameters.GUI.LaserFeedback = 0; TaskParameters.GUIMeta.LaserFeedback.Style = 'checkbox';
    TaskParameters.GUIPanels.LaserGeneral = {'LaserTrials','LaserSoftCode','LaserAmp','LaserStimFreq','LaserPulseDuration_ms'};
    TaskParameters.GUIPanels.LaserTrain = {'LaserTrainDuration_ms','LaserTrainRandStart','LaserRampDuration_ms','LaserTrainStartMin_s','LaserTrainStartMax_s'};
    TaskParameters.GUIPanels.LaserTaskEpochs = {'LaserITI','LaserPreStim','LaserStim','LaserMov','LaserTimeInvestment','LaserRew','LaserFeedback'};
    %% Video
    TaskParameters.GUI.Wire1VideoTrigger = false;
    TaskParameters.GUIMeta.Wire1VideoTrigger.Style = 'checkbox';
    TaskParameters.GUI.VideoTrials = 1;
    TaskParameters.GUIMeta.VideoTrials.Style = 'popupmenu';
    TaskParameters.GUIMeta.VideoTrials.String = {'Investment','All'};
    TaskParameters.GUIPanels.VideoGeneral = {'Wire1VideoTrigger','VideoTrials'};
    
    %% Photometry
    %photometry general
    TaskParameters.GUI.Photometry=false;
    TaskParameters.GUIMeta.Photometry.Style='checkbox';
    TaskParameters.GUI.DbleFibers=0;
    TaskParameters.GUIMeta.DbleFibers.Style='checkbox';
    TaskParameters.GUIMeta.DbleFibers.String='Auto';
    TaskParameters.GUI.Isobestic405=0;
    TaskParameters.GUIMeta.Isobestic405.Style='checkbox';
    TaskParameters.GUIMeta.Isobestic405.String='Auto';
    TaskParameters.GUI.RedChannel=1;
    TaskParameters.GUIMeta.RedChannel.Style='checkbox';
    TaskParameters.GUIMeta.RedChannel.String='Auto';    
    TaskParameters.GUIPanels.PhotometryRecording={'Photometry','DbleFibers','Isobestic405','RedChannel'};
    
    %plot photometry
    TaskParameters.GUI.TimeMin=-4;
    TaskParameters.GUI.TimeMax=4;
    TaskParameters.GUI.NidaqMin=-5;
    TaskParameters.GUI.NidaqMax=10;
    TaskParameters.GUI.PhotoPlotSidePokeIn=true;
	TaskParameters.GUIMeta.PhotoPlotSidePokeIn.Style='checkbox';
    TaskParameters.GUI.PhotoPlotSidePokeLeave=true;
	TaskParameters.GUIMeta.PhotoPlotSidePokeLeave.Style='checkbox';
    TaskParameters.GUI.PhotoPlotReward=true;
	TaskParameters.GUIMeta.PhotoPlotReward.Style='checkbox';    
     TaskParameters.GUI.BaselineBegin=0.1;
    TaskParameters.GUI.BaselineEnd=1.1;
    TaskParameters.GUIPanels.PhotometryPlot={'TimeMin','TimeMax','NidaqMin','NidaqMax','PhotoPlotSidePokeIn','PhotoPlotSidePokeLeave','PhotoPlotReward','BaselineBegin','BaselineEnd'};
    
    %% Nidaq and Photometry
    TaskParameters.GUI.PhotometryVersion=1;
    TaskParameters.GUI.Modulation=true;
    TaskParameters.GUIMeta.Modulation.Style='checkbox';
    TaskParameters.GUIMeta.Modulation.String='Auto';
	TaskParameters.GUI.NidaqDuration=4;
    TaskParameters.GUI.NidaqSamplingRate=6100;
    TaskParameters.GUI.DecimateFactor=610;
    TaskParameters.GUI.LED1_Name='Fiber1 470-A1';
    TaskParameters.GUIMeta.LED1_Name.Style='edittext';
    TaskParameters.GUI.LED1_Amp=2;
    TaskParameters.GUI.LED1_Freq=211;
    TaskParameters.GUI.LED2_Name='Fiber1 405 / 565';
    TaskParameters.GUIMeta.LED2_Name.Style='edittext';
    TaskParameters.GUI.LED2_Amp=2;
    TaskParameters.GUI.LED2_Freq=531;
    TaskParameters.GUI.LED1b_Name='Fiber2 470-mPFC';
    TaskParameters.GUIMeta.LED1b_Name.Style='edittext';
    TaskParameters.GUI.LED1b_Amp=2;
    TaskParameters.GUI.LED1b_Freq=531;

    TaskParameters.GUIPanels.PhotometryNidaq={'PhotometryVersion','Modulation','NidaqDuration',...
                            'NidaqSamplingRate','DecimateFactor',...
                            'LED1_Name','LED1_Amp','LED1_Freq',...
                            'LED2_Name','LED2_Amp','LED2_Freq',...
                            'LED1b_Name','LED1b_Amp','LED1b_Freq'};
                        
                     % rig-specific
        TaskParameters.GUI.nidaqDev='Dev2';
        TaskParameters.GUIMeta.nidaqDev.Style='edittext';
        
        TaskParameters.GUIPanels.PhotometryRig={'nidaqDev'};      
                        
    %%
    TaskParameters.GUI = orderfields(TaskParameters.GUI);
    %% Tabs
    TaskParameters.GUITabs.General = {'StimDelay','BiasControl','General','FeedbackDelay','BlockStructure'};
    TaskParameters.GUITabs.Stimulus = {'StimGeneral','MinSample','AudClicks','AudFreq','AudFreqLevels', 'Dots'};
    TaskParameters.GUITabs.Plots = {'ShowPlots','Vevaiometric'};
    TaskParameters.GUITabs.Laser = {'LaserGeneral','LaserTrain','LaserTaskEpochs'};
    TaskParameters.GUITabs.Video = {'VideoGeneral'};
    TaskParameters.GUITabs.Photometry = {'PhotometryRecording','PhotometryNidaq','PhotometryPlot','PhotometryRig'};
    
    %%Non-GUI Parameters (but saved)
    TaskParameters.Figures.OutcomePlot.Position = [200, 200, 1000, 400];
    TaskParameters.Figures.ParameterGUI.Position =  [9, 454, 1474, 562];
    
end
BpodParameterGUI('init', TaskParameters);

%% Initializing data (trial type) vectors
BpodSystem.Data.Custom.BlockNumber = 1;
BpodSystem.Data.Custom.BlockTrial = 1;
BpodSystem.Data.Custom.ChoiceLeft = [];
BpodSystem.Data.Custom.ChoiceCorrect = [];
BpodSystem.Data.Custom.Feedback = false(0);
BpodSystem.Data.Custom.FeedbackTime = [];
BpodSystem.Data.Custom.FixBroke = false(0);
BpodSystem.Data.Custom.EarlyWithdrawal = false(0);
BpodSystem.Data.Custom.FixDur = [];
BpodSystem.Data.Custom.MT = [];
BpodSystem.Data.Custom.CatchTrial = false;
BpodSystem.Data.Custom.ST = [];
BpodSystem.Data.Custom.ResolutionTime = [];
BpodSystem.Data.Custom.Rewarded = false(0);
BpodSystem.Data.Custom.FeedbackCheckpoint = [];
BpodSystem.Data.Custom.RewardMagnitude = [];
BpodSystem.Data.Custom.TrialNumber = [];
BpodSystem.Data.Custom.LaserTrial = false;
BpodSystem.Data.Custom.LaserTrialTrainStart = NaN;
BpodSystem.Data.Custom.AuditoryTrial = rand(1,1) < TaskParameters.GUI.PercentAuditory;
BpodSystem.Data.Custom.ClickTask = true(1,1) & TaskParameters.GUI.StimulusType == 1;
BpodSystem.Data.Custom.OlfactometerStartup = false;
BpodSystem.Data.Custom.PsychtoolboxStartup = false;
BpodSystem.Data.Custom.ChoiceTime = [];
BpodSystem.Data.Custom.WaitingTime = [];
%initialize psychtoolboxvision
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
display.dist = 8.0;  % cm
display.width = 52/2; % cm

screen_num = 2;
display.screenNum = screen_num;

%load MyGammaTable
tmp = Screen('Resolution',1);
%Screen('LoadNormalizedGammaTable', screen_num, gammaTable*[1 1 1]);
display.resolution = [tmp.width,tmp.height];
%calfile = load('tmp.mat');
%display = OpenWindow(display);
%display.scal = calfile.scal;

%PsychImaging('PrepareConfiguration');
%PsychImaging('AddTask', 'AllViews', 'GeometryCorrection', 'C:\Users\Amy\Documents\BpodUser\Protocols\Dual2AFC_RDK\tmp.mat');


display.windowPtr = PsychImaging('OpenWindow', display.screenNum, [0, 0, 0]); 

%display = OpenWindow(display);  

% Measure the vertical refresh rate of the monitor
display.ifi = Screen('GetFlipInterval', display.windowPtr);

% Retreive and set the maximum priority number
topPriorityLevel = MaxPriority(display.windowPtr);
Priority(topPriorityLevel);

% Numer of frames to wait when specifying good timing
display.waitframes = .5;

% flip screen
display.vbl = Screen('Flip',display.windowPtr);



BpodSystem.Data.Custom.display = display;

% make auditory stimuli for first trials
a = 1;
switch TaskParameters.GUI.StimulusType
    case 1
        if BpodSystem.Data.Custom.AuditoryTrial(a)
            BpodSystem.Data.Custom.AuditoryOmega(a) = betarnd(TaskParameters.GUI.AuditoryAlpha/4,TaskParameters.GUI.AuditoryAlpha/4,1,1);
            BpodSystem.Data.Custom.LeftClickRate(a) = round(BpodSystem.Data.Custom.AuditoryOmega(a)*TaskParameters.GUI.SumRates);
            BpodSystem.Data.Custom.RightClickRate(a) = round((1-BpodSystem.Data.Custom.AuditoryOmega(a))*TaskParameters.GUI.SumRates);
            BpodSystem.Data.Custom.LeftClickTrain{a} = GeneratePoissonClickTrain(BpodSystem.Data.Custom.LeftClickRate(a), TaskParameters.GUI.StimulusTime);
            BpodSystem.Data.Custom.RightClickTrain{a} = GeneratePoissonClickTrain(BpodSystem.Data.Custom.RightClickRate(a), TaskParameters.GUI.StimulusTime);
            %correct left/right click train
            if ~isempty(BpodSystem.Data.Custom.LeftClickTrain{a}) && ~isempty(BpodSystem.Data.Custom.RightClickTrain{a})
                BpodSystem.Data.Custom.LeftClickTrain{a}(1) = min(BpodSystem.Data.Custom.LeftClickTrain{a}(1),BpodSystem.Data.Custom.RightClickTrain{a}(1));
                BpodSystem.Data.Custom.RightClickTrain{a}(1) = min(BpodSystem.Data.Custom.LeftClickTrain{a}(1),BpodSystem.Data.Custom.RightClickTrain{a}(1));
            elseif  isempty(BpodSystem.Data.Custom.LeftClickTrain{a}) && ~isempty(BpodSystem.Data.Custom.RightClickTrain{a})
                BpodSystem.Data.Custom.LeftClickTrain{a}(1) = BpodSystem.Data.Custom.RightClickTrain{a}(1);
            elseif ~isempty(BpodSystem.Data.Custom.LeftClickTrain{1}) &&  isempty(BpodSystem.Data.Custom.RightClickTrain{a})
                BpodSystem.Data.Custom.RightClickTrain{a}(1) = BpodSystem.Data.Custom.LeftClickTrain{a}(1);
            else
                BpodSystem.Data.Custom.LeftClickTrain{a} = round(1/BpodSystem.Data.Custom.LeftClickRate*10000)/10000;
                BpodSystem.Data.Custom.RightClickTrain{a} = round(1/BpodSystem.Data.Custom.RightClickRate*10000)/10000;
            end
            if length(BpodSystem.Data.Custom.LeftClickTrain{a}) > length(BpodSystem.Data.Custom.RightClickTrain{a})
                BpodSystem.Data.Custom.LeftRewarded(a) = double(1);
            elseif length(BpodSystem.Data.Custom.LeftClickTrain{1}) < length(BpodSystem.Data.Custom.RightClickTrain{a})
                BpodSystem.Data.Custom.LeftRewarded(a) = double(0);
            else
                BpodSystem.Data.Custom.LeftRewarded(a) = rand<0.5;
            end
        else
            BpodSystem.Data.Custom.AuditoryOmega(a) = NaN;
            BpodSystem.Data.Custom.LeftClickRate(a) = NaN;
            BpodSystem.Data.Custom.RightClickRate(a) = NaN;
            BpodSystem.Data.Custom.LeftClickTrain{a} = [];
            BpodSystem.Data.Custom.RightClickTrain{a} = [];
        end

    case 2
        StimulusSettings.SamplingRate = TaskParameters.GUI.Aud_SamplingRate; % Sound card sampling rate;
        StimulusSettings.ramp = TaskParameters.GUI.Aud_Ramp;
        StimulusSettings.nFreq = TaskParameters.GUI.Aud_nFreq; % Number of different frequencies to sample from
        StimulusSettings.ToneOverlap = TaskParameters.GUI.Aud_ToneOverlap;
        StimulusSettings.ToneDuration = TaskParameters.GUI.Aud_ToneDuration;
        StimulusSettings.Noevidence=TaskParameters.GUI.Aud_NoEvidence;
        StimulusSettings.minFreq = TaskParameters.GUI.Aud_minFreq ;
        StimulusSettings.maxFreq = TaskParameters.GUI.Aud_maxFreq ;
        StimulusSettings.UseMiddleOctave=TaskParameters.GUI.Aud_UseMiddleOctave;
        StimulusSettings.Volume=TaskParameters.GUI.Aud_Volume;
        StimulusSettings.nTones = floor((TaskParameters.GUI.StimulusTime-StimulusSettings.ToneDuration*StimulusSettings.ToneOverlap)/(StimulusSettings.ToneDuration*(1-StimulusSettings.ToneOverlap))); %number of tones

        EasyProb = zeros(numel(TaskParameters.GUI.Aud_Levels.AudPFrac),1);
        EasyProb(1) = 0.5; EasyProb(end)=0.5;
        newFracHigh = randsample(TaskParameters.GUI.Aud_Levels.AudFracHigh,1,1,EasyProb);
        [Sound, Cloud, ~] = GenerateToneCloudDual(newFracHigh/100, StimulusSettings);
        BpodSystem.Data.Custom.AudFracHigh(a) = newFracHigh;
        BpodSystem.Data.Custom.AudCloud{a} = Cloud;
        BpodSystem.Data.Custom.AudSound{a} = Sound;
        BpodSystem.Data.Custom.LeftRewarded(a)= newFracHigh>50;

    case 3

        num_trials=1; %(precompute the dots for 2000 trials)
        BpodSystem.Data.Custom.Coherence(a) = compute_coherence(num_trials,TaskParameters.GUI.coherence_type);
        BpodSystem.Data.Custom.Coherencetype = TaskParameters.GUI.coherence_type;


        dots{a}.color = [TaskParameters.GUI.color TaskParameters.GUI.color TaskParameters.GUI.color];      % color of the dots [128,128,128];%
        dots{a}.nDots = TaskParameters.GUI.nDots;
        dots{a}.size = TaskParameters.GUI.size;                   % size of dots (pixels)
        dots{a}.center = [TaskParameters.GUI.centerX TaskParameters.GUI.centerY] ;           % center of the field of dots (x,y)
        dots{a}.apertureSize = [TaskParameters.GUI.apertureX TaskParameters.GUI.apertureY];     % size of rectangular aperture [w,h] in degrees.
        dots{a}.speed = TaskParameters.GUI.speed;       %degrees/second, we must multiply by 2 because we are halving the framerate
        dots{a}.duration = TaskParameters.GUI.MinSample;    %seconds
        dots{a}.lifetime = TaskParameters.GUI.lifetime;  %lifetime of each dot (frames)
        dots{a}.type = 'normal'; 


        BpodSystem.Data.Custom.close_priors{a} = [ .5 ];
         correct_side =...
                    compute_trial_side(BpodSystem.Data.Custom.close_priors{a});

        BpodSystem.Data.Custom.correct_side(a) = correct_side;

        dots{a}.direction = compute_direction(BpodSystem.Data.Custom.correct_side); % correct direction for each trial, either 90 or 270

        [dirs, dx, dy] =...
            compute_dirs(num_trials, dots{a}.nDots, BpodSystem.Data.Custom.Coherence(a),...
            dots{a}.direction, dots{a}.speed, 60);

        dots{a}.dirs = dirs;
        dots{a}.dx = dx;
        dots{a}.dy = dy;

        BpodSystem.Data.Custom.dots = dots;
        BpodSystem.Data.Custom.display = display;

        BpodSystem.Data.Custom.LeftRewarded(a)= BpodSystem.Data.Custom.correct_side(a) < 0;
        BpodSystem.Data.Custom.DV(a) = BpodSystem.Data.Custom.Coherence(a)*BpodSystem.Data.Custom.correct_side(a);



end%for a+1:2

BpodSystem.SoftCodeHandlerFunction = 'SoftCodeHandler';

%server data
[~,BpodSystem.Data.Custom.Rig] = system('hostname');
[~,BpodSystem.Data.Custom.Subject] = fileparts(fileparts(fileparts(fileparts(BpodSystem.DataPath))));

%% Configuring PulsePal
%load PulsePalParamStimulus.mat
load PulsePalParamFeedback.mat
%BpodSystem.Data.Custom.PulsePalParamStimulus=configurePulsePalLaser(PulsePalParamStimulus);
BpodSystem.Data.Custom.PulsePalParamFeedback=PulsePalParamFeedback;
%clear PulsePalParamFeedback PulsePalParamStimulus

if BpodSystem.Data.Custom.AuditoryTrial(1)
   if ~BpodSystem.EmulatorMode
    
        if BpodSystem.Data.Custom.ClickTask(1) 
            ProgramPulsePal(BpodSystem.Data.Custom.PulsePalParamStimulus);
            SendCustomPulseTrain(1, BpodSystem.Data.Custom.RightClickTrain{1}, ones(1,length(BpodSystem.Data.Custom.RightClickTrain{1}))*5);
            SendCustomPulseTrain(2, BpodSystem.Data.Custom.LeftClickTrain{1}, ones(1,length(BpodSystem.Data.Custom.LeftClickTrain{1}))*5);
        else
          %  InitiatePsychtoolbox(1);
          %  PsychToolboxSoundServer('Load', 1, BpodSystem.Data.Custom.AudSound{1});
           % BpodSystem.Data.Custom.AudSound{1} = {};
%            SendCustomPulseTrain(1,cumsum(randi(9,1,601))/10000,(rand(1,601)-.5)*20); % White(?) noise on channel 1+2
  %          SendCustomPulseTrain(2,cumsum(randi(9,1,601))/10000,(rand(1,601)-.5)*20);
            
            SendCustomPulseTrain(2,0:.001:.3,(ones(1,301)*3));  % Beep on channel 1+2
            SendCustomPulseTrain(1,0:.001:.3,(ones(1,301)*3));
        end
    end
end

%% Initialize plots
BpodSystem.ProtocolFigures.SideOutcomePlotFig = figure('Position', TaskParameters.Figures.OutcomePlot.Position,'name','Outcome plot','numbertitle','off', 'MenuBar', 'none', 'Resize', 'off');
BpodSystem.GUIHandles.OutcomePlot.HandleOutcome = axes('Position',    [  .055          .15 .91 .3]);
BpodSystem.GUIHandles.OutcomePlot.HandlePsycOlf = axes('Position',    [1*.05          .6  .1  .3], 'Visible', 'off');
BpodSystem.GUIHandles.OutcomePlot.HandlePsycAud = axes('Position',    [2*.05 + 1*.08   .6  .1  .3], 'Visible', 'off');
BpodSystem.GUIHandles.OutcomePlot.HandleTrialRate = axes('Position',  [3*.05 + 2*.08   .6  .1  .3], 'Visible', 'off');
BpodSystem.GUIHandles.OutcomePlot.HandleFix = axes('Position',        [4*.05 + 3*.08   .6  .1  .3], 'Visible', 'off');
BpodSystem.GUIHandles.OutcomePlot.HandleST = axes('Position',         [5*.05 + 4*.08   .6  .1  .3], 'Visible', 'off');
BpodSystem.GUIHandles.OutcomePlot.HandleFeedback = axes('Position',   [6*.05 + 5*.08   .6  .1  .3], 'Visible', 'off');
BpodSystem.GUIHandles.OutcomePlot.HandleVevaiometric = axes('Position',   [7*.05 + 6*.08   .6  .1  .3], 'Visible', 'off');
MainPlot(BpodSystem.GUIHandles.OutcomePlot,'init');
BpodSystem.ProtocolFigures.ParameterGUI.Position = TaskParameters.Figures.ParameterGUI.Position;
%BpodNotebook('init');

%% NIDAQ Initialization and Plots
if TaskParameters.GUI.Photometry
if (TaskParameters.GUI.DbleFibers+TaskParameters.GUI.Isobestic405+TaskParameters.GUI.RedChannel)*TaskParameters.GUI.Photometry >1
    disp('Error - Incorrect photometry recording parameters')
    return
end

Nidaq_photometry('ini');

FigNidaq1=Online_NidaqPlot('ini','470');
if TaskParameters.GUI.DbleFibers || TaskParameters.GUI.Isobestic405 || TaskParameters.GUI.RedChannel
    FigNidaq2=Online_NidaqPlot('ini','channel2');
end
end

%% Main loop
RunSession = true;
iTrial = 1;


while RunSession
    TaskParameters = BpodParameterGUI('sync', TaskParameters);
    BpodSystem.Data.Custom.iTrial = iTrial;
    BpodSystem.Data.Custom.dots{iTrial} = initialize_dots(BpodSystem.Data.Custom.dots{iTrial});
   % InitiateOlfactometer(iTrial);
   % InitiatePsychtoolbox(iTrial);
    
   
   
    BpodSystem.Data.Custom.num_calls = 0;
    %% send state matrix to Bpod
    sma = stateMatrix(iTrial);
    SendStateMatrix(sma);
    
    %% NIDAQ Get nidaq ready to start
    if TaskParameters.GUI.Photometry
        Nidaq_photometry('WaitToStart');
    end
    
  
    RawEvents = RunStateMatrix;
    %ddeexec(channel,'split')
   
    
    %% NIDAQ Stop acquisition and save data in bpod structure
    if TaskParameters.GUI.Photometry
    Nidaq_photometry('Stop');
    [PhotoData,Photo2Data]=Nidaq_photometry('Save');
    BpodSystem.Data.NidaqData{iTrial}=PhotoData;
    if TaskParameters.GUI.DbleFibers || TaskParameters.GUI.RedChannel
        BpodSystem.Data.Nidaq2Data{iTrial}=Photo2Data;
    end
    end
    
   
    
    %% Bpod save
    if ~isempty(fieldnames(RawEvents))
        BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents);
        BpodSystem.Data.TrialSettings(iTrial) = TaskParameters;
        SaveBpodSessionData;
    end
    
    %% pause conditions    
    HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
    if BpodSystem.BeingUsed == 0
        Screen('CloseAll');
        return
    end
    
    if (BpodSystem.Data.TrialStartTimestamp(iTrial) - BpodSystem.Data.TrialStartTimestamp(1))/60 > TaskParameters.GUI.MaxSessionTime
        TaskParameters.GUI.MaxSessionTime = 1000;
        try
            Notify() % optional notify sript in your MATLAB path (not part of protocol)
        catch
        end
        RunProtocol('StartPause')
    end
    updateCustomDataFields(iTrial);
    
 
    
    %% update behavior plots
    MainPlot(BpodSystem.GUIHandles.OutcomePlot,'update',iTrial);
    
   

    
    %% update photometry plots
    if TaskParameters.GUI.Photometry
            
        Alignments = {[],[],[]};
        %Choice
        if ~isnan(BpodSystem.Data.Custom.ChoiceLeft(iTrial)) %Choice
            Alignments{1} = 'start_'; %a little dangerous since generic state name start_ but so far (3/2019) only used for choice
        end
        %Leave
        if ~isnan(BpodSystem.Data.Custom.ChoiceLeft(iTrial)) && (BpodSystem.Data.Custom.ChoiceCorrect(iTrial) == 0 || BpodSystem.Data.Custom.CatchTrial(iTrial) == 1)
            Alignments{2} = BpodSystem.Data.Custom.ResolutionTime(iTrial);
        end
        %Reward
        if  BpodSystem.Data.Custom.Rewarded(iTrial)==1
            Alignments{3} = 'water_';
        end
        
        for k =1:length(Alignments)
             align = Alignments{k};
             if ~isempty(align)
            [currentNidaq1, rawNidaq1]=Online_NidaqDemod(PhotoData(:,1),nidaq.LED1,TaskParameters.GUI.LED1_Freq,TaskParameters.GUI.LED1_Amp,align);
            FigNidaq1=Online_NidaqPlot('update',[],FigNidaq1,currentNidaq1,rawNidaq1,k);
            
            if TaskParameters.GUI.Isobestic405 || TaskParameters.GUI.DbleFibers || TaskParameters.GUI.RedChannel
                if TaskParameters.GUI.Isobestic405
                    [currentNidaq2, rawNidaq2]=Online_NidaqDemod(PhotoData(:,1),nidaq.LED2,TaskParameters.GUI.LED2_Freq,TaskParameters.GUI.LED2_Amp,align);
                elseif TaskParameters.GUI.RedChannel
                    [currentNidaq2, rawNidaq2]=Online_NidaqDemod(Photo2Data(:,1),nidaq.LED2,TaskParameters.GUI.LED2_Freq,TaskParameters.GUI.LED2_Amp,align);
                elseif TaskParameters.GUI.DbleFibers
                    [currentNidaq2, rawNidaq2]=Online_NidaqDemod(Photo2Data(:,1),nidaq.LED2,TaskParameters.GUI.LED1b_Freq,TaskParameters.GUI.LED1b_Amp,align);
                end
                FigNidaq2=Online_NidaqPlot('update',[],FigNidaq2,currentNidaq2,rawNidaq2,k);
            end
             end%if non-empty align
        end%alignment loop
    end%if photometry
    
    disp(BpodSystem.Data.Custom.num_calls);
    iTrial = iTrial + 1;
    


%% photometry check
if TaskParameters.GUI.Photometry
    thismax=max(PhotoData(TaskParameters.GUI.NidaqSamplingRate:TaskParameters.GUI.NidaqSamplingRate*2,1));
    if thismax>4 || thismax<0.3
        disp('WARNING - Something is wrong with fiber #1 - run check-up! - unpause to ignore')
        BpodSystem.Pause=1;
        HandlePauseCondition;
    end
    if TaskParameters.GUI.DbleFibers
    thismax=max(Photo2Data(TaskParameters.GUI.NidaqSamplingRate:TaskParameters.GUI.NidaqSamplingRate*2,1));
    if thismax>4 || thismax<0.3
        disp('WARNING - Something is wrong with fiber #2 - run check-up! - unpause to ignore')
        BpodSystem.Pause=1;
        HandlePauseCondition;
    end
    end
end

end
