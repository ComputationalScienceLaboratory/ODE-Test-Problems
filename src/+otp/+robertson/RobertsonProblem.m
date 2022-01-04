classdef RobertsonProblem < otp.Problem
    %ROBERTSONPROBLEM A simple, stiff chemical reaction
    %   This problem models the concentration of chemical species A, B, and C 
    %   with the reactions
    %
    %   A     -> B      at rate K1,
    %   B + B -> C + B  at rate K2,
    %   B + C -> A + C  at rate K3.
    %
    %   These correspond to the ODEs
    %
    %   y1' = -K1 y1 + K3 y2 y3,
    %   y2' = K1 y1 - K2 y2^2 - K3 y2 y3,
    %   y3' = K2 y2^2.
    %
    %   The reaction rates K1, K2, and K3 often range from slow to very fast
    %   which makes the problem challenging. This has made it a popular test for
    %   implicit integrators.
    %
    %   Sources
    %
    %   
    %
    %   See also otp.robertson.RobertsonParameters
    
    methods
        %ROBERTSONPROBLEM Construct a Robertson problem
        function obj = RobertsonProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Robertson Problem', 3, timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)
        function onSettingsChanged(obj)
            k1 = obj.Parameters.K1;
            k2 = obj.Parameters.K2;
            k3 = obj.Parameters.K3;
            
            obj.RHS = otp.RHS(@(t, y) otp.robertson.f(t, y, k1, k2, k3), ...
                'Jacobian', @(t, y) otp.robertson.jacobian(t, y, k1, k2, k3), ...
                'NonNegative', 1:obj.NumVars);
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, 'xscale', 'log', ...
                varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = internalMovie@otp.Problem(obj, t, y, 'xscale', 'log', ...
                varargin{:});
        end
    end
end
