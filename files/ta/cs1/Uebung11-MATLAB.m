%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               RT1 Assistenz
%                 Uebung 10
%             Nicolas Lanzetti
%                04.12.2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all;
clear all;
clc;

s = tf('s');

P(1) = 1/(s+1);
P(2) = 2/(s*(s+1));

C(1) = 1+1/s+s;
C(2) = 1;

np = size(P,2);
nc = size(C,2);

for i = 1:np
    for j = 1:nc
        L(i,j) = series(C(j),P(i));
        T(i,j) = feedback(L(i,j),1);
        S(i,j) = 1 - T(i,j);
        e1 = evalfr(minreal(S(i,j)),0);
        e2 = evalfr(-minreal(S(i,j)*P(i)),0);
        
        figure(1)
        subplot(np,nc,(i-1)*np+j)
        step(T(i,j))
        hold on
        step(minreal(s/s))
        title(strcat('r(t) = h(t), Error=',num2str(e1)))
        figure(2)
        subplot(np,nc,(i-1)*np+j)
        step(minreal(S(i,j)*P(i)))
        hold on
        step(minreal(0*s/s))
        title(strcat('w(t) = h(t),Error=',num2str(e2)))
    end
end