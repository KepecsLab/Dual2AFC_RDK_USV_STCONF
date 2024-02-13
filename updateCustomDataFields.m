function updateCustomDataFields(iTrial)
global BpodSystem
global TaskParameters

%% Standard values
BpodSystem.Data.Custom.ChoiceLeft(iTrial) = NaN;
BpodSystem.Data.Custom.ChoiceCorrect(iTrial) = NaN;
BpodSystem.Data.Custom.ChoiceTime(iTrial) = NaN;
BpodSystem.Data.Custom.Feedback(iTrial) = true;
BpodSystem.Data.Custom.FeedbackTime(iTrial) = NaN;
BpodSystem.Data.Custom.WaitingTime(iTrial) = NaN;
BpodSystem.Data.Custom.FeedbackCheckpoint(iTrial) = NaN;
BpodSystem.Data.Custom.FixBroke(iTrial) = false;
BpodSystem.Data.Custom.EarlyWithdrawal(iTrial) = false;
BpodSystem.Data.Custom.FixDur(iTrial) = NaN;
BpodSystem.Data.Custom.MT(iTrial) = NaN;
BpodSystem.Data.Custom.ST(iTrial) = NaN;
BpodSystem.Data.Custom.ResolutionTime(iTrial) = NaN;
BpodSystem.Data.Custom.Rewarded(iTrial) = false;
BpodSystem.Data.Custom.TrialNumber(iTrial) = iTrial;

%% Checking states and rewriting standard
statesThisTrial = BpodSystem.Data.RawData.OriginalStateNamesByNumber{iTrial}(BpodSystem.Data.RawData.OriginalStateData{iTrial});
%if any(strcmp('stay_Cin',statesThisTrial)) %compute this later
%    BpodSystem.Data.Custom.FixDur(iTrial) = diff(BpodSystem.Data.RawEvents.Trial{end}.States.stay_Cin);
%end
if any(strcmp('stimulus_delivery_min',statesThisTrial))
    if any(strcmp('stimulus_delivery',statesThisTrial))
        BpodSystem.Data.Custom.ST(iTrial) = BpodSystem.Data.RawEvents.Trial{end}.States.stimulus_delivery(1,2) - BpodSystem.Data.RawEvents.Trial{end}.States.stimulus_delivery_min(1,1);
    else
        BpodSystem.Data.Custom.ST(iTrial) = diff(BpodSystem.Data.RawEvents.Trial{end}.States.stimulus_delivery_min);
    end
end

if any(strncmp('unRewarded',statesThisTrial, 10))
    BpodSystem.Data.Custom.ChoiceCorrect(iTrial) = 0;
elseif any(strncmp('Rewarded',statesThisTrial, 8))
    BpodSystem.Data.Custom.ChoiceCorrect(iTrial) = 1;
end
if any(strcmp('start_Lin',statesThisTrial))
    BpodSystem.Data.Custom.ChoiceTime(iTrial) = BpodSystem.Data.RawEvents.Trial{end}.States.start_Lin(1);
    BpodSystem.Data.Custom.ChoiceLeft(iTrial) = 0;
elseif any(strcmp('start_Rin',statesThisTrial))
    BpodSystem.Data.Custom.ChoiceLeft(iTrial) = 1;
    BpodSystem.Data.Custom.ChoiceTime(iTrial) = BpodSystem.Data.RawEvents.Trial{end}.States.start_Rin(1);
end
if any(strcmp('broke_fixation',statesThisTrial))
    BpodSystem.Data.Custom.FixBroke(iTrial) = true;
elseif any(strcmp('early_withdrawal',statesThisTrial))
    BpodSystem.Data.Custom.EarlyWithdrawal(iTrial) = true;
end
if any(strcmp('missed_choice',statesThisTrial))
    BpodSystem.Data.Custom.Feedback(iTrial) = false;
end
if any(strcmp('skipped_feedback',statesThisTrial))
    BpodSystem.Data.Custom.Feedback(iTrial) = false;
end
if any(strcmp('water_L',statesThisTrial))
    BpodSystem.Data.Custom.Rewarded(iTrial) = true;
    FeedbackPortTimes = BpodSystem.Data.RawEvents.Trial{end}.States.water_L;
    BpodSystem.Data.Custom.ResolutionTime(iTrial)  = FeedbackPortTimes(end,end);
    BpodSystem.Data.Custom.RewardMagnitude(iTrial) = TaskParameters.GUI.BL_ra; 
