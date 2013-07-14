% CategorizationExperiment is an example of a categorization experiment
% Present a stimulus, record response, and provide feedback
% Repeat ad nauseum 
%
% Depends on Psychtoolbox, http://psychtoolbox.org/
%
% Brian J. Spiering, 01/11/09, orginal version
% Brian J. Spieirng, 07/10/13, minor revisions for GitHub commit

% TODO:
% reduce number of global variables
% add more functions (cross hair and intertrial interval)
% switch to OOP

%% General setup 
clc 
clear all
close all
rand('seed',sum(100*clock))

%% Setup experiment
global window screenRect white black grey xc yc meshX meshY circlespace correct incorrect wrong_key stim_pixels visual_angle_in_degrees dist_to_Screen_cm locationflag
nTrials = 500;                          % number of trials
load stimuli.dat;                       % format [category_membership bar_width bar_tilt examplar_number]; stimuli structure is "unstructured,"
correct = wavread('correct.wav');       % load auditory feedback
incorrect = wavread('incorrect.wav');   % load auditory feedback
wrong_key = wavread('wrong_key.wav');   % load auditory feedback          
visual_angle_in_degrees = 6;            % degrees of visual angle for the stimulus
dist_to_Screen_cm = 76;                 % how far the subject will be from the display
stim_pixels = 392.45;                   % the size of the stimulus in pixels
warning('off')                          % suppress warning messages
Screen('Preference', 'SkipSyncTests',1);
PsychJavaTrouble                      % pscyhtoolbox sometimes causes trouble
home                                    % moving warning message off Screen
disp('A categorization experiment.');    % Say hello

%% Get Subject Number
subjectNumber = input('    Subject Number (999 is for debugging): '); % subject # 999 is for debugging
if (subjectNumber == 999)
    nDemoTrials = 1;
    trials = 1;
else
    nDemoTrials = 5;
    trials = 500;
end

%% Create data file
if (ismac == 1) 
    outfile = [cd '/data/sub' num2str(subjectNumber) 'traindata.dat']; % mac
elseif (ismac == 0) 
    outfile = [cd '\data\sub' num2str(subjectNumber) 'traindata.dat']; % pc
end
if (exist(outfile)) & (subjectNumber ~= 999) % subject number 999 is for debugging
	error(['The file ' outfile ' already exists.']);
end
fid = fopen([outfile],'w');

%% Setup Psychtoolbox
screenNumbers = Screen('Screens');           % get a vector of screenNumbers
currentScreenNumber = max(screenNumbers);    % select highest number screen
[window,screenRect] = Screen('OpenWindow',currentScreenNumber,0);
% hideCursor;
% ListenChar(2); % turn off keyboard
% Define colors
white = WhiteIndex(window);
black = BlackIndex(window);
grey = [(white+black)/2 (white+black)/2 (white+black)/2];
% Define center
xc = screenRect(3)/2; 
yc = screenRect(4)/2; 
% Make meshX meshY circlespace
[circlespace,meshX,meshY] = makeCirclespace();
% Clear Screen to grey background:
Screen('FillRect', window,grey);
Screen('Flip', window);

% Start demo instructions
Screen('TextSize', window, 30);
Screen('DrawText', window, 'Press any key to begin demo.', xc-240,  yc, black);
Screen('Flip', window); 
FlushEvents 
while ~CharAvail end;

%% Demo
demoStimuli = [ 2   22.7013   28.2200    1.0000
                1    9.0572   48.9100    2.0000
                2   74.9086   44.9500    3.0000
                1   32.4620   22.5100    4.0000
                1   22.7013   28.2200    5.0000];
            
for demoTrial = 1:nDemoTrials
    
    % Present cross hair
    Screen('TextSize', window, 20);
    Screen('DrawText', window, '+', xc, yc ,black);
    Screen('Flip', window);
    WaitSecs(1);
    
    % Draw categorization stimulus
    showDisc(demoStimuli(demoTrial,:));
    
    % Get Responses
    [response rt] = getResponseDemo(demoStimuli(demoTrial,:));
    
    % Wait for next trial to start
    Screen('FillRect', window, grey);  % clear Screen to grey background
    Screen('Flip', window);           % show it
    waitsecs(.5);                     % intertrial interval
end

%% Instructions
Screen('TextSize', window, 30);
Screen('DrawText', window, 'If you have any questions,', xc-200,  yc-75, black);
Screen('DrawText', window, 'ask the experimenter.', xc-150,  yc, black);
Screen('DrawText', window, 'Otherwise press any key to begin.', xc-240,  yc+75, black);
Screen('Flip', window); 
FlushEvents
while ~CharAvail end;

%% Experimential trials 
for trial = 1:ntrials

    % Present cross hair
    Screen('TextSize', window, 20);
    Screen('DrawText', window, '+', xc, yc ,black);
    Screen('Flip', window);
    WaitSecs(1);

    % Draw categorization stimulus
    showDisc(stimuli(trial,:),training_history(trial));
    
    % Get response
    [response rt] = getResponse(stimuli(trial,:));

    % Write data to file
    % data=[trial corrcat orientation spatialfreq response RT traininghistory stimuli number]' );
    data(trial,:) = [trial stimuli(trial,1) stimuli(trial,2) stimuli(trial,3 ) response rt training_history(trial) stimuli(trial,4 )];
    fprintf(fid,'%3i %i %3.2f %1.4f %i %1.4f %i %i\n',data(trial,:)' );
   
    % Setup for next trial
    if (rem(trial,50) ~= 0) % Most trials
        % Wait for next trial to start
        Screen('FillRect', window,grey);  % clear Screen to grey background
        Screen('Flip', window);           % show it
        waitsecs(.5);                     % intertrial interval
    elseif (rem(trial,50) == 0) % End of block message
        Screen('TextSize', window, 30);
        Screen('DrawText', window, 'End of Block,', xc-100,  yc-75, black);
        Screen('DrawText', window, 'Press any key to begin next block.', xc-240,  yc+75, black);
        Screen('Flip', window); 
        FlushEvents
        while ~CharAvail end;
    end
end

%% End of experiment instructions
Screen('TextSize', window, 30);
Screen('DrawText', window, 'Thank you for being awesome.', xc-225,  yc-75, black);
Screen('DrawText', window, 'Please get the experimenter.', xc-225,  yc, black);
Screen('Flip', window); 
FlushEvents
while ~CharAvail end;

%% Close things up
fclose(fid); % Close response data file. 
ListenChar(0);
ShowCursor;
Screen('CloseAll');
clc