%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               RT1 Assistenz
%                 Uebung 10
%             Nicolas Lanzetti
%                20.11.2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear all;
clc;

s = tf('s');

%% Stabilitaet und Nyquist kriterium

% Asymptotisch stabile Strecke
P1 = 1/(0.5*s+1);

% Instabile Strecke
P2 = 1/(-0.5*s+1);

C = -1;

L1 = series(C,P1);
L2 = series(C,P2);

T1 = feedback(L1,1);
T2 = feedback(L2,1);

figure(1)
subplot(1,2,1)
nyquist(L1)
title(strcat('Nyquist Plot des offenen Regelkreises mit C=',num2str(C)))
subplot(1,2,2)
step(T1)
title(strcat('Sprungantwort des geschlossen Regelkreises mit C=',num2str(C)))

figure(2)
subplot(1,2,1)
nyquist(L2)
title(strcat('Nyquist Plot des offenen Regelkreises mit C=',num2str(C)))
subplot(1,2,2)
step(T2)
title(strcat('Sprungantwort des geschlossen Regelkreises mit C=',num2str(C)))


%% Spezifikationen

L = -10/(-s+8);
K = exp(-s);

figure(3)
subplot(1,2,1)
nyquist(L)
hold on
nyquist(K,{1e-5 2*pi})
legend('L(s)','Unit circle')
axis equal
title('Nyquist plot von L(s)=-10/(-s+8)')
subplot(1,2,2)
margin(L)