function result = generate_impulse(t,T)

n = [0,1,11];

a1 = (sin(pi*t/T)).^n(1);
a2 = (sin(pi*t/T)).^n(2);
a3 = (sin(pi*t/T)).^n(3);
result = [a1,a2,a3];

figure; 
subplot(3,1,1); plot(t,a1); xlabel('{\itt}/{\itT}'); ylabel('{\ita}({\itt})') 
subplot(3,1,2); plot(t,a2); xlabel('{\itt}/{\itT}'); ylabel('{\ita}({\itt})') 
subplot(3,1,3); plot(t,a3); xlabel('{\itt}/{\itT}'); ylabel('{\ita}({\itt})') 
grid on 

end