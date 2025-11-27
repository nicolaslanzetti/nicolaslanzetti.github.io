%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 RT1 PVK
%             Nicolas Lanzetti
%                06.01.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;

% Parameters
inPause = 1;            % Initial Pause
inPauseValue = 10.0;    % Initial Pause Value
PauseValue = 5.0;       % Pause for interesting points
tol = 0.2;              % Tolerance for interesting points
sf = 14;                % Font Size
t = 0.0001;             % Default pause
a = 80;                 % Area of the red dot
lw = 3.0;               % Line width  
limx = [-2.10 2.10];    % Limits for x axes (Nyquist Plot)
limy = [-2.10 2.10];    % Limits for y axes (Nyquist Plot)

% Define transfer functions
s = tf('s');

sys1 = 2*s/((s+1)*(0.5*s+1));
sys2 = (s-2)/(2*s+1);
sys3 = exp(-s*1)/(s+1);
sys4 = (s+2)/(2*s+1);
sys5 = (s+1)/(s*(s+2))^2;
sys6 = 1/(s+2);
sys7 = (s+1)/(s*(s+2));
sys8 = -(s+1)/(s*(s+2));
sys9 = 2/(s+1)^2;

% Choose the transfer function
P = sys7;

% Choose frequencies
w = logspace(-2, 2, 200);

% Compute bode/nyquist
[mag, phase, w] = bode(P, w);
[re, im] = nyquist(P, w);

% Squeeze everything
mag  = squeeze(mag);
phase = squeeze(phase);
w = squeeze(w);
re = squeeze(re);
im = squeeze(im);

% Add the zero/infinite frequncy (not included in the bode plot)
re = [real(evalfr(P,0)); re; real(evalfr(P,i*inf))];
im = [imag(evalfr(P,0)); im; imag(evalfr(P,i*inf))];

for i = 1:length(w)
    figure(1)
    f(1) = subplot(2,2,[1 3]);
    plot(re,im,'b',re,-im,'b')
    xlim(limx)
    ylim(limy)
    xlabel('Real axis')
    ylabel('Imaginary axis')
    hold on
    scatter(re(i),im(i),a,'r','filled')
    line([0 re(i)], [0 im(i)],'Color','r','LineWidth',lw)
    plot(cos(-0.1:10e-2:2*pi),sin(-0.1:10e-2:2*pi),'black')
    hold off
    grid on
    title('Nyquist Plot')
    legend('Nyquist diagram','Unit circle')
    
    f(2) = subplot(2,2,2);
    semilogx(w,mag2db(mag),'b')
    xlim([0 max(w)])
    ylim([min(mag2db(mag)) max(mag2db(mag))])
    xlabel('Frequency [rad/s]')
    ylabel('Amplitude [dB]')
    hold on
    scatter(w(i), mag2db(mag(i)), a,'r','filled')
    hold off
    grid on
    title('Bode Plot')
    
    f(3) = subplot(2,2,4);
    semilogx(w,phase,'b')
    xlim([0 max(w)])
    ylim([min(phase) max(phase)])
    xlabel('Frequency [rad/s]')
    ylabel('Phase [deg]')
    hold on
    scatter(w(i), phase(i), a,'r','filled')
    hold off
    grid on
    
    set(f(:),'FontSize', sf)
    
    if i == 1 && inPause == 1
        pause(inPauseValue)
    end
    
    if abs(phase(i)+180) < tol || abs(phase(i)-90) < tol  || abs(mag2db(mag(i))) < tol
        pause(PauseValue)
    end
    
    pause(t)
end