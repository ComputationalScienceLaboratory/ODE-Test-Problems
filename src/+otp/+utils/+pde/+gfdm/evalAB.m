function dfd = evalAB(A, B, f, fBC)

% OCTAVE FIX: find out if the functions pagemtimes and pagemldivide exist, and
% if they does not, replace them with a compatible function
if exist('pagemldivide', 'builtin') == 0
    pmld = @otp.utils.compatibility.pagemldivide;
else
    pmld = @pagemldivide;
end
if exist('pagemtimes', 'builtin') == 0
    pmt = @otp.utils.compatibility.pagemtimes;
else
    pmt = @pagemtimes;
end

ndivterms = size(A, 1);

ffull = [f, fBC];

fdiff = permute(-f + ffull.', [3, 1, 2]);
Bfdiff = (pmt(B, 'none', fdiff, 'transpose'));

dfd = reshape(pmld(A, Bfdiff), ndivterms, []);

end
