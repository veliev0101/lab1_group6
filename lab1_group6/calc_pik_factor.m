function out = calc_pik_factor(a)
a = a(:);
p = abs(a).^2;
out.Pmax = max(p);
out.Pmean = mean(p);
if out.Pmean == 0
    out.PikFactor = NaN;
    out.PikFactordB = NaN;
else
    out.PikFactor = out.Pmax/out.Pmean;
    out.PikFactordB = 10*log10(out.PikFactor);
end
end
