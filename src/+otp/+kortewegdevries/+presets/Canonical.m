classdef Canonical < otp.kortewegdevries.KortewegDeVriesProblem
    methods
        function obj = Canonical
            N = 150;

            L = 10;

            mesh = linspace(-L, L, N + 1);
            mesh = mesh(1:(end-1));
            meshBC = [];
            order = 6;

            u0 = 6*(sech(mesh).^2).';
            
            BC = @(t, x) 0*x;

            theta = 0;
            nu = -1;
            alpha = -3;
            rho = 0;

            hfun = @(x, y) hfunfull(x, y, L);

            dist = @(x, y) abs(hfun(x, y));
            r = 0.2;
            weightfun = @(mesh, meshi) otp.utils.rbf.gaussian(dist(mesh, meshi)/r);

            params = otp.kortewegdevries.KortewegDeVriesParameters;
            params.GFDMOrder = order;
            params.GFDMMesh = mesh;
            params.GFDMMeshBC = meshBC;
            params.GFDMHFun = hfun;
            params.GFDMWeightFun = weightfun;
            params.BCFun = BC;
            params.Theta = theta;
            params.Nu = nu;
            params.Alpha = alpha;
            params.Rho = rho;

            timespan = [0, 2];

            obj = obj@otp.kortewegdevries.KortewegDeVriesProblem(timespan, u0, params);

        end


    end


end

function h = hfunfull(x, y, L)

hs = [x - y; 2*L + x - y; -2*L + x - y];

[~, I] = min(abs(hs));

J = 1:numel(x);

h = hs(sub2ind(size(hs), I, J));

end
