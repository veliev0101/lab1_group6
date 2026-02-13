% 0 1 11
clc; clear; close all;


if n == 0
    a = ones(1,sps);
else
    a = sin(pi*t/T).^n;
end


spectre(NFFT,Fs,a,T);