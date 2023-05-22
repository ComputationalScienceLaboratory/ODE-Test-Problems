function dfd = evalAB(A, B, f, fBC)

nmesh = size(f, 2);
nmeshbc = size(fBC, 2);

nmeshfull = nmesh + nmeshbc;
ndivterms = size(A, 1);

ffull = [f, fBC];

fdiff = reshape(-f + ffull.', 1, nmeshfull, nmesh);
B = reshape(sum(B.*fdiff, 2), ndivterms, 1, nmesh);

% OCTAVE FIX: find out if the function pagemldivide exists, and
% if it does not, replace it with a compatible function
if exist('pagemldivide', 'builtin') == 0
    pmld = @otp.utils.compatibility.pagemldivide;
else
    pmld = @pagemldivide;
end

dfd = reshape(pmld(A, B), ndivterms, []);

end
