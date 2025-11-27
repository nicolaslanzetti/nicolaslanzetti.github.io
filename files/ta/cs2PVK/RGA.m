%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              RT2 Assistenz
%             Nicolas Lanzetti
%               16.06.2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

s = tf('s');

P = [1/(s+1) 1/(s+10); 1/(s+4) 1/(s+3)];

RGA1 = minreal(+P(1,1)*P(2,2)/(P(1,1)*P(2,2)-P(1,2)*P(2,1)));
RGA2 = minreal(-P(1,2)*P(2,1)/(P(1,1)*P(2,2)-P(1,2)*P(2,1)));

figure(1)
bodemag(RGA2,'r',RGA1,'b')
legend('RGA11', 'RGA12')