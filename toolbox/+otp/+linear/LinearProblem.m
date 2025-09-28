classdef LinearProblem < otp.Problem
    % A linear, constant coefficient, homogeneous ODE which supports a partitioned right-hand side.
    %
    % The linear problem is given by
    %
    % $$
    % y' = \sum_{i=1}^{p} Λ_i y,
    % $$
    %
    % where $p$ is the number of partitions and $Λ_i ∈ ℂ^{N × N}$ for $i = 1, …, p$.
    % 
    % This is often used to assess the stability of time integration methods, with the case of $p = N = 1$ referred to
    % as the Dahlquist test problem.
    %
    % Notes
    % -----
    % +---------------------+----------------------------------------------------------------+
    % | Type                | ODE                                                            |
    % +---------------------+----------------------------------------------------------------+
    % | Number of Variables | arbitrary                                                      |
    % +---------------------+----------------------------------------------------------------+
    % | Stiff               | possibly, depending on the eigenvalues of $\sum_{i=1}^{p} Λ_i$ |
    % +---------------------+----------------------------------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.linear.presets.Canonical('Lambda', {-1, -2, -3});
    % >>> problem.RHSPartitions{2}.JacobianMatrix
    % ans = -2

    properties (SetAccess = private)
        % A cell array of $p$ right-hand sides for each partition $Λ_i y$.
        RHSPartitions
    end
    
    properties (Dependent)
        % The number of partitions $p$.
        NumPartitions
    end
    
    methods
        function obj = LinearProblem(timeSpan, y0, parameters)
            % Create a linear problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(:, 1)
            %    The initial conditions.
            % parameters : otp.linear.LinearParameters
            %    The parameters.
            
            obj@otp.Problem('Linear', [], timeSpan, y0, parameters);
        end
        
        function p = get.NumPartitions(obj)
            p = length(obj.Parameters.Lambda);
        end
    end
    
    methods (Access = private)
        function lambdaSum = computeASum(obj)
            lambdaSum = obj.Parameters.Lambda{1};
            for i = 2:obj.NumPartitions
                lambdaSum = lambdaSum + obj.Parameters.Lambda{i};
            end
        end
        
        function rhs = createRHS(~, lambda)
            rhs = otp.RHS(@(~, y) lambda * y, ...
                'Jacobian', lambda, ...
                'JacobianVectorProduct', @(~, ~, v) lambda * v, ...
                'JacobianAdjointVectorProduct', @(~, ~, v) lambda' * v, ...
                'Vectorized', 'on');
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            obj.RHS = obj.createRHS(obj.computeASum());
            % OCTAVE FIX: class arrays are not supported so a cell array must be use
            obj.RHSPartitions = cellfun(@obj.createRHS, obj.Parameters.Lambda, 'UniformOutput', false);
        end
        
        function y = internalSolveExactly(obj, t)
            for i = length(t):-1:1
                y(:, i) = expm((t(i) - obj.TimeSpan(1)) * obj.RHS.Jacobian) * obj.Y0;
            end
        end
    end
end
