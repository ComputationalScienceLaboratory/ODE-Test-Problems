classdef Rhs
    %RHS The right-hand side and related properties of an ODE
    %   This immutable class contains properties required by time integrators 
    %   and other numerical methods to treat the ODE y' = F(t, y). It includes
    %   many of the properties available in ODESET so that it can easily be used
    %   with MATLAB's ODE solvers.
    %
    %   See also ODESET
    
    properties (SetAccess = private)
        %F The function F in the ODE y' = F(t, y)
        %   F is a function handle with two input arguments: the time as a
        %   scalar and the state as a column vector.  It returns a column vector
        %   for the time derivative of the state.
        F
        
        % ---ODESET properties---
        
        Events
        InitialSlope
        
        %JACOBIAN The partial derivative of F with respect to y
        %   JACOBIAN is function handle or a matrix when it is independent of t
        %   and y.  In either case, it provides a square matrix in which element
        %   (i,j) is the partial derivative of F_i(t, y) with respect to y_j.
        %   If JACOBIAN is a function handle, it has two input arguments: the
        %   time as a scalar and the state as a column vector. 
        %
        %   See also ODESET
        Jacobian
        JPattern
        Mass
        MassSingular
        MStateDependence
        MvPattern
        NonNegative
        Vectorized
        
        % ---Custom properties---
        
        %JACOBIANVECTORPRODUCT The action of the Jacobian multiplying a vector
        %   JACOBIANVECTORPRODUCT is a function handle with three input
        %   arguments: the time as a scalar, the state as a column vector, and
        %   a column vector to multiply the Jacobian. It returns a column
        %   vector.  This offers an alternative approach to access the Jacobian
        %   when constructing and storing it as a matrix is impractical.
        JacobianVectorProduct
        
        %JACOBIANADJOINTVECTORPRODUCT The action of the Jacobian adjoint multiplying a vector
        %   JACOBIANADJOINTVECTORPRODUCT is a function handle with three input
        %   arguments: the time as a scalar, the state as a column vector, and a
        %   column vector to multiply the Jacobian. It returns a column vector.
        %   This is often helpful for sensitivity analysis and data
        %   assimilation.
        JacobianAdjointVectorProduct
        
        %PARTIALDERIVATIVEPARAMETERS The partial derivative of F with respect to parameters
        %   PARTIALDERIVATIVEPARAMETERS is a function handle with two input
        %   arguments: the time as a scalar and the state as a column vector. It
        %   returns a matrix
        PartialDerivativeParameters
        
        %PARTIALDERIVATIVETIME The partial derivative of F with respect to t
        %   PARTIALDERIVATIVETIME is a function handle with two input arguments:
        %   the time as a scalar and the state as a column vector. It returns a
        %   column vector in which row i is the partial derivative of F_i(t, y)
        %   with respect to t. Note this is not the total derivative with
        %   respect to t. PARTIALDERIVATIVETIME is often required by Rosenbrock
        %   methods when solving nonautonomous problems.
        PartialDerivativeTime
        HessianVectorProduct
        HessianAdjointVectorProduct
        OnEvent
    end
    
    methods
        function obj = Rhs(F, varargin)
            obj.F = F;
            extras = struct(varargin{:});
            fields = fieldnames(extras);
            
            for i = 1:length(fields)
                f = fields{i};
                obj.(f) = extras.(f);
            end
        end
        
        %ODESET Generates options for MATLAB's ODE solvers
        %   
        function opts = odeset(obj, varargin)
            opts = odeset( ...
                'Events', obj.Events, ...
                'InitialSlope', obj.InitialSlope, ...
                'Jacobian', obj.Jacobian, ...
                'JPattern', obj.JPattern, ...
                'Mass', obj.Mass, ...
                'MassSingular', obj.MassSingular, ...
                'MStateDependence', obj.MStateDependence, ...
                'MvPattern', obj.MvPattern, ...
                'NonNegative', obj.NonNegative, ...
                'Vectorized', obj.Vectorized, ...
                varargin{:});
        end
    end
end
