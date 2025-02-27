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
    %indices = []
    
    [f,t] = find(newPeaks == 1);
    for i = 1:numel(t)
        %Get the indices of t1 and f1
        t1 = t(i);
        f1 = f(i);
        
        %Calculate the bounds of the "box"
        tMax = t1 + deltaTU;
        tMin = t1 + deltaTL;
        fMax = f1 + deltaF;
        fMin = f1 - deltaF;
        
        %Find the indices in f,t such that they are within the box
        ind = find( ((t <= tMax) & (t >= tMin) & (f <= fMax) & (f >= fMin)),fanOut );
        
        for j = 1:numel(ind)
            %indices = [indices ind(j)]
            deltaT = t(ind(j)) - t1;
            newRow = [f1 f(ind(j)) t1 deltaT];
            table = [table; newRow];
        end
        
        
        
    end
    
    
    

end