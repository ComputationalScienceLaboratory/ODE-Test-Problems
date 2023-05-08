function [If2c1D, Ic2f1D] = relaxProlong1D(nf, nc, BC)

if nargin < 3 || isempty(BC)
    BC = 'D';
end

rc = 1:nc;

if2cs = [rc, rc, rc];
jf2cs = [(2*rc)-1, 2*rc, (2*rc)+1];
if BC == 'C'
    jf2cs(jf2cs == 0) = nf;
    jf2cs(jf2cs == nf + 1) = 1;
end

vf2cs = [1/4*ones(1, nc), 1/2*ones(1, nc), 1/4*ones(1, nc)];
If2c1D = sparse(if2cs, jf2cs, vf2cs, nc, nf);

if nargout > 1
Ic2f1D = 4*If2c1D.';
end

end
