function butterSong = butterFilter(input, samplingFreq)
%      figure();
%      plot(input);
%      title('input');
    
    N = 2;
    cutoffFreq = 3000; %Hz
    Wn = cutoffFreq / (samplingFreq / 2);
    
    [B, A] = butter(N, Wn, 'low');
    
    butterSong = filter(B,A,input);
    
%      figure();
%      plot(butterSong);
%      title('out');
%     



end