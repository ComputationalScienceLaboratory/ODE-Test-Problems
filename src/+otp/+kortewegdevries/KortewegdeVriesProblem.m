classdef KortewegdeVriesProblem < otp.Problem

    % Ascher, Uri M. and Robert I. McLachlan. “On Symplectic and 
    % Multisymplectic Schemes for the KdV Equation.” 
    % Journal of Scientific Computing 25 (2005): 83-104.
    %
    % Robert M. Miura, Clifford S. Gardner, Martin D. Kruskal;
    % Korteweg‐de Vries Equation and Generalizations. II. 
    % Existence of Conservation Laws and Constants of Motion. 
    % J. Math. Phys. 1 August 1968; 9 (8): 1204–1209. 
    % https://doi.org/10.1063/1.1664701

    methods
        function obj = KortewegdeVriesProblem(timeSpan, y0, parameters)
            
            obj@otp.Problem('Korteweg de Vries Equation', [], ...
                timeSpan, y0, parameters);
            
        end
    end
    
    properties (SetAccess = private)
        DistanceFunction
        numInvariants
        Invariant
        JacobianInvariant
    end
    
    methods (Static)
      
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
                        
            Xdomain = obj.Parameters.Domain;
            Nx = obj.Parameters.Nx;
            Theta = obj.Parameters.Theta;
            Alpha = obj.Parameters.Alpha;
            Nu = obj.Parameters.Nu;
            Rho = obj.Parameters.Rho;

            if obj.NumVars ~= Nx
                warning('OTP:inconsistentNumVars', ...
                    'NumVars is %d, but there are %d grid points', ...
                    obj.NumVars, Nx);
            end
            
            bc = 'C';
            
            Dx = otp.utils.pde.Dd(Nx, Xdomain, 1, 1, bc);
            DxT = Dx.';
            
            dx = obj.Parameters.Grid(2) - obj.Parameters.Grid(1);

            % NO support for 3rd derivative central difference in utils

            xx = sparse(1, Nx);
            xx(2) = -1;
            xx(3) = 1/2;
            xx(Nx) = 1;
            xx(Nx-1) = -1/2;
            xx = xx/(dx*dx*dx);
            D3x = toeplitz([xx(1) fliplr(xx(2:end))], xx);
            D3xT = D3x.'; 

            % NO support for 1st derivative forward difference in utils

            xx2 = sparse(1, Nx);
            xx2(1) = -1;
            xx2(2) = 1;
            xx2 = xx2/dx;
            Dxf = toeplitz([xx2(1) fliplr(xx2(2:end))], xx2);

            obj.RHS = otp.RHS(@(t, u) ...
                otp.kortewegdevries.f(t, u, Theta, Alpha, Nu, Rho, Dx, D3x), ...
                'Jacobian', @(t, u) ...
                otp.kortewegdevries.jacobian(t, u, Theta, Alpha, Nu, Rho, Dx, D3x, Nx), ...
                'JacobianVectorProduct', @(t, u, v) ...
                otp.kortewegdevries.jacobianVectorProduct(t, u, v, Theta, Alpha, Nu, Rho, Dx, D3x), ...
                'JacobianAdjointVectorProduct', @(t, u, v) ...
                otp.kortewegdevries.jacobianAdjointVectorProduct(t, u, v, Theta, Alpha, Nu, Rho, Dx, DxT, D3xT));

            %% Distance function, and invariants
            Dsize = Xdomain(2) - Xdomain(1);
            obj.DistanceFunction = @(i, j) otp.kortewegdevries.distanceFunction(i, j, obj.Parameters.Grid, Dsize);

            obj.numInvariants = 3;
            obj.Invariant = @(u) otp.kortewegdevries.invariant(u, Alpha, Nu, Rho, Dxf, dx);
            obj.JacobianInvariant = @(u) otp.kortewegdevries.jacobianInvariant(u, Alpha, Nu, Rho, Dxf, dx, Nx);

        end
        
        % Need a method that preseves invariants.
        % Implicit midpoint is good

        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end
        
    end
end
