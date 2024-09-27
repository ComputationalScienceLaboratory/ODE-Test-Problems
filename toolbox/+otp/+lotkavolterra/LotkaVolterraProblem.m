classdef LotkaVolterraProblem < otp.Problem
    % A two-variable model for predator-prey interactions.
    %
    % The Lotka-Volterra model :cite:p:`Lotka1925,Volterra1926` is a model describing the interaction of two populations.
    % The predator and the prey are evolving according to the following differential equation:
    %
    % $$
    % \begin{aligned}
    % \frac{dy_1}{dt} &= \alpha y_1 - \beta y_1 y_2 \\
    % \frac{dy_2}{dt} &= \delta y_1 y_2 - \gamma y_2
    % \end{aligned}
    % $$
    %
    % where, $y_1$ and $y_2$ are the populations of the prey and the predator, respectively. The parameters $\alpha$, $\beta$,
    % $\gamma$, and $\delta$ are positive real numbers representing the growth rate of the prey, the rate at which the predator
    % consumes the prey, the death rate of the predator, and the rate at which the predator reproduces, respectively.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------+
    % | Type                | ODE                                     |
    % +---------------------+-----------------------------------------+
    % | Number of Variables | 2                                       |
    % +---------------------+-----------------------------------------+
    % | Stiff               | not typically, depending on parameters  |
    % +---------------------+-----------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.lotkavolterra.presets.Canonical;
    % >>> problem.TimeSpan(end) = 15;
    % >>> sol = problem.solve();
    % >>> problem.plotPhaseSpace(sol);
    
    methods
        function obj = LotkaVolterraProblem(timeSpan, y0, parameters)
            % Creates a Lotka-Volterra problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(2, 1)
            %    The initial conditions.
            % parameters : LotkaVolterraParameters
            %    The parameters.
            
            obj@otp.Problem('Lotka-Volterra', 2, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            
            preyBirthRate     = obj.Parameters.PreyBirthRate;
            preyDeathRate     = obj.Parameters.PreyDeathRate;
            predatorDeathRate = obj.Parameters.PredatorDeathRate; 
            predatorBirthRate = obj.Parameters.PredatorBirthRate; 
            
            obj.RHS = otp.RHS(@(t, y) otp.lotkavolterra.f(t, y, preyBirthRate, preyDeathRate, predatorDeathRate, predatorBirthRate), ...
                'Jacobian', ...
                @(t, y) otp.lotkavolterra.jacobian(t, y, preyBirthRate, preyDeathRate, predatorDeathRate, predatorBirthRate), ...
                'Vectorized', 'on');
            
        end

        function label = internalIndex2label(~, index)
            
            if index == 1
                label = 'Prey';
            else
                label = 'Predator';
            end
            
        end
        
        function sol = internalSolve(obj, varargin)
            
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
            
        end
    end
end
