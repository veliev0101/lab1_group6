clc; clear; close all;

T = 1;
sps = 100;
dt = T/sps;
t = 0:dt:T-dt;
Fs = sps/T;
NFFT = 2^14;
n = [0, 1, 11];

impulses = generate_impulse_local(t, T, n);
impuls_pryam = impulses(1, :);
impuls_sin_n1 = impulses(2, :);
impuls_sin_n2 = impulses(3, :);

figure('Name','Импульсы во времени');
subplot(3,1,1);
plot(t/T, impuls_pryam, 'LineWidth', 1.2); grid on;
xlabel('t/T'); ylabel('a(t)');
title('Прямоугольный, n=0');

subplot(3,1,2);
plot(t/T, impuls_sin_n1, 'LineWidth', 1.2); grid on;
xlabel('t/T'); ylabel('a(t)');
title('sin^1(\pi t/T)');

subplot(3,1,3);
plot(t/T, impuls_sin_n2, 'LineWidth', 1.2); grid on;
xlabel('t/T'); ylabel('a(t)');
title('sin^{11}(\pi t/T)');

[f, Glin, GdB] = calc_spectrum_local(impulses, NFFT, Fs);

Gtheory = (sinc(f*T)).^2;
Gtheory = Gtheory ./ max(Gtheory);
GdB_theory = 10*log10(Gtheory + eps);

figure('Name','Спектр прямоугольного импульса: теория и модель');
plot(f, GdB_theory, '-', 'LineWidth', 1.8, 'DisplayName','Теория'); hold on;
plot(f, GdB(:,1), '--', 'LineWidth', 1.5, 'DisplayName','Модель');
grid on; xlim([-10 10]); ylim([-90 5]);
xlabel('f, 1/T'); ylabel('G(f)/G(0), дБ');
legend('Location','best');

figure('Name','Сравнение спектров (дБ)');
plot(f, GdB(:,1), 'LineWidth', 1.4, 'DisplayName','n=0'); hold on;
plot(f, GdB(:,2), 'LineWidth', 1.4, 'DisplayName','n=1');
plot(f, GdB(:,3), 'LineWidth', 1.4, 'DisplayName','n=11');
grid on; xlim([-10 10]); ylim([-90 5]);
xlabel('f, 1/T'); ylabel('G(f)/G(0), дБ');
legend('Location','best');

perviy_nul = zeros(3,1);
for k = 1:3
    perviy_nul(k) = find_first_null_local(f, Glin(:,k));
end

tablica_nul = table(n(:), perviy_nul, 'VariableNames', {'n', 'perviy_nol'});
disp('Таблица 1. Первый нуль спектра');
disp(tablica_nul);

urovni_db = [-20; -30; -40; -60];
polosa_db = zeros(numel(urovni_db), 3);
for i = 1:numel(urovni_db)
    for k = 1:3
        polosa_db(i,k) = bandwidth_by_level_local(f, GdB(:,k), urovni_db(i));
    end
end

tablica_polosa_db = table(urovni_db, polosa_db(:,1), polosa_db(:,2), polosa_db(:,3), ...
    'VariableNames', {'uroven_dB', 'deltaF_n0', 'deltaF_n1', 'deltaF_n11'});
disp('Таблица 2. Полоса по уровням спектра');
disp(tablica_polosa_db);

koncentracii = [0.90; 0.95; 0.99];
polosa_energy = zeros(numel(koncentracii), 3);
for i = 1:numel(koncentracii)
    for k = 1:3
        polosa_energy(i,k) = bandwidth_by_energy_local(f, Glin(:,k), koncentracii(i));
    end
end

koncentracii_pct = 100 * koncentracii;
tablica_polosa_energy = table(koncentracii_pct, polosa_energy(:,1), polosa_energy(:,2), polosa_energy(:,3), ...
    'VariableNames', {'koncentraciya_pct', 'deltaF_n0', 'deltaF_n1', 'deltaF_n11'});
disp('Таблица 3. Полоса по концентрации энергии');
disp(tablica_polosa_energy);

[pp1, pm1, papr1, paprdb1] = calc_pik_factor_local(impuls_pryam);
[pp2, pm2, papr2, paprdb2] = calc_pik_factor_local(impuls_sin_n1);
[pp3, pm3, papr3, paprdb3] = calc_pik_factor_local(impuls_sin_n2);

nazvanie = {'Прямоугольный (n=0)'; 'sin^1'; 'sin^11'};
moshchnost_pik = [pp1; pp2; pp3];
moshchnost_sred = [pm1; pm2; pm3];
pik_factor = [papr1; papr2; papr3];
pik_factor_db = [paprdb1; paprdb2; paprdb3];

tablica_pikfactor = table(nazvanie, moshchnost_pik, moshchnost_sred, pik_factor, pik_factor_db);
disp('Таблица 4. Пик-фактор');
disp(tablica_pikfactor);

figure('Name','Мгновенная мощность p(t)=|a(t)|^2');
subplot(3,1,1);
plot(t/T, abs(impuls_pryam).^2, 'LineWidth', 1.2); grid on;
xlabel('t/T'); ylabel('p(t)'); title('Прямоугольный, n=0');

subplot(3,1,2);
plot(t/T, abs(impuls_sin_n1).^2, 'LineWidth', 1.2); grid on;
xlabel('t/T'); ylabel('p(t)'); title('sin^1');

subplot(3,1,3);
plot(t/T, abs(impuls_sin_n2).^2, 'LineWidth', 1.2); grid on;
xlabel('t/T'); ylabel('p(t)'); title('sin^11');

function impulses = generate_impulse_local(t, T, n)
    a1 = (sin(pi*t/T)).^n(1);
    a2 = (sin(pi*t/T)).^n(2);
    a3 = (sin(pi*t/T)).^n(3);
    impulses = [a1; a2; a3];
end

function [f, Glin, GdB] = calc_spectrum_local(impulses, NFFT, Fs)
    nSignals = size(impulses,1);
    f = (-NFFT/2:NFFT/2-1) * Fs/NFFT;
    Glin = zeros(NFFT, nSignals);
    GdB = zeros(NFFT, nSignals);

    for k = 1:nSignals
        S = fftshift(fft(impulses(k,:), NFFT));
        G = abs(S).^2;
        G = G ./ max(G);
        Glin(:,k) = G(:);
        GdB(:,k) = 10*log10(G(:) + eps);
    end
end

function f0 = find_first_null_local(f, G)
    [~, c] = min(abs(f));
    g = G(:);
    f = f(:);
    f0 = NaN;
    for i = c+2:numel(g)-1
        if g(i-1) > g(i) && g(i+1) > g(i)
            f0 = abs(f(i));
            return;
        end
    end
end

function dF = bandwidth_by_level_local(f, GdB, level_dB)
    [~, c] = min(abs(f));
    g = GdB(:);
    f = f(:);
    iCross = NaN;
    for i = c:numel(g)-1
        if g(i) >= level_dB && g(i+1) < level_dB
            iCross = i;
            break;
        end
    end
    if isnan(iCross)
        dF = NaN;
        return;
    end
    f1 = f(iCross); g1 = g(iCross);
    f2 = f(iCross+1); g2 = g(iCross+1);
    if abs(g2 - g1) < 1e-12
        fEdge = f1;
    else
        fEdge = f1 + (level_dB - g1) * (f2 - f1) / (g2 - g1);
    end
    dF = 2 * abs(fEdge);
end

function dF = bandwidth_by_energy_local(f, G, target_share)
    f = f(:);
    G = G(:);
    [~, c] = min(abs(f));
    Etot = trapz(f, G);
    if Etot <= 0
        dF = NaN;
        return;
    end
    kMax = min(c-1, numel(f)-c);
    dF = NaN;
    for k = 0:kMax
        idxL = c-k;
        idxR = c+k;
        Ewin = trapz(f(idxL:idxR), G(idxL:idxR));
        if Ewin / Etot >= target_share
            dF = f(idxR) - f(idxL);
            return;
        end
    end
end

function [moshchnost_pik, moshchnost_sred, pik_factor, pik_factor_db] = calc_pik_factor_local(a)
    a = a(:);
    p = abs(a).^2;
    moshchnost_pik = max(p);
    moshchnost_sred = mean(p);
    if moshchnost_sred < 1e-12
        pik_factor = NaN;
        pik_factor_db = NaN;
    else
        pik_factor = moshchnost_pik / moshchnost_sred;
        pik_factor_db = 10*log10(pik_factor);
    end
end
