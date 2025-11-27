%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 RT1 PVK
%             Nicolas Lanzetti
%                06.01.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear all;
clc;

s = tf('s');

%% Zeichen von Bode (Uebung)

P1 = (s+1)^2/((-s+1)*(0.01*s+1)*(s*0.1+1))*exp(-0.0001*s);
figure(1)
bode(P1)
grid on

%% Zeichen von Bode (Loesung)
figure(2)
bode(P1,'r',(s+1),'b--',1/(-s+1),'g--',1/(0.01*s+1),'y--',1/(s*0.1+1),'m--',exp(-0.0001*s),'c--')
legend ('P(s)','s+1','1/(-s+1)','1/(0.01\cdot s+1)','1/(0.1\cdot s+1)','exp(-0.0001*s)','10')
title('$$P(s)=\frac{(s+1)^2}{(-s+1)\cdot(0.01\cdot s+1)\cdot(0.1\cdot s+1)}\cdot e^{0.0001\cdot s}$$','interpreter','latex')
grid on

%% Zuordnung von Uebertragung und Nyquist (Uebung)

L1 = exp(-s)*1/(s+2);
L2 = 1/((s+1)*(s+2));
L3 = 1/((-s+1)*(s+2));
L4 = 1/(s*(s+2));


figure(3)
subplot(2,2,1)
nyquist(L1)
title('A')
subplot(2,2,2)
nyquist(L2)
title('B')
subplot(2,2,3)
nyquist(L3)
title('C')
subplot(2,2,4)
nyquist(L4)
title('D')

%% Zuordnung von Uebertragung und Nyquist (Uebung)

figure(4)
subplot(2,2,1)
nyquist(L1)
title('$$e^{-2}\cdot\frac{1}{s+2}$$','interpreter', 'latex')
subplot(2,2,2)
nyquist(L2)
title('$$\frac{1}{(s+1)\cdot(s+2)}$$','interpreter', 'latex')
subplot(2,2,3)
nyquist(L3)
title('$$\frac{1}{(-s+1)\cdot(s+2)}$$','interpreter', 'latex')
subplot(2,2,4)
nyquist(L4)
title('$$\frac{1}{s\cdot(s+2)}$$','interpreter', 'latex')

%% Lesen der Uebertragungsfunktion und von Nyquist aus dem Bode Diagramm 

P2 = 10*(0.1*s+1)/(s+1)^2;
figure(5)
bode(P2)
grid on

%% Lesen der Uebertragungsfunktion und von Nyquist aus dem Bode Diagramm (Loesung)

figure(6)
subplot(1,2,1)
bode(P2)
grid on
subplot(1,2,2)
nyquist(P2)