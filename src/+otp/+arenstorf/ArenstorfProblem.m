classdef ArenstorfProblem < otp.Problem
    %ARENSTORFPROBLEM A simplified 3-body problem
    %   This problem models the trajectory of a satellite of negligible mass
    %   under the gravitational pull of two orbiting bodies.  These can be
    %   considered the Moon and Earth with masses MU and 1-MU, respectively.
    %   The Arenstorf problem is posed on the plane, but there are four
    %   state variables:
    %
    %   y = [y1 position; y2 position; y1 velocity; y2 velocity]
    %
    %   The ODE can be found in
    %
    %   Arenstorf, Richard F. "Periodic Solutions of the Restricted Three Body
    %   Problem Representing Analytic Continuations of Keplerian Elliptic
    %   Motions.” American Journal of Mathematics, vol. 85, no. 1, 1963, p. 27.
    %
    %   Hairer, Ernst, et al. Solving Ordinary Differential Equations I:
    %   Nonstiff Problems. 2nd ed., vol. 8, Springer-Verlag, 1993, pp. 129-130.
    %
    %   See also otp.arenstorf.ArenstorfParameters
    
    methods
        %ARENSTORFPROBLEM Construct an Arenstorf problem
        function obj = ArenstorfProblem(timeSpan, y0, parameters)
            obj@otp.Problem('Arenstorf Orbit', 4, timeSpan, y0, parameters);
        end
    end
    
    methods (Access=protected)
        function onSettingsChanged(obj)
            mu = obj.Parameters.Mu;
            
            obj.Rhs = otp.Rhs(@(t, y) otp.arenstorf.f(t, y, mu), ...
                'Jacobian', @(t, y) otp.arenstorf.jacobian(t, y, mu));
        end
        
        function label = internalIndex2label(~, index)
            if index <= 2
                label = sprintf('y_{%d}', index);
            else
                label = sprintf('y''_{%d}', index - 2);
            end
        end
        
        function fig = internalPlotPhaseSpace(obj, t, y, varargin)
            fig = internalPlotPhaseSpace@otp.Problem(obj, t, y, ...
                'Vars', 1:2, varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = otp.utils.movie.PhaseSpaceMovie('title', obj.Name, ...
                'Vars', 1:2, varargin{:});
            mov.record(t, y);
        end
    end
end
