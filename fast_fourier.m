function X = fast_fourier(x, fs)
    % Compute fft & fftshift
    N = length(x);
    freq = -fs/2000:(2*fs/2000)/N:fs/2000-(2*fs/2000)/N;
    X = fftshift(fft(x))/N;
        
    length(freq)
    length(X)
    % Plot abs & angle
    figure()
    subplot(2, 1, 1),
    plot(freq, abs(X), 'LineWidth', 1.5)
    title('Magnitude Spectrum of x(t)', 'FontSize', 16)
    xlabel('f (kHz)', 'FontSize', 14)
    ylabel('|X(\Omega)|', 'FontSize', 14)
    grid

    subplot(2, 1, 2),
    plot(freq, angle(X), 'LineWidth', 1.5)
    title('Phase Spectrum of x(t)', 'FontSize', 16)
    xlabel('f (kHz)', 'FontSize', 14)
    ylabel('\angle X(\Omega)', 'FontSize', 14)
    grid
end