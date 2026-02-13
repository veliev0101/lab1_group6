clc; clear; close all;

%Constants
T = 1; 
sps = 100; 

dt = T/sps;
t = 0:dt:T-dt;



Nfft = 2^12;
Fs = sps/T;


impulses = generate_impulse(t,T);
a1 = impulses(1:100);
a2 = impulses(101:200);
a3 = impulses(201:300);

spectr1 = spectre(Nfft,Fs,a1,T);
spectr2 = spectre(Nfft,Fs,a2,T);
spectr3 = spectre(Nfft,Fs,a3,T);

pik1 = calc_pik_factor(a1);










