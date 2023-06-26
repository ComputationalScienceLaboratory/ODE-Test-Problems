function [If2c, Ic2f] = relaxProlong2D(nfx, ncx, nfy, ncy, BC)

if nargin < 4
    nfy = nfx;
    ncy = ncx;
end

if nargin < 5
    BC = 'DD';
end

If2c1Dx = otp.utils.pde.relaxprolong1D(nfx, ncx, BC(1));
If2c1Dy = otp.utils.pde.relaxprolong1D(nfy, ncy, BC(2));

If2c = kron(speye(ncy), If2c1Dx) * kron(If2c1Dy, speye(nfx));

Ic2f = 4*If2c.';

end