end
if any(strcmp('water_C',statesThisTrial))
    BpodSystem.Data.Custom.Rewarded(iTrial) = true;
    FeedbackPortTimes = BpodSystem.Data.RawEvents.Trial{end}.States.water_C;
    BpodSystem.Data.Custom.ResolutionTime(iTrial)  = FeedbackPortTimes(end,end);
    BpodSystem.Data.Custom.RewardMagnitude(iTrial) = TaskParameters.GUI.BC_ra; 
end
if any(strcmp('water_R',statesThisTrial))
    BpodSystem.Data.Custom.Rewarded(iTrial) = true;
    FeedbackPortTimes = BpodSystem.Data.RawEvents.Trial{end}.States.water_R;
    BpodSystem.Data.Custom.ResolutionTime(iTrial)  = FeedbackPortTimes(end,end);
    BpodSystem.Data.Custom.RewardMagnitude(iTrial) = TaskParameters.GUI.BR_ra; 
end

if any(strcmp('Rewarded_Bin_Wait3',statesThisTrial))
    FeedbackPortTimes = BpodSystem.Data.RawEvents.Trial{end}.States.Rewarded_Bin_Wait3;
    BpodSystem.Data.Custom.FeedbackDelay(iTrial) = TaskParameters.GUI.FeedbackDelay1 + TaskParameters.GUI.FeedbackDelay2 + TaskParameters.GUI.FeedbackDelay3;
    BpodSystem.Data.Custom.FeedbackTime(iTrial) =  FeedbackPortTimes(1);
    BpodSystem.Data.Custom.WaitingTime(iTrial) =  FeedbackPortTimes(1) - BpodSystem.Data.Custom.ChoiceTime(iTrial);
    BpodSystem.Data.Custom.FeedbackCheckpoint(iTrial) = 3;
    BpodSystem.Data.Custom.ChoiceCorrect(iTrial) = 1;
    
elseif any(strcmp('Rewarded_Bin_Wait2',statesThisTrial))
    FeedbackPortTimes = BpodSystem.Data.RawEvents.Trial{end}.States.Rewarded_Bin_Wait2;
    BpodSystem.Data.Custom.FeedbackDelay(iTrial) = TaskParameters.GUI.FeedbackDelay1 + TaskParameters.GUI.FeedbackDelay2;
    BpodSystem.Data.Custom.FeedbackTime(iTrial) =  FeedbackPortTimes(1);
    BpodSystem.Data.Custom.WaitingTime(iTrial) =  FeedbackPortTimes(1) - BpodSystem.Data.Custom.ChoiceTime(iTrial);
    BpodSystem.Data.Custom.FeedbackCheckpoint(iTrial) = 2;
    BpodSystem.Data.Custom.ChoiceCorrect(iTrial) = 1;
    
elseif any(strcmp('Rewarded_Bin_Wait1',statesThisTrial))
    FeedbackPortTimes = BpodSystem.Data.RawEvents.Trial{end}.States.Rewarded_Bin_Wait1;
    BpodSystem.Data.Custom.FeedbackDelay(iTrial) = TaskParameters.GUI.FeedbackDelay1;
    BpodSystem.Data.Custom.FeedbackTime(iTrial) =  FeedbackPortTimes(1);
    BpodSystem.Data.Custom.WaitingTime(iTrial) =  FeedbackPortTimes(1) - BpodSystem.Data.Custom.ChoiceTime(iTrial);
    BpodSystem.Data.Custom.FeedbackCheckpoint(iTrial) = 1;
    BpodSystem.Data.Custom.ChoiceCorrect(iTrial) = 1;
end
if any(strcmp('unRewarded_Bin_Wait3',statesThisTrial))
    FeedbackPortTimes = BpodSystem.Data.RawEvents.Trial{end}.States.unRewarded_Bin_Wait3;
    BpodSystem.Data.Custom.FeedbackDelay(iTrial) =TaskParameters.GUI.FeedbackDelay1 + TaskParameters.GUI.FeedbackDelay2+ TaskParameters.GUI.FeedbackDelay3;
    BpodSystem.Data.Custom.FeedbackTime(iTrial) =  FeedbackPortTimes(1);
    BpodSystem.Data.Custom.WaitingTime(iTrial) =  FeedbackPortTimes(1) - BpodSystem.Data.Custom.ChoiceTime(iTrial);
    BpodSystem.Data.Custom.FeedbackCheckpoint(iTrial) = 3;
    BpodSystem.Data.Custom.ChoiceCorrect(iTrial) = 0;
    BpodSystem.Data.Custom.RewardMagnitude(iTrial) = 0;  
