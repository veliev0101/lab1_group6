clc; clear; close all;

n = [0,1,11];

impulses = generate_impulse(n);

% Берем импульсы
x1 = impulses(1:100);
x2 = impulses(101:200);
x3 = impulses(201:300);

% Считаем пик-фактор
rez1 = calc_pik_factor(x1);
rez2 = calc_pik_factor(x2);
rez3 = calc_pik_factor(x3);

nazvanie = {'pryam (n=0)'; 'sin^n1'; 'sin^n2'};

moshchnost_pik  = [rez1.moshchnost_pik;  rez2.moshchnost_pik;  rez3.moshchnost_pik];
moshchnost_sred = [rez1.moshchnost_sred; rez2.moshchnost_sred; rez3.moshchnost_sred];
pik_factor      = [rez1.pik_factor;      rez2.pik_factor;      rez3.pik_factor];
pik_factor_db   = [rez1.pik_factor_db;   rez2.pik_factor_db;   rez3.pik_factor_db];

tablica_pikfactor = table(nazvanie, moshchnost_pik, moshchnost_sred, pik_factor, pik_factor_db);

disp('=== Результаты пик-фактора для ЛР1 ===');
disp(tablica_pikfactor);

% Графики (если нужно)
if pokazat_grafiki
    figure;
    plot(abs(x1).^2, 'LineWidth', 1); grid on;
    title('Мгновенная мощность: pryam');
    xlabel('номер отсчета'); ylabel('p');

    figure;
    plot(abs(x2).^2, 'LineWidth', 1); grid on;
    title('Мгновенная мощность: sin^n1');
    xlabel('номер отсчета'); ylabel('p');

    figure;
    plot(abs(x3).^2, 'LineWidth', 1); grid on;
    title('Мгновенная мощность: sin^n2');
    xlabel('номер отсчета'); ylabel('p');
end
