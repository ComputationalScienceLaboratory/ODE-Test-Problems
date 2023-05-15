classdef KortewegdeVriesProblem < otp.Problem
    % Describes the evolution of waves on shallow water surfaces. This problem is discretized on a periodic domain.
    %
    % u_t = a (th (u^2)_x + (1 - th)(2u) u_x) + r u_x + n u_xxx 
    %
    %  Ascher, Uri M. and Robert I. McLachlan. 
    %  "On Symplectic and Multisymplectic Schemes for the KdV Equation.” 
    %  Journal of Scientific Computing 25 (2005): 83-104.
    %
    %  Robert M. Miura, Clifford S. Gardner, Martin D. Kruskal;
    %  Korteweg‐de Vries Equation and Generalizations. II. Existence of Conservation Laws and Constants of Motion. 
    %  J. Math. Phys. 1 August 1968; 9 (8): 1204–1209. 
    %  https://doi.org/10.1063/1.1664701

    methods
        function obj = KortewegdeVriesProblem(timeSpan, y0, parameters)
            
            obj@otp.Problem('Korteweg de Vries', [], ...
                timeSpan, y0, parameters);
            
        end
    end
    
    properties (SetAccess = private)
        SpatialGrid
        DistanceFunction
        NumInvariants
        Invariant
        JacobianInvariant
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
                        
            xdomain = obj.Parameters.Domain;
            nx = obj.NumVars;
            theta = obj.Parameters.Theta;
            alpha = obj.Parameters.Alpha;
            nu = obj.Parameters.Nu;
            rho = obj.Parameters.Rho;

            xgrid = linspace(xdomain(1), xdomain(2), nx + 1).';
            xgrid = xgrid(1:nx);
            dx = xgrid(2) - xgrid(1);

            if obj.NumVars ~= nx
                warning('OTP:inconsistentNumVars', ...
                    'NumVars is %d, but there are %d grid points', ...
                    obj.NumVars, nx);
            end
            
            bc = 'C';
            Dx = otp.utils.pde.Dd(nx, xdomain, 1, 1, bc);
            DxT = Dx.';

            % NO support for 3rd derivative central difference in utils
            xx = sparse(1, nx);
            xx([nx-1, nx, 2, 3]) = ([-1/2, 1, -1, 1/2])/(dx*dx*dx);
            D3x = toeplitz([xx(1) fliplr(xx(2:end))], xx);
            D3xT = D3x.'; 

            % NO support for 1st derivative forward difference in utils

            xx2 = sparse(1, nx);
            xx2([1, 2]) = [-1, 1]/dx;
            Dxf = toeplitz([xx2(1) fliplr(xx2(2:end))], xx2);

            obj.RHS = otp.RHS(@(t, u) ...
                otp.kortewegdevries.f(t, u, theta, alpha, nu, rho, nx, Dx, D3x, DxT, D3xT), ...
                'Jacobian', @(t, u) ...
                otp.kortewegdevries.jacobian(t, u, theta, alpha, nu, rho, nx, Dx, D3x, DxT, D3xT), ...
                'JacobianVectorProduct', @(t, u, v) ...
                otp.kortewegdevries.jacobianVectorProduct(t, u, v, theta, alpha, nu, rho, nx, Dx, D3x, DxT, D3xT), ...
                'JacobianAdjointVectorProduct', @(t, u, v) ...
                otp.kortewegdevries.jacobianAdjointVectorProduct(t, u, v, theta, alpha, nu, rho, nx, Dx, D3x, DxT, D3xT));


            %% Distance function, and invariants
            domain_size = xdomain(2) - xdomain(1);
            obj.SpatialGrid = xgrid;
            obj.DistanceFunction = @(i, j) otp.kortewegdevries.distanceFunction(i, j, xgrid, domain_size);

            obj.NumInvariants = 3;
            obj.Invariant = @(u) otp.kortewegdevries.invariant(u, alpha, nu, rho, nx, Dxf, dx);
            obj.JacobianInvariant = @(u) otp.kortewegdevries.jacobianInvariant(u, alpha, nu, rho, nx, Dxf, dx);

        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Symplectic, varargin{:});
        end
        
    end
end
