function result = spectre(NFFT,Fs,a,T)
    f = (-NFFT/2:NFFT/2-1) * Fs/NFFT;
    S = fftshift(fft(a,NFFT));
    G = abs(S).^2;
    G = G/max(G);
    GdB = 10*log10(G);
    Gtheory = (sin(pi*f*T)./(pi*f*T)).^2;
    GdBtheory = 10*log10(Gtheory);
    result = [Gtheory,GdBtheory];

    figure;
    plot(f, GdBtheory,'-','LineWidth',2,'DisplayName','теория');
    hold on;
    plot(f, GdB, '--','LineWidth',2,'DisplayName','моделирование');
    legend('show')
    xlabel('{\itf}, 1/{\itT}')
    ylabel('{\itG}({\itf})/{\itG}(0), дБ')
    grid on
    xlim([-10,10])
    ylim([-90,5])
end