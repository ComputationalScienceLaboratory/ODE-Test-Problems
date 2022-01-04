classdef TransistorAmplifierProblem < otp.Problem
    %TRANSISTORAMPLIFIERPROBLEM
    %
    % See: 
    %    Wanner, G., & Hairer, E. (1996). 
    %    Solving ordinary differential equations II (Vol. 375). 
    %    Springer Berlin Heidelberg.
    %
    % This is a modification of the problem presented in the above to account for a coupled TA.
    % See Also:
    %    https://archimede.dm.uniba.it/~testset/problems/transamp.php

    methods
        function obj = TransistorAmplifierProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Transistor Amplifier', 8, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            C = obj.Parameters.C;
            R = obj.Parameters.R;
            Ub = obj.Parameters.Ub;
            UF = obj.Parameters.UF;
            alpha = obj.Parameters.Alpha;
            beta = obj.Parameters.Beta;
            
            obj.RHS = otp.RHS(@(t, y) otp.transistoramplifier.f(t, y, C, R, Ub, UF, alpha, beta), ...
                'Jacobian', @(t, y) otp.transistoramplifier.jacobian(t, y, C, R, Ub, UF, alpha, beta), ...
                'Mass', otp.transistoramplifier.mass([], [], C, R, Ub, UF, alpha, beta), ...
                'MassSingular', 'yes', ...
                'Vectorized', 'on');
        end
    end
end

