classdef NRHO < otp.cr3bp.CR3BPProblem
    % 

    methods
        function obj = NRHO
            % Create the NRHO CR3BP problem object.
            % $L_2$ Halo orbit family member
            
            ic = [1.0192741002 -0.1801324242 -0.0971927950];
            mE = otp.utils.PhysicalConstants.EarthMass;
            mL = otp.utils.PhysicalConstants.MoonMass;
            G  = otp.utils.PhysicalConstants.GravitationalConstant;

            % derive mu
            muE = G*mE;
            muL = G*mL;
            mu = muL/(muE + muL);

            y0    = [ic(1); 0; ic(2); 0; ic(3); 0];
            tspan = [0, 10];
            params = otp.cr3bp.CR3BPParameters('Mu', mu, 'SoftFactor', 0);
            obj = obj@otp.cr3bp.CR3BPProblem(tspan, y0, params);            
        end
    end
end
