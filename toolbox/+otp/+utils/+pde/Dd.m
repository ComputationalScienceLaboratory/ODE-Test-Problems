function [Dd] = Dd(n, domain, dim, dims, BC) 

Dd = otp.utils.pde.D(n(dim), domain, BC);

for d = -dims:(-dim-1)
    Dd = kron(speye(n(-d)), Dd);
end

for d = (-dim+1):-1
    Dd = kron(Dd, speye(n(-d)));
end

end