end
if any(strcmp('unRewarded_Bin_Wait2',statesThisTrial))
    FeedbackPortTimes = BpodSystem.Data.RawEvents.Trial{end}.States.unRewarded_Bin_Wait2;
    BpodSystem.Data.Custom.FeedbackDelay(iTrial) =TaskParameters.GUI.FeedbackDelay1 + TaskParameters.GUI.FeedbackDelay2;
    BpodSystem.Data.Custom.FeedbackTime(iTrial) =  FeedbackPortTimes(1);
    BpodSystem.Data.Custom.WaitingTime(iTrial) =  FeedbackPortTimes(1) - BpodSystem.Data.Custom.ChoiceTime(iTrial);
    BpodSystem.Data.Custom.FeedbackCheckpoint(iTrial) = 2;
    BpodSystem.Data.Custom.ChoiceCorrect(iTrial) = 0;
    BpodSystem.Data.Custom.RewardMagnitude(iTrial) = 0;  
end

if any(strcmp('unRewarded_Bin_Wait1',statesThisTrial))
    FeedbackPortTimes = BpodSystem.Data.RawEvents.Trial{end}.States.unRewarded_Bin_Wait1;
    BpodSystem.Data.Custom.FeedbackDelay(iTrial) = TaskParameters.GUI.FeedbackDelay1;
    BpodSystem.Data.Custom.FeedbackTime(iTrial) =  FeedbackPortTimes(1);
    BpodSystem.Data.Custom.WaitingTime(iTrial) =  FeedbackPortTimes(1) - BpodSystem.Data.Custom.ChoiceTime(iTrial);
    BpodSystem.Data.Custom.FeedbackCheckpoint(iTrial) = 1;
    BpodSystem.Data.Custom.ChoiceCorrect(iTrial) = 0;
    BpodSystem.Data.Custom.RewardMagnitude(iTrial) = 0;  
end

%% State-independent fields
BpodSystem.Data.Custom.StimDelay(iTrial) = TaskParameters.GUI.StimDelay;

BpodSystem.Data.Custom.MinSample(iTrial) = TaskParameters.GUI.MinSample;

if BpodSystem.Data.Custom.BlockNumber(iTrial) < max(TaskParameters.GUI.BlockTable.BlockNumber) % Not final block
    if BpodSystem.Data.Custom.BlockTrial(iTrial) >= TaskParameters.GUI.BlockTable.BlockLen(TaskParameters.GUI.BlockTable.BlockNumber...
            ==BpodSystem.Data.Custom.BlockNumber(iTrial)) % Block transition
        BpodSystem.Data.Custom.BlockNumber(iTrial+1) = BpodSystem.Data.Custom.BlockNumber(iTrial) + 1;
        BpodSystem.Data.Custom.BlockTrial(iTrial+1) = 1;
    else
        BpodSystem.Data.Custom.BlockNumber(iTrial+1) = BpodSystem.Data.Custom.BlockNumber(iTrial);
        BpodSystem.Data.Custom.BlockTrial(iTrial+1) = BpodSystem.Data.Custom.BlockTrial(iTrial) + 1;
    end
else % Final block
    BpodSystem.Data.Custom.BlockTrial(iTrial+1) = BpodSystem.Data.Custom.BlockTrial(iTrial) + 1;
    BpodSystem.Data.Custom.BlockNumber(iTrial+1) = BpodSystem.Data.Custom.BlockNumber(iTrial);
end


%% Updating Delays
%stimulus delay
if TaskParameters.GUI.StimDelayAutoincrement
    if BpodSystem.Data.Custom.FixBroke(iTrial)
        TaskParameters.GUI.StimDelay = max(TaskParameters.GUI.StimDelayMin,...
            min(TaskParameters.GUI.StimDelayMax,BpodSystem.Data.Custom.StimDelay(iTrial)-TaskParameters.GUI.StimDelayDecr));
    else
        TaskParameters.GUI.StimDelay = min(TaskParameters.GUI.StimDelayMax,...
            max(TaskParameters.GUI.StimDelayMin,BpodSystem.Data.Custom.StimDelay(iTrial)+TaskParameters.GUI.StimDelayIncr));
    end
