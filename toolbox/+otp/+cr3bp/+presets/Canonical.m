classdef Canonical < otp.cr3bp.CR3BPProblem
       methods
           function obj = Canonical(varargin)
            % Create the Canonical CR3BP problem object.
            % This is a trivial steady state orbit oscillating around a lagrange point.

            mu = 0.5;

            y0    = [0; 0; 0; 0; 0; 1];
            tspan = [0, 10];
            params = otp.cr3bp.CR3BPParameters('Mu', mu, 'SoftFactor', 1e-3, varargin{:});
            obj = obj@otp.cr3bp.CR3BPProblem(tspan, y0, params);            
        end
    end
end
