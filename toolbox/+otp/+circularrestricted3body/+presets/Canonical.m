classdef Canonical < otp.circularrestricted3body.CR3BPProblem
    % A trivial preset with a stable oscillating orbit around a lagrange point.
    
       methods
           function obj = Canonical(varargin)
            % Create the Canonical CR3BP problem object.

            mu = 0.5;

            y0    = [0; 0; 0; 0; 0; 1];
            tspan = [0, 10];
            params = otp.circularrestricted3body.CR3BPParameters(...
                'Mu', mu, ...
                'SoftFactor', 1e-3, ...
                varargin{:});
            obj = obj@otp.circularrestricted3body.CR3BPProblem(tspan, y0, params);            
        end
    end
end
