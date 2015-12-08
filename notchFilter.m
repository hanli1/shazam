function filteredSong = notchFilter(input, samplingFreq)
    %Get the FFT of the input
    N = length(input);
    startFreq = -samplingFreq/2;
    endFreq = samplingFreq/2-(2*samplingFreq/2)/N;
    stepSize = (2*samplingFreq/2)/N;
    freq = startFreq:stepSize:endFreq;
    X = fftshift(fft(input))/N;
    
    %%%%%%
    r = 0.985; %Radius of Poles
    peakDist = N*.0005;
    
    figure();
    plot(freq,abs(X));
    title('Unfiltered')
    [peakValues, peakLocations] = findpeaks(abs(X),'SortStr','descend','MinPeakDistance',peakDist,'NPeaks',4);
    
    
    %If the peakValues are below a threshold, ignore them
    %Determine the top two peaks. If the ratio between the top two peaks is
    %greater than 2, then filter it
    ratio = peakValues(1)/peakValues(3);
    threshold = 1.4;
    
    %Always filter out 2000Hz
%      r2000 = .95;
%      filter2000 = (2000*2*pi)/samplingFreq;
%      a2000 = [1, -2*r2000*cos(filter2000), r2000*r2000];
%      b2000 = [1, -2*cos(filter2000), 1];
%      input = filter(b2000,a2000,input);
    if ratio > threshold
        'Notch Filtering'
        %Normalize the maximum frequency values to Hz
        %negPeak = freq(peakLocations(1));
        posPeak = freq(peakLocations(2));
        if posPeak > 1000
            filterFreq = (posPeak*2*pi)/samplingFreq;
            %Now Filter that shit
            a = [1, -2*r*cos(filterFreq), r*r];
            b = [1, -2*cos(filterFreq), 1];
            filteredSong = filter(b,a,input);
        else
            filteredSong = input;
        end
        
    else
        filteredSong = input;   
    end
      figure()
      fSong = fftshift(fft(filteredSong))/N;
      plot(freq,abs(fSong));
      title('Filtered')
    