else
    if ~BpodSystem.Data.Custom.FixBroke(iTrial)
        TaskParameters.GUI.StimDelay = random('unif',TaskParameters.GUI.StimDelayMin,TaskParameters.GUI.StimDelayMax);
    else
        TaskParameters.GUI.StimDelay = random('unif',TaskParameters.GUI.StimDelayMin,TaskParameters.GUI.StimDelayMax);
    end
end

%min sampling time auditory
if TaskParameters.GUI.MinSampleAutoincrement
    History = 50;
    Crit = 0.8;
    if sum(BpodSystem.Data.Custom.AuditoryTrial)<10
        ConsiderTrials = iTrial;
    else
        idxStart = find(cumsum(BpodSystem.Data.Custom.AuditoryTrial(iTrial:-1:1))>=History,1,'first');
        if isempty(idxStart)
            ConsiderTrials = 1:iTrial;
        else
            ConsiderTrials = iTrial-idxStart+1:iTrial;
        end
    end
    ConsiderTrials = ConsiderTrials((~isnan(BpodSystem.Data.Custom.ChoiceLeft(ConsiderTrials))...
        |BpodSystem.Data.Custom.EarlyWithdrawal(ConsiderTrials))&BpodSystem.Data.Custom.AuditoryTrial(ConsiderTrials)); %choice + early withdrawal + auditory trials
    if ~isempty(ConsiderTrials) && BpodSystem.Data.Custom.AuditoryTrial(iTrial)
        if mean(BpodSystem.Data.Custom.ST(ConsiderTrials)>TaskParameters.GUI.MinSample) > Crit
            if ~BpodSystem.Data.Custom.EarlyWithdrawal(iTrial)
                TaskParameters.GUI.MinSample = min(TaskParameters.GUI.MinSampleMax,...
                    max(TaskParameters.GUI.MinSampleMin,BpodSystem.Data.Custom.MinSample(iTrial) + TaskParameters.GUI.MinSampleIncr));
            end
        elseif mean(BpodSystem.Data.Custom.ST(ConsiderTrials)>TaskParameters.GUI.MinSample) < Crit/2
            if BpodSystem.Data.Custom.EarlyWithdrawal(iTrial)
                TaskParameters.GUI.MinSample = max(TaskParameters.GUI.MinSampleMin,...
                    min(TaskParameters.GUI.MinSampleMax,BpodSystem.Data.Custom.MinSample(iTrial) - TaskParameters.GUI.MinSampleDecr));
            end
        else
            TaskParameters.GUI.MinSample = max(TaskParameters.GUI.MinSampleMin,...
                min(TaskParameters.GUI.MinSampleMax,BpodSystem.Data.Custom.MinSample(iTrial)));
        end
    else
        TaskParameters.GUI.MinSample = max(TaskParameters.GUI.MinSampleMin,...
            min(TaskParameters.GUI.MinSampleMax,BpodSystem.Data.Custom.MinSample(iTrial)));
    end
else
    stim_min = TaskParameters.GUI.MinSampleMin;
    stim_max = TaskParameters.GUI.MinSampleMax;
    wait_min = TaskParameters.GUI.StimDelayMin;
    wait_max = TaskParameters.GUI.StimDelayMax;
    TaskParameters.GUI.MinSample = stim_min + (stim_max - stim_min)*rand(1);
    TaskParameters.GUI.StimDelay = wait_min + (wait_max - wait_min)*rand(1);
end

%% Drawing future trials
dmin  = TaskParameters.GUI.FeedbackDelay1min;
dmax = TaskParameters.GUI.FeedbackDelay1max;
TaskParameters.GUI.FeedbackDelay1 = dmin + (dmax - dmin)*rand(1);

dmin  = TaskParameters.GUI.FeedbackDelay2min;
dmax = TaskParameters.GUI.FeedbackDelay2max;
TaskParameters.GUI.FeedbackDelay2 = dmin + (dmax - dmin)*rand(1);

dmin  = TaskParameters.GUI.FeedbackDelay3min;
dmax = TaskParameters.GUI.FeedbackDelay3max;
TaskParameters.GUI.FeedbackDelay3 = dmin + (dmax - dmin)*rand(1);

%determine if catch trial
BpodSystem.Data.Custom.CatchTrial(iTrial+1) = true;


%create future trials
if iTrial > 0%numel(BpodSystem.Data.Custom.DV) - 2
    
    lastidx = numel(BpodSystem.Data.Custom.DV);
    newAuditoryTrial = rand(1,5) < TaskParameters.GUI.PercentAuditory;
    BpodSystem.Data.Custom.AuditoryTrial = [BpodSystem.Data.Custom.AuditoryTrial,newAuditoryTrial];
    if TaskParameters.GUI.StimulusType == 1 %click stimuli
        BpodSystem.Data.Custom.ClickTask = [BpodSystem.Data.Custom.ClickTask ,true(1,5)];
    elseif TaskParameters.GUI.StimulusType == 2 %freq stimuli
        BpodSystem.Data.Custom.ClickTask = [BpodSystem.Data.Custom.ClickTask ,false(1,5)];
    end
    
    switch TaskParameters.GUIMeta.TrialSelection.String{TaskParameters.GUI.TrialSelection}
        case 'Flat'
            TaskParameters.GUI.LeftBias = 0.5;
        case 'Manual'
            
        case 'Competitive'
            ndxValid = ~isnan(BpodSystem.Data.Custom.ChoiceLeft); ndxValid = ndxValid(:);
            for iStim = reshape(TaskParameters.GUI.OdorTable.OdorFracA,1,[])
                ndxOdor = BpodSystem.Data.Custom.OdorFracA(1:iTrial) == iStim; ndxOdor = ndxOdor(:);
                if sum(ndxOdor&ndxValid) >= 8 % P(odor) = fraction of completed but unrewarded trials.
                    TaskParameters.GUI.OdorTable.OdorProb(iStim == TaskParameters.GUI.OdorTable.OdorFracA) = ...
                        sum(BpodSystem.Data.Custom.Rewarded(ndxOdor&ndxValid)==0)/sum(ndxOdor&ndxValid);
                else % If too few trials of this type, P(odor) is arbitrary non-zero.
                    TaskParameters.GUI.OdorTable.OdorProb(iStim == TaskParameters.GUI.OdorTable.OdorFracA) = 0.5;
                end
            end
            if any(TaskParameters.GUI.OdorTable.OdorProb==0)
                TaskParameters.GUI.OdorTable.OdorProb(TaskParameters.GUI.OdorTable.OdorProb==0) = ...
                    min(TaskParameters.GUI.OdorTable.OdorProb(TaskParameters.GUI.OdorTable.OdorProb>0))/2;
            end
            TaskParameters.GUI.LeftBiasAud = 0.5;%auditory not implemented
        case 'BiasCorrecting' % Favors side with fewer rewards. Contrast drawn flat & independently.
            %olfactory
            ndxRewd = BpodSystem.Data.Custom.Rewarded(1:iTrial) == 1 & ~BpodSystem.Data.Custom.AuditoryTrial(1:iTrial); ndxRewd = ndxRewd(:);
            %auditory
            ndxRewd = BpodSystem.Data.Custom.Rewarded(1:iTrial) == 1 & BpodSystem.Data.Custom.AuditoryTrial(1:iTrial);
            if sum(ndxRewd)>10
                TaskParameters.GUI.LeftBias = sum(BpodSystem.Data.Custom.LeftRewarded(1:iTrial)==1&ndxRewd)/sum(ndxRewd);
            else
                TaskParameters.GUI.LeftBias = 0.5;
            end
            if sum(ndxRewd)>10
                TaskParameters.GUI.Aud_Levels.AudPFrac(TaskParameters.GUI.Aud_Levels.AudFracHigh<50) = TaskParameters.GUI.LeftBiasAud;
                TaskParameters.GUI.Aud_Levels.AudPFrac(TaskParameters.GUI.Aud_Levels.AudFracHigh>50) = 1 - TaskParameters.GUI.LeftBiasAud;
            end
    end
    
end
    switch TaskParameters.GUI.StimulusType
        case 1 %click stimuli
            
            if iTrial > TaskParameters.GUI.StartEasyTrials
                AuditoryAlpha = TaskParameters.GUI.AuditoryAlpha;
            else
                AuditoryAlpha = TaskParameters.GUI.AuditoryAlpha/4;
            end
            BetaRatio = (1 - min(0.9,max(0.1,TaskParameters.GUI.BiasAud))) / min(0.9,max(0.1,TaskParameters.GUI.LeftBiasAud)); %use a = ratio*b to yield E[X] = LeftBiasAud using Beta(a,b) pdf
            %cut off between 0.1-0.9 to prevent extreme values (only one side) and div by zero
            BetaA =  (2*AuditoryAlpha*BetaRatio) / (1+BetaRatio); %make a,b symmetric around AuditoryAlpha to make B symmetric
            BetaB = (AuditoryAlpha-BetaA) + AuditoryAlpha;
            for a = 1:5
                if BpodSystem.Data.Custom.AuditoryTrial(lastidx+a)
                    if rand(1,1) < TaskParameters.GUI.Percent50Fifty && iTrial > TaskParameters.GUI.StartEasyTrials
                        BpodSystem.Data.Custom.AuditoryOmega(lastidx+a) = 0.5;
                    else
                        BpodSystem.Data.Custom.AuditoryOmega(lastidx+a) = betarnd(max(0,BetaA),max(0,BetaB),1,1); %prevent negative parameters
                    end
                    BpodSystem.Data.Custom.LeftClickRate(lastidx+a) = round(BpodSystem.Data.Custom.AuditoryOmega(lastidx+a).*TaskParameters.GUI.SumRates);
                    BpodSystem.Data.Custom.RightClickRate(lastidx+a) = round((1-BpodSystem.Data.Custom.AuditoryOmega(lastidx+a)).*TaskParameters.GUI.SumRates);
                    stim_ok=false;
                    while ~stim_ok %make sure 50/50 are true 50/50 trials
                        BpodSystem.Data.Custom.LeftClickTrain{lastidx+a} = GeneratePoissonClickTrain(BpodSystem.Data.Custom.LeftClickRate(lastidx+a), TaskParameters.GUI.StimulusTime);
                        BpodSystem.Data.Custom.RightClickTrain{lastidx+a} = GeneratePoissonClickTrain(BpodSystem.Data.Custom.RightClickRate(lastidx+a), TaskParameters.GUI.StimulusTime);
                        if BpodSystem.Data.Custom.AuditoryOmega(lastidx+a) == 0.5
                            if length(BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}) == length(BpodSystem.Data.Custom.RightClickTrain{lastidx+a})
                                stim_ok=true;
                            end
                        else
                            stim_ok=true;
                        end
                    end
                    %correct left/right click train
                    if ~isempty(BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}) && ~isempty(BpodSystem.Data.Custom.RightClickTrain{lastidx+a})
                        BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}(1) = min(BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}(1),BpodSystem.Data.Custom.RightClickTrain{lastidx+a}(1));
                        BpodSystem.Data.Custom.RightClickTrain{lastidx+a}(1) = min(BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}(1),BpodSystem.Data.Custom.RightClickTrain{lastidx+a}(1));
                    elseif  isempty(BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}) && ~isempty(BpodSystem.Data.Custom.RightClickTrain{lastidx+a})
                        BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}(1) = BpodSystem.Data.Custom.RightClickTrain{lastidx+a}(1);
                    elseif ~isempty(BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}) &&  isempty(BpodSystem.Data.Custom.RightClickTrain{lastidx+a})
                        BpodSystem.Data.Custom.RightClickTrain{lastidx+a}(1) = BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}(1);
                    else
                        BpodSystem.Data.Custom.LeftClickTrain{lastidx+a} = round(1/BpodSystem.Data.Custom.LeftClickRate*10000)/10000;
                        BpodSystem.Data.Custom.RightClickTrain{lastidx+a} = round(1/BpodSystem.Data.Custom.RightClickRate*10000)/10000;
                    end
                    if length(BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}) > length(BpodSystem.Data.Custom.RightClickTrain{lastidx+a})
                        BpodSystem.Data.Custom.LeftRewarded(lastidx+a) = 1;
                    elseif length(BpodSystem.Data.Custom.LeftClickTrain{lastidx+a}) < length(BpodSystem.Data.Custom.RightClickTrain{lastidx+a})
                        BpodSystem.Data.Custom.LeftRewarded(lastidx+a) = 0;
                    else
                        BpodSystem.Data.Custom.LeftRewarded(lastidx+a) = rand<0.5;
                    end
                else
                    BpodSystem.Data.Custom.AuditoryOmega(lastidx+a) = NaN;
                    BpodSystem.Data.Custom.LeftClickRate(lastidx+a) = NaN;
                    BpodSystem.Data.Custom.RightClickRate(lastidx+a) = NaN;
                    BpodSystem.Data.Custom.LeftRewarded(lastidx+a) = NaN;
                    BpodSystem.Data.Custom.LeftClickTrain{lastidx+a} = [];
                    BpodSystem.Data.Custom.RightClickTrain{lastidx+a} = [];
                end%if auditory
            end%for a=1:5
            
        case 2 %freq stimuli
            
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
            if iTrial > TaskParameters.GUI.StartEasyTrials
                newFracHigh = randsample(TaskParameters.GUI.Aud_Levels.AudFracHigh,5,1,TaskParameters.GUI.Aud_Levels.AudPFrac)';
                %include Fifty50 Trials
                NewFifty50 = rand(5,1) < TaskParameters.GUI.Percent50Fifty;
                newFracHigh(NewFifty50) = 50;
            else
                EasyProb = zeros(numel(TaskParameters.GUI.Aud_Levels.AudPFrac),1);
                EasyProb(1) = 0.5; EasyProb(end)=0.5;
                newFracHigh = randsample(TaskParameters.GUI.Aud_Levels.AudFracHigh,5,1,EasyProb)';
            end
            
            newCloud = cell(1,5);
            newSound = cell(1,5);
            for a = 1:5
                if BpodSystem.Data.Custom.AuditoryTrial(lastidx+a)
                    [Sound, Cloud, ~] = GenerateToneCloudDual(newFracHigh(a)/100, StimulusSettings);
                    newCloud{a} = Cloud;
                    newSound{a} = Sound;
                end
            end
            
            LeftRewarded = newFracHigh>50;
            LeftRewarded (newFracHigh==050) = rand<0.5;
            newFracHigh(~newAuditoryTrial) = nan(sum(~newAuditoryTrial),1);
            BpodSystem.Data.Custom.AudFracHigh = [BpodSystem.Data.Custom.AudFracHigh, newFracHigh];
            BpodSystem.Data.Custom.AudCloud = [BpodSystem.Data.Custom.AudCloud, newCloud];
            BpodSystem.Data.Custom.AudSound = [BpodSystem.Data.Custom.AudSound, newSound];
            BpodSystem.Data.Custom.LeftRewarded = [BpodSystem.Data.Custom.LeftRewarded, LeftRewarded];
        case 3 %dots
            %for a = 1:2
                
            if iTrial > 30;
               % TaskParameters.GUI.LeftBiasAud = nansum(BpodSystem.Data.Custom.ChoiceLeft(iTrial - 30:iTrial))/sum(~isnan(BpodSystem.Data.Custom.ChoiceLeft(iTrial-30:iTrial)));
                TaskParameters.GUI.LeftBias = 0.5;

            else
                TaskParameters.GUI.LeftBias = 0.5;
            end

            b = iTrial+1;

            num_trials=1; %(precompute the dots for 2000 trials)
            BpodSystem.Data.Custom.Coherence(b) = compute_coherence(num_trials,TaskParameters.GUI.coherence_type);
            BpodSystem.Data.Custom.close_priors = .5;%[1- TaskParameters.GUI.LeftBiasAud]; %get rid of bias correctrion

            correct_side =...
                        compute_trial_side(BpodSystem.Data.Custom.close_priors);

            BpodSystem.Data.Custom.correct_side(b) = correct_side;
            dots = BpodSystem.Data.Custom.dots;
            dots{b} = dots{1}; %copy over non-trial specific fields! 

            dots{b}.direction = compute_direction(BpodSystem.Data.Custom.correct_side(b)); % correct direction for each trial, either 90 or 270

            [dirs, dx, dy] =...
                compute_dirs(num_trials, dots{b}.nDots, BpodSystem.Data.Custom.Coherence(b),...
                dots{b}.direction, dots{b}.speed,60);

            dots{b}.dirs = dirs;
            dots{b}.dx = dx;
            dots{b}.dy = dy;

            BpodSystem.Data.Custom.dots = dots;

            BpodSystem.Data.Custom.LeftRewarded(b)= BpodSystem.Data.Custom.correct_side(b) < 0;
            BpodSystem.Data.Custom.DV(b) = BpodSystem.Data.Custom.Coherence(b)*BpodSystem.Data.Custom.correct_side(b);

          %  end
    end %switch/case auditory stimulus type
    

TaskParameters.Figures.OutcomePlot.Position = BpodSystem.ProtocolFigures.SideOutcomePlotFig.Position;
TaskParameters.Figures.ParameterGUI.Position = BpodSystem.ProtocolFigures.ParameterGUI.Position;
  
end%if trial > - 5


