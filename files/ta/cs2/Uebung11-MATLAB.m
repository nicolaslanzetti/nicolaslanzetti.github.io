close all
clear all
clc

A = -1;
B = 1; 
C = 0.5;
D = 0; 

nx = size(A,1);
ny = size(C,1);
nu = size(B,2);

% LQR
R = 1*eye(nu);
Q = C'*C; 

K = lqr(A,B,Q,R);

% Beobachter
L = lqr(A',C',B*B',1/32*eye(ny))';

% LQGI

gamma = 1;

A_tilde = [A zeros(nx,ny); 
           -C zeros(ny,ny)];
B_tilde = [B; zeros(ny,nu)];
Q_tilde = [Q zeros(nx,ny);
    zeros(ny,nx) gamma^2*eye()];
R_tilde = R;

K_tilde = lqr(A_tilde, B_tilde, Q_tilde, R_tilde);

K1 = K_tilde(:,1:nx)
KI = -K_tilde(:,nx+1:end)



