classdef ZLAKineticsProblem < otp.Problem
    % ZLA Kinetics model also known as The Chemical Akzo Nobel problem is a differential
    % equation that describes the interaction of fictitious species, FLB and ZHU to form two other 
    % species, ZLA and ZLH. The complete reaction is given in :cite:p:`Sto98`.
    %
    % Modeling the concentrations of the species involved in the reaction as $y_{i=\{1,\ldots, 6 \}}$ 
    % and various reaction rates as $r_{i=\{1,\ldots, 5 \}}$ leads to the following system of ODEs:
    %
    % $$
    % \begin{aligned}
    % & y_1^{\prime}=-2 r_1 + r_2 - r_3 - r_4, \\
    % & y_2^{\prime}=-\frac{1}{2} r_1 - r_4 - \frac{1}{2} r_5 + F_{\text{in}}, \\
    % & y_3^{\prime}=r_1 - r_2 + r_3, \\
    % & y_4^{\prime}=-r_2 + r_3 - 2 r_4, \\
    % & y_5^{\prime}=r_2 - r_3 + r_5, \\
    % & y_6^{\prime}=K_s \cdot y_1 \cdot y_2 \cdot y_6,\\
    % & F_{\text {in }} = \text{klA} \cdot\left(\frac{\text{pCO}_2}{H}-y_2\right).
    % \end{aligned}
    % $$
    % and the reaction rates are given by:
    % $$
    % \begin{aligned}
    % r_1 & =k_1 \cdot y_1^4 \cdot y_2^{\frac{1}{2}}, \\
    % r_2 & =k_2 \cdot y_3 \cdot y_4, \\
    % r_3 & =\frac{k_2}{K} \cdot y_1 \cdot y_5, \\
    % r_4 & =k_3 \cdot y_1 \cdot y_4^2, \\
    % r_5 & =k_4 \cdot y_6^2 \cdot y_2^{\frac{1}{2}}.
    % \end{aligned}
    % $$
    % 
    % The parameters $k = [k_i]_{i=\{1,\ldots, 4 \}}$, $K$, $\text{klA}$, $K_s$, $\text{pCO}_2$, and $H$ are the rates and constants of the reaction.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------+
    % | Type                | ODE                                     |
    % +---------------------+-----------------------------------------+
    % | Number of Variables | 6                                       |
    % +---------------------+-----------------------------------------+
    % | Stiff               | yes, depending on parameters            |
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
