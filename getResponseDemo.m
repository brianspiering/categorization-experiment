function [response, rt] = getResponseDemo(stimuli)global window screenRect white black grey xc yc meshX meshY circlespace% correct answercorans = stimuli(1);% Get responsedone = 0;while (done == 0)	begin_time = GetSecs;    FlushEvents    while ~CharAvail end;	key = GetChar;    end_time = GetSecs;	rt = end_time-begin_time;       % Give feedback    if rt > 6000        feedback(3);		Screen('FillRect', window,grey);        Screen('Flip', window);		screen('TextSize', window, 70);		screen('DrawText', window, 'TOO SLOW!! RESPOND FASTER!!', xc-450, yc, black);        Screen('Flip', window);		waitsecs(2);		Screen('FillRect', window,grey);        Screen('Flip', window);		done = 1;         response = 4;    else		if ((key == 'd' & corans == 1) | (key == 'k' & corans == 2))			feedback(1);			done = 1;            response = -1;		elseif ((key == 'd' & corans == 2) | (key == 'k' & corans == 1))     		feedback(-1);					done = 1;            response = -1;		elseif (key ~= 'd' & key ~= 'k')			feedback(3);			Screen('FillRect', window,grey);            Screen('Flip', window);			screen('TextSize', window, 70);			screen('DrawText', window, 'Wrong Key!', xc-200, yc, black);            Screen('Flip', window);			waitsecs(2);			Screen('FillRect', window,grey);            Screen('Flip', window);			done = 1; 		    response = -1;		end    end    % Create response variable    if (key == 'd') & response ~= 4  		response = 1;	elseif  (key == 'k') & response ~= 4 		response = 2;	elseif (key ~= 'd' & key ~= 'k') & response ~= 4		response = 3;      end       	Screen('FillRect', window,grey);    Screen('Flip', window);end