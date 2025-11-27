%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 RT1 PVK
%             Nicolas Lanzetti
%                06.01.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;

% Set a = 1 for the second part of the exercise
a = 0;

s = tf('s');

sys1 = 2*s/((s+1)*(0.5*s+1));
sys2 = (s-2)/(2*s+1);
sys3 = exp(-s*1)/(s+1);
sys4 = (s+2)/(2*s+1);

if a == 1
    sys1 = (s+1)/(s*(s+2))^2;
    sys2 = 1/(s+2);
    sys3 = (s+1)/(s*(s+2));
    sys4 = -(s+1)/(s*(s+2));
end

figure(1)
f(1) = subplot(2,4,1);
nyquist(sys1)
f(2) = subplot(2,4,2);
nyquist(sys2)
f(3) = subplot(2,4,3);
bode(sys2)
grid on
f(4) = subplot(2,4,4);
bode(sys4)
grid on
f(5) = subplot(2,4,5);
nyquist(sys3)
f(6) = subplot(2,4,6);
nyquist(sys4)
f(7) = subplot(2,4,7);
bode(sys1)
grid on
f(8) = subplot(2,4,8);
bode(sys3)
grid on