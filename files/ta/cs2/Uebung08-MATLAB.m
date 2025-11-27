%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              RT2 Assistenz
%             Nicolas Lanzetti
%               21.04.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

% System 
A = [1 3; 4 2];
B = [1; 2];
C = eye(2);
D = 0;

% Choose Q and R
Q = 10*[10 0; 0 1];
R = 10;

% Compute LQR
K = lqr(A,B,Q,R);

% Declare closed loop system
sys = ss(A-B*K,B,C,D);

% Simulation
t = 0:0.1:5;
r = zeros(size(t));
x = lsim(sys,r,t,[1 -1])';
u = -K*x;

% Plot
figure(1)
ax(1) = subplot(3,1,1);
plot(t,x(1,:))
grid on
ylim([-1.5,1.5])
title('x_1(t)')
ax(2) = subplot(3,1,2);
plot(t,x(2,:))
grid on
ylim([-1.5,1.5])
title('x_2(t)')
ax(3) = subplot(3,1,3);
plot(t,u)
grid on
title('u(t)')

linkaxes(ax,'x')