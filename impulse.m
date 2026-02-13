function y = impulse
T = 1; 
sps = 100; 
dt = T/sps;
t = 0:dt:T-dt;
n = [0,1,11];
a1 = (sin(pi*t/T)).^n(1);
a2 = (sin(pi*t/T)).^n(2);
a3 = (sin(pi*t/T)).^n(3);

figure; 
subplot(3,1,1); plot(t,a1); xlabel('{\itt}/{\itT}'); ylabel('{\ita}({\itt})') 
subplot(3,1,2); plot(t,a2); xlabel('{\itt}/{\itT}'); ylabel('{\ita}({\itt})') 
subplot(3,1,3); plot(t,a3); xlabel('{\itt}/{\itT}'); ylabel('{\ita}({\itt})') 
grid on 
