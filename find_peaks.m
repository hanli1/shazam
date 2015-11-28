function table = make_table(songName, gs, deltaTL, deltaTU, deltaF)
    load(songName, '-mat');
    %songName is y
    leftChannel = y(:,1);
    resampled = resample(leftChannel, 8000, Fs);
    
    resampledFs = 8000;
    window = 64e-3 * resampledFs;
    noverlap = 32e-3 * resampledFs;
    nfft = 64e-3 * resampledFs;
    [S, F, T] = spectrogram(resampled, window, noverlap, nfft, resampledFs);
    log_S = log10(abs(S) + 1);
    % Step 2 Check
%     figure
%     imagesc(T,F,20*log10(abs(S)))
%     axis xy;
%     xlabel('Time (s)')
%     ylabel('Frequency (kHz)')
%     title('Spectrogram')	
%     colormap jet
%     c= colorbar;
%     set(c);
%     ylabel(c,'Power (dB)','FontSize',14); 

%     log_S = [1 1 1 3 ; 1 10 1 2 ; 1 3 1 5 ; 2 11 1 2]; 
    localPeaks = ones(size(log_S));
    
    indices = [fix(-gs/2) : 1: fix(gs/2)]
    for i = 1 : numel(indices)
        for j = 1: numel(indices)
            currXShift = indices(i);
            currYShift = indices(j);
            if ~(currXShift == 0 && currYShift == 0)
                CS = circshift(log_S, [currXShift, currYShift]);
                localPeak = ((log_S-CS)>0);
                if nnz(localPeak) == 0
                    currXShift
                    currYShift
                end
                localPeaks = min(localPeaks, localPeak);
            end
        end
    end
    
    actualPeaks = nnz(localPeaks)
    desiredPeaks = 30 * numel(leftChannel)/Fs;
    

end