classdef ArenstorfProblem < otp.Problem
    %ARENSTORFPROBLEM A simplified 3-body problem
    %   This problem models the trajectory of a satellite of negligible mass
    %   under the gravitational pull of two orbiting bodies. These can be
    %   considered the Moon and Earth with masses MU and MU'=1-MU, respectively.
    %   The reference frame is chosen such that the Earth is at position
    %   (-MU, 0) on the plane, and the moon is at position (MU', 0). The
    %   satellite's motion is described by the second-order ODEs
    %
    %   y1'' = y1 + 2 y2' - MU' (y1 + MU) / D1 - MU (y1 - MU') / D2,
    %   y2'' = y2 - 2 y1' - MU' y2 / D1 - MU y2 / D2,
    %
    %   where
    %
    %   D1 = ((y1 + MU)^2 + y2^2)^(3/2),    D2 = ((y1 - MU')^2 + y2^2)^(3/2).
    %
    %   This is converted into a system of first order ODEs in which the state
    %   contains two position variables and two velocity variables:
    %
    %   y = [y1; y2; y1'; y2'].
    %
    %   Sources:
    %
    %   Arenstorf, Richard F. "Periodic Solutions of the Restricted Three Body
    %   Problem Representing Analytic Continuations of Keplerian Elliptic
    %   Motions." American Journal of Mathematics, vol. 85, no. 1, 1963, p. 27.
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
            
            obj.RHS = otp.RHS(@(t, y) otp.arenstorf.f(t, y, mu), ...
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
