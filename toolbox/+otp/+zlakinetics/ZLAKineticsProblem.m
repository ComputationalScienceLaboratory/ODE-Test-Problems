classdef ZLAKineticsProblem < otp.Problem
    % ZLA Kinetics model also known as The Chemical Akzo Nobel problem is a chemical differential-algebraic
    % equation that describes the 
    % reaction of two species, FLB and ZHU to form two other species, ZLA and ZLH. The reaction is given by:
    %
    % $$
    % \ce{
    % FLB + ZHU -> ZLA + ZLH
    % }
    % $$
    %
    % The rate of the reaction is given by the following system of ODEs:
    %
    % $$
    % \begin{aligned}
    % \frac{d[FLB]}{dt} &= -k \cdot [FLB] \cdot [ZHU] \\
    % \frac{d[ZLA]}{dt} &= k \cdot [FLB] \cdot [ZHU] - \frac{klA \cdot [ZLA]}{K + [ZLA]} \\
    % \frac{d[ZLH]}{dt} &= \frac{klA \cdot [ZLA]}{K + [ZLA]} \\
    % \frac{d[ZHU]}{dt} &= -k \cdot [FLB] \cdot [ZHU] \\
    % \end{aligned}
    % $$
    %
    % Here, $[FLB]$, $[ZLA]$, $[ZLH]$, and $[ZHU]$ are the concentrations of the species FLB, ZLA, ZLH, and ZHU, respectively.
    % The parameters $k$, $K$, $klA$, $Ks$, $pCO2$, and $H$ are the rate constants of the reaction.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------+
    % | Type                | ODE                                     |
    % +---------------------+-----------------------------------------+
    % | Number of Variables | 4                                       |
    % +---------------------+-----------------------------------------+
    % | Stiff               | not typically, depending on $k$ and $K$ |
    % +---------------------+-----------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.zlakinetics.presets.Canonical;
    % >>> problem.TimeSpan(end) = 15;
    % >>> sol = problem.solve();
    % >>> problem.plot(sol);
    
    methods
        function obj = ZLAKineticsProblem(timeSpan, y0, parameters)
            obj@otp.Problem('ZLA-Kinetics', 6, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            k = obj.Parameters.k;
            K = obj.Parameters.K;
            klA = obj.Parameters.KlA;
            Ks = obj.Parameters.Ks;
            pCO2 = obj.Parameters.PCO2;
            H = obj.Parameters.H;
            
            obj.RHS = otp.RHS(@(t, y) otp.zlakinetics.f(t, y, k, K, klA, Ks, pCO2, H), ...
                'Jacobian', @(t, y) otp.zlakinetics.jacobian(t, y, k, K, klA, Ks, pCO2, H), ...
                'Mass', otp.zlakinetics.mass([], [], k, K, klA, Ks, pCO2, H), ...
                'MassSingular', 'yes', ...
                'Vectorized', 'on');
        end
        
    end
end
