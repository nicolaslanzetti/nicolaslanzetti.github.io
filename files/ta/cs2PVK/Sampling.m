%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              RT2 Assistenz
%             Nicolas Lanzetti
%               08.04.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

% Frequency of the signal
w = 2*pi;
T = 4;

% Sampling time
Ts = 0.1;
wn = pi/Ts;

% Generate signals
t = 0:0.01:T;
n = 0:1:T/Ts;

xc = cos(w*t);
xd = cos(w*Ts*n);

% Plot
figure(1)
plot(t,xc)
hold on
stem(n*Ts,xd)
title(strcat('Sampling of a sinusoid, w=',num2str(w),', T_s=',num2str(Ts),', w_n=pi/T_s=',num2str(wn)),'FontSize',20)
xlabel('Time [s]','FontSize',16)
ylabel('Amplitude [-]','FontSize',16)