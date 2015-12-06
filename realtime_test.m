% Fall 2015 ECE 2200, Shazam Competition - Realtime test
% Instruction:
% The program will first ask you to write your NetIDs. Please enter in form
% of [netID1]_[netID2].
% Then the program will automatically run your Shazam program on the following 3 clips (but not restricted to this order):
% 1. Randomly chosen song without noise
% 2. Randomly chosen song added with 2000 Hz sinusoid noise
% 3. Randomly chosen song added with random frequency sinusoid noise
%
% As the program compltes, it will save the following parameters:
% 1. credit: Realtime test credit (max: 0.3, min: 0.0)
% 2. correct: names of a song that identified correctly
% 3. incorrect: names of a song that identified incorrectly
% 4. noDecision: names of a song that identified as no-decision
% 5. time: the time in second that the Shazam program took for running each test clip
% clips.
% You can load [netID1]_[netID2]_realtime_test.mat to check your
% performance.
clear all
close all

% Ask two NetIDs of Shazam project that is being tested
prompt = 'What are the NetIDs? Please enter in form of: dk683_ml634\n==> ';
netId = input(prompt,'s');

% Parameters
testOption = 2;% Realtime test option
credit = 0;% Realtime test credit
correct = {};% Array for saving names of a song that identified correctly
incorrect = {};% Array for saving names of a song that identified incorrectly
noDecision = {};% Array for saving names of a song that identified as no-decision
time = {};

% Read files in directory "clipRealTime/"
files = what('clipRealTime');
matFiles = files.mat;
% Perform Shazam on 20 test clips
for index = 1:length(matFiles)
	% Read test clip
    fileName = matFiles{index}
    toRead = ['clipRealTime/',fileName];
	load(toRead,'-mat');

    % Play test clip
    player = audioplayer(y,Fs)
    play(player); tic;% Play music and measure time

    identifiedSong = main(testOption,toRead);% Identified clip by Shazam
    tempTime = toc; pause(player);% Stop music and time
    time = [time,tempTime];

    % if time is more than 30 seconds, than count as incorrect
	if (tempTime > 30)
        credit = credit + 0;
        incorrect = [incorrect,fileName];
	else
	    % For correct
	    if (strcmp(char(identifiedSong), fileName)) 
	        credit = credit + 1;
	        correct = [correct,fileName];
	    % For no-decision
	    elseif (strcmp(char(identifiedSong),'no-decision'))
	        credit = credit + 0.5;
	        noDecision = [noDecision,fileName];
	    % For incorrect
        else
	        credit = credit + 0;
	        incorrect = [incorrect,fileName];
	    end 
	end
end

% Calculate credit
credit = 0.3 * (credit/length(matFiles)); % max: 0.3, min: 0
toSaveMat = [netId,'_realtime_test.mat'];

save(toSaveMat,'credit','correct','incorrect','noDecision','time');