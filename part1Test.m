% Fall 2015 ECE 2200, Shazam Part I Test
% Instruction:
% The program will first ask you to write your NetIDs. Please enter in form
% of [netID1]_[netID2]. 
% Then the program will automatically run your Shazam program on 10 songs.
% As the program completes, it will save the following parameters:
% 1. credit: Part I test credit (max: 10, min: 0)
% 2. correct: names of a song that identified correctly
% 3. incorrect: names of a song that identified incorrectly
% 4. time: the time in seconds that the Shazam program took for running 10 songs.
% You can load [netID1]_[netID2]_part_I_test.mat to check your
% performance.
clear all
close all

% Ask two NetIDs of Shazam project that is being tested
prompt = 'What are the NetIDs? Please enter in form of: dk683_ml634\n==> ';
netId = input(prompt,'s');

% Start measuing time
tic

% Parameters
testOption = 1;% Can ignore for now. It will be used for Shazam competition.
credit = 0;% Part I test credit
correct = {};% Array for saving names of a song that identified correctly
incorrect = {};% Array for saving names of a song that identified incorrectly

% Read files in directory "partITestDatabase/"
files = what('partITestDatabase');
matFiles = files.mat;

% Perform Shazam on 10 test clips
for index = 1:length(matFiles)
    fileName = matFiles{index}% Name of the test clip displayed 
    toRead = ['partITestDatabase/',fileName];
    identifiedSong = main(1,toRead);% Identified clip by Shazam
    
    % For correct
    if (strcmp(char(identifiedSong), fileName)) 
        credit = credit + 1;
        correct = [correct,fileName];
    % For incorrect
    else 
        credit = credit + 0;
        incorrect = [incorrect,fileName];
    end 
end

% Calculate credit
toSaveMat = [netId,'_Part_I_test.mat'];

% End measuing time
time = toc; % Unit in second

save(toSaveMat,'credit','correct','incorrect','time');