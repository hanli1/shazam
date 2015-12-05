% Fall 2015 ECE 2200, Shazam Competition - Database test
% Instruction:
% The program will first ask you to write your NetIDs. Please enter in form
% of [netID1]_[netID2]. 
% Then the program will automatically run your Shazam program on 20 clips.
% As the program compltes, it will save the following parameters:
% 1. credit: Database test credit (max: 0.6, min: 0.0)
% 2. correct: names of a song that identified correctly
% 3. incorrect: names of a song that identified incorrectly
% 4. noDecision: names of a song that identified as no-decision
% 5. time: the time in second that the Shazam program took for running 20
% clips.
% You can load [netID1]_[netID2]_database_test.mat to check your
% performance.
clear all
close all

% Ask two NetIDs of Shazam project that is being tested
prompt = 'What are the NetIDs? Please enter in form of: dk683_ml634\n==> ';
netId = input(prompt,'s');

% Start measuing time
tic

% Parameters
testOption = 1;% Database test option
credit = 0;% Database test credit
correct = {};% Array for saving names of a song that identified correctly
incorrect = {};% Array for saving names of a song that identified incorrectly
noDecision = {};% Array for saving names of a song that identified as no-decision

% Read files in directory "clipGaussian/"
files = what('clipGaussian');
matFiles = files.mat;

% Perform Shazam on 20 test clips
for index = 1:length(matFiles)
    fileName = matFiles{index};% Name of the test clip
    toRead = ['clipGaussian/',fileName];
    identifiedSong = main(testOption,toRead);% Identified clip by Shazam
    
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

% Calculate credit
credit = 0.6 * (credit/length(matFiles)); % max: 0.6, min: 0
toSaveMat = [netId,'_database_test.mat'];

% End measuing time
time = toc; % Unit in second

save(toSaveMat,'credit','correct','incorrect','noDecision','time');