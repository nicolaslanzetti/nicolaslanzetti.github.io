%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 RT1 PVK
%             Nicolas Lanzetti
%                06.01.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Use "Run and Advance" to run the script

close all;
clear all;
clc;

s = tf('s');

L1 = (s+1)/(s+2);
L2 = (s+1)/(s^2-2);
L3 = (s+2)/(s*(s+1));
L4 = (-s+2)/((s-1)*(s+1));
L5 = 0.5/(s^2+2*s+1)/(s-0.1);
[Gm,Pm,Wgm,Wpm] = margin(L5);

%% a)
clf(figure(1))
figure(1)
subplot(1,2,1)
nyquist(L1)
title('$$L_{1}(s) = \frac{s+1}{s+2}$$','Interpreter','Latex')
%% a) Lösung
subplot(1,2,2)
step(feedback(L1,1))
title('$$L_{1}(s) = \frac{s+1}{s+2}$$','Interpreter','Latex')

%% b)
clf(figure(1))
figure(1)
subplot(1,2,1)
nyquist(L2)
title('$$L_{2}(s) = \frac{s+1}{s^2-2}$$','Interpreter','Latex')
%% b) Lösung
subplot(1,2,2)
step(feedback(L2,1))
title('$$L_{2}(s) = \frac{s+1}{s^-2}$$','Interpreter','Latex')

%% c)
clf(figure(1))
figure(1)
subplot(1,2,1)
nyquist(L3)
title('$$L_{3}(s) = \frac{s+2}{s\cdot(s+1)}$$','Interpreter','Latex')
%% c) Lösung
subplot(1,2,2)
step(feedback(L3,1))
title('$$L_{3}(s) = \frac{s+2}{s\cdot(s+1)}$$','Interpreter','Latex')

%% d)
clf(figure(1))
figure(1)
subplot(1,2,1)
nyquist(L4)
title('$$L_{4}(s) = \frac{-s+2}{(s-1)\cdot(s+1)}$$','Interpreter','Latex')
%% d) Lösung
subplot(1,2,2)
step(feedback(L4,1))
title('$$L_{4}(s) = \frac{-s+2}{(s-1)\cdot(s+1)}$$','Interpreter','Latex')

%% e)
clf(figure(1))
figure(1)
subplot(1,2,1)
nyquist(L5)
title('$$L_{4}(s) = \frac{0.5}{(s^2+2\cdot s+1)\cdot(s-0.1)}$$','Interpreter','Latex')
%% e) Lösung
subplot(1,2,2)
step(feedback(L5,1))
title('$$L_{4}(s) = \frac{0.5}{(s^2+2\cdot s+1)\cdot(s-0.1)}$$','Interpreter','Latex')


%% 
figure(2)
subplot(1,2,1)
nyquist(L5)
axis equal
hold on
nyquist(exp(-s),{1e-5 2*pi})
legend('L(s)','Unit circle')
subplot(1,2,2)
bode(L5)
grid on
%%
subplot(1,2,2)
margin(L5)
grid on
