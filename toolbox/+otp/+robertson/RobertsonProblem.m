classdef RobertsonProblem < otp.Problem
    % A simple, stiff chemical reaction.
    % 
    % The Robertson problem :cite:p:`Rob66` is a simple, stiff chemical reaction that models the concentrations of
    % chemical species $\ce{A}$, $\ce{B}$, and $\ce{C}$ involved in the reactions
    %
    % $$
    % \ce{
    % A &->[$k_1$] B \\
    % B + B &->[$k_2$] C + B \\
    % B + C &->[$k_3$] A + C
    % }
    % $$
    %
    % These correspond to the ODE system, 
    % 
    % $$ 
    % y_1' &= -k_1 y_1 + k_3  y_2 y_3, \\
    % y_2' &= k_1 y_1 - k_2 y_2^2 - k_3 y_2 y_3, \\
    % y_3' &= k_2 y_2^2.
    % $$
    %
    % The reaction rates $k_1$, $k_2$, and $k_3$ often range from slow to very fast which makes the problem challenging.
    % This has made it a popular test for implicit time-stepping schemes.
    % 
    % Notes
    % -----
    % +---------------------+-------------------------------------------------+
    % | Type                | ODE                                             |
    % +---------------------+-------------------------------------------------+
    % | Number of Variables | 3                                               |
    % +---------------------+-------------------------------------------------+
    % | Stiff               | typically, depending on $k_1$, $k_2$, and $k_3$ |
    % +---------------------+-------------------------------------------------+
    %
    % Example
    % -------
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
            % parameters : otp.robertson.RobertsonParameters
            %    The parameters.
            
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
