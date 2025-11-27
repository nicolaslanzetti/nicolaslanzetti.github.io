close all
clear all
clc

s = tf('s');

P1 = 1/(s-1);
% C1 = 1;
C1 = 2;
% C1 = 2*(s+1)/(0.01*s+1); 
% C1 = 2*(s+1);

figure(1)
subplot(1,2,1)
nyquist(C1*P1)
subplot(1,2,2)
step(feedback(series(C1,P1),1))

%%

P2 = 1/(s-1)^2;
C2 = 1;
% C2 = 3*(s+1);
% C2 = 3*(s+1)/(0.000001*s+1);
% C2 = 2*(s+2)^2;

figure(2)
subplot(1,2,1)
nyquist(C2*P2)
subplot(1,2,2)
step(feedback(series(C2,P2),1))
