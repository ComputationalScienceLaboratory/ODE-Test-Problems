classdef RobertsonProblem < otp.Problem
    % A simple, stiff chemical reaction.
    % 
    % The Robertson problem :cite:p:`Rob67` is a simple, stiff chemical reaction that
    % models the concentrations of chemical species $A$, $B$, and $C$ 
    % involved in the reactions
    % $$
    % \begin{align*}
    % &A  \rightarrow B      &~~\text{at rate}~~ &K_1, \\
    % &B + B \rightarrow C + B  &~~\text{at rate}~~  &K_2, \\
    % &B + C \rightarrow A + C  &~~\text{at rate}~~  &K_3.
    % \end{align*}
    % $$
    % These correspond to the ODE system, 
    % 
    % $$ 
    % \begin{align*}
    % y_1' &= -K_1 y_1 + K_3  y_2 y_3, \\
    % y_2' &= K_1 y_1 - K_2 y_2^2 - K_3 y_2 y_3, \\
    % y_3' &= K_2 y_2^2.
    % \end{align*}
    % $$
    % The reaction rates $K_1$, $K_2$, and $K_3$ often range from slow to very fast
    % which makes the problem challenging. This has made it a popular test for
    % implicit time-stepping schemes.
    % 
    % Notes
    % -----
    % +---------------------+-------------------------------------------------+
    % | Type                | ODE                                             |
    % +---------------------+-------------------------------------------------+
    % | Number of Variables | 3                                               |
    % +---------------------+-------------------------------------------------+
    % | Stiff               | typically, depending on $K_1$, $K_2$, and $K_3$ |
    % +---------------------+-------------------------------------------------+
    %
    % Example
    % -------
    %
    % >>> problem = otp.robertson.presets.Canonical;
    % >>> problem.Parameters.K1 = 100;
    % >>> problem.Parameters.K2 = 1000;
    % >>> problem.Parameters.K3 = 1000;
    % >>> sol = problem.solve();
    % >>> problem.plot(sol)

    properties (Access = private, Constant)
        NumComps = 3
        VarNames = 'ABC'
    end
    methods
        function obj = RobertsonProblem(timeSpan, y0, parameters)
            % Create a Robertson problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(3, 1)
            %    The initial conditions.
            % parameters : RobertsonParameters
            %    The parameters.
            %
            % Returns
            % -------
            % obj : RobertsonProblem
            %    The constructed problem.
            obj@otp.Problem('Robertson', 3, timeSpan, y0, parameters);
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
