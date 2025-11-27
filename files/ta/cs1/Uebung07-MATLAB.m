%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               RT1 Assistenz
%                 Uebung 7
%             Nicolas Lanzetti
%                06.11.2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear all;
clc;

s = tf('s');

%% Zeichen von Bode (Zerlesung in Elementarblocken) und Nyquist
P1 = (s+1)/(s-10);
figure(1)
subplot(1,2,1)
bode(P1)
grid on
subplot(1,2,2)
nyquist(P1)

%% Zeichen von Bode (direkt, auch ohne Zerlegung)

P2 = (s+1)^2/((s-1)*(0.01*s+1)*(s*0.1+1))*exp(-0.0001*s);
figure(2)
bode(P2,'r',(s+1),'b--',1/(s-1),'g--',1/(0.01*s+1),'y--',1/(s*0.1+1),'m--',exp(-0.0001*s),'c--')
legend ('P(s)','s+1','1/(s-1)','1/(0.01\cdot s+1)','1/(0.1\cdot s+1)','exp(-0.0001*s)')
title('$$P(s)=\frac{(s+1)^2}{(s-1)\cdot(0.01\cdot s+1)\cdot(0.1\cdot s+1)}$$','interpreter','latex')
grid on

%% Zuordnung von Uebertragung und Nyquist

L1 = exp(-s)*1/(s^2+2*s+2);
L2 = 3/(s^2-s+6);
L3 = 4/(s^3+2*s^2+4*s);
L4 = (-2*s+2)/(s^2+3*s+4);

figure(3)
subplot(2,2,1)
nyquist(L3)
title('A')
subplot(2,2,2)
nyquist(L2)
title('B')
subplot(2,2,3)
nyquist(L4)
title('C')
subplot(2,2,4)
nyquist(L1)
title('D')


