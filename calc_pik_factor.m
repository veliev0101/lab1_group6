function out = calc_pik_factor(a)
% Пик-фактор = (пиковая мощность) / (средняя мощность).
% p = |a|^2, пик = max(p), средняя = mean(p).

    a = a(:);                  % делаем столбец (так проще)
    p = abs(a).^2;             % мгновенная мощность

    out.moshchnost_pik  = max(p);
    out.moshchnost_sred = mean(p);

    if out.moshchnost_sred < 1e-12
        out.pik_factor = NaN;
        out.pik_factor_db = NaN;
    else
        out.pik_factor = out.moshchnost_pik / out.moshchnost_sred;
        out.pik_factor_db = 10*log10(out.pik_factor);
    end
end
