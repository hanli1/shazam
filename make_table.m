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
    
    indices = [fix(-gs/2) : 1: fix(gs/2)];
    for i = 1 : numel(indices)
        for j = 1: numel(indices)
            currXShift = indices(i);
            currYShift = indices(j);
            if ~(currXShift == 0 && currYShift == 0)
                CS = circshift(log_S, [currXShift, currYShift]);
                localPeak = ((log_S-CS)>0);
                localPeaks = min(localPeaks, localPeak);
            end
        end
    end
    
    actualNumPeaks = nnz(localPeaks);
    desiredNumPeaks = 30 * numel(leftChannel)/Fs;
    
    threshold = 0.3;
    prevThreshold = 0.3;
    currDirection = 1;
    prevDirection = 1;
    increment = 0.3;
    
    newPeaks = 0;
    while 1
        tempPeaks = localPeaks;
        for i = 1: size(log_S, 1)
            for j = 1: size(log_S, 2)
                if log_S(i, j) < threshold && tempPeaks(i, j) == 1
                    tempPeaks(i,j) = 0;
                end
            end
        end
        tempNumPeaks = nnz(tempPeaks);
        prevThreshold = threshold;
        
        if tempNumPeaks > desiredNumPeaks
            threshold = threshold + increment;
            currDirection = 1;
        else
            threshold = threshold - increment;
            currDirection = 0;
        end
        
        if prevDirection ~= currDirection
            increment = increment /1.5;
        
        end
        prevDirection = currDirection;
        
        if abs(threshold - prevThreshold) < 0.0001
            newPeaks = tempPeaks;
            actualThreshold = threshold;
            break;
        end
%         threshold
%         increment
    end
    
    fanOut = 3;
    table = [];
    [t, f] = find(newPeaks == 1);
    for i = 1: numel(t)
        t1 = t(i);
        f1 = f(i);
        
        newT2 = [];
        newF2 = [];
        t2 = find((t >= t1 + deltaTL) & (t <= t1 + deltaTU));
        f2 = [];
        for tau = 1: numel(t2)
            currTime = t2(tau);
            index = find(t == currTime);
            if (f1 + deltaF >= f(index)) & (f1 -deltaF <= f(index))
               newT2 = [newT2 currTime];
               newF2 = [newF2 f(index)];
            end
                
        end
        
        for j = 1: numel(newT2)
            %f1 f2(i) t1 t2(i) - t1
            table = [table; 1];
        end
  
    end
    numel(table)
    
    
    
    

end