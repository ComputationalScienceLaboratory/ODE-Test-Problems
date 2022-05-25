classdef QuasiGeostrophicProblem < otp.Problem
    
    methods
        function obj = QuasiGeostrophicProblem(timeSpan, y0, parameters)
            
            obj@otp.Problem('Quasi-geostrophic Model', [], ...
                timeSpan, y0, parameters);
            
        end
    end
    
    properties (SetAccess = private)
        RHSADLES
        DistanceFunction
        FlowVelocityMagnitude
        JacobianFlowVelocityMagnitudeVectorProduct
    end
    
    methods (Static)
        
        function u = resize(u, newsize)
            % resize uses interpolation to resize states
            
            s = size(u);

            X = linspace(0, 1, s(1) + 2);
            Y = linspace(0, 2, s(2) + 2).';
            X = X(2:end-1);
            Y = Y(2:end-1);

            Xnew = linspace(0, 1, newsize(1) + 2);
            Ynew = linspace(0, 2, newsize(2) + 2).';
            Xnew = Xnew(2:end-1);
            Ynew = Ynew(2:end-1);

            u = interp2(Y, X, u, Ynew, Xnew);
            
        end
      
    end
    
    methods (Access = protected)
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            validateNewState@otp.Problem(obj, newTimeSpan, newY0, ...
                newParameters);
            
            y0Len = length(newY0);
            gridPts = newParameters.Nx * newParameters.Ny;
            
            if y0Len ~= gridPts
                warning('OTP:inconsistentNumVars', ...
                    'NumVars is %d, but there are %d grid points', ...
                    y0Len, gridPts);
            end
        end
        
        function onSettingsChanged(obj)
            
            nx = obj.Parameters.Nx;
            ny = obj.Parameters.Ny;
            
            Re = obj.Parameters.ReynoldsNumber;
            Ro = obj.Parameters.RossbyNumber;
                        
            hx = 1/(nx + 1);
            hy = 2/(ny + 1);
            
            xdomain = [0, 1];
            ydomain = [0, 2];
            
            bc = 'DD';
            
            % create the spatial derivatives
            Dx = otp.utils.pde.Dd(nx, xdomain, 1, 1, bc(1));
            DxT = Dx.';
            
            Dy  = otp.utils.pde.Dd(ny, ydomain, 1, 1, bc(2));
            DyT = Dy.';
            
            % create the x and y Laplacians
            Lx = otp.utils.pde.laplacian(nx, xdomain, 1, bc(1));
            Ly = otp.utils.pde.laplacian(ny, ydomain, 1, bc(2));

            % make Dx, Dy, Lx, and Ly full as pagemtimes does not support sparse
            Dx  = full(Dx);
            DxT = full(DxT);
            Dy  = full(Dy);
            DyT = full(DyT);
            Lx  = full(Lx);
            Ly  = full(Ly);
            
            % Do decompositions for the eigenvalue sylvester method. See
            %
            %       Kirsten, Gerhardus Petrus. Comparison of methods for solving Sylvester systems. Stellenbosch University, 2018.
            %
            % for a detailed method, the "Eigenvalue Method" which makes this particularly efficient.
            
            hx2 = hx^2;
            hy2 = hy^2;
            cx = (1:nx)/(nx + 1);
            cy = (1:ny)/(ny + 1);
            L12 = -(hx2*hy2./(2*(-hx2 - hy2 + hy2*cos(pi*cx).' + hx2*cos(pi*cy))));
            P1 = sqrt(2/(nx + 1))*sin(pi*(1:nx).'*(1:nx)/(nx + 1));
            P2 = sqrt(2/(ny + 1))*sin(pi*(1:ny).'*(1:ny)/(ny + 1));
            
            ys = linspace(ydomain(1), ydomain(end), ny + 2);
            ys = ys(2:end-1);
            
            ymat = repmat(ys.', 1, nx);
            F = sin(pi*(ymat.' - 1));
            
            obj.RHS = otp.RHS(@(t, psi) ...
                otp.qg.f(psi, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, F, Re, Ro), ...
                ...
                'JacobianVectorProduct', @(t, psi, v) ...
                otp.qg.jacobianVectorProduct(psi, v, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, F, Re, Ro), ...
                ...
                'JacobianAdjointVectorProduct', @(t, psi, v) ...
                otp.qg.jacobianAdjointVectorProduct(psi, v, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, F, Re, Ro));
            

            %% AD LES
            adpasses = obj.Parameters.ADPasses;
            adlambda = obj.Parameters.ADLambda;

            adcoeffs = arrayfun(@(k) (-1)^(k + 1) * nchoosek(adpasses + 1, k), ...
                1:(adpasses + 1));

            % Equivalent to solving I - (lambda*hx)^2 L
            L12filter = -(hx2*hy2./(-hx2*hy2 + 2*((adlambda^2)*hx2)*(-hx2 - hy2 + hy2*cos(pi*cx).' + hx2*cos(pi*cy))));

            Fbar = P1*(L12filter.*(P1*F*P2))*P2;

            obj.RHSADLES = otp.RHS(@(t, psi) ...
                otp.qg.fApproximateDeconvolution(psi, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, F, Re, Ro, adcoeffs, L12filter, Fbar));

            %% Distance function, and flow velocity
            obj.DistanceFunction = @(t, y, i, j) otp.qg.distanceFunction(t, y, i, j, nx, ny);
            
            obj.FlowVelocityMagnitude = @(psi) otp.qg.flowVelocityMagnitude(psi, Dx, Dy);
            
            obj.JacobianFlowVelocityMagnitudeVectorProduct = @(psi, u) otp.qg.jacobianFlowVelocityMagnitudeVectorProduct(psi, u, Dx, Dy);
            
        end
        
        function label = internalIndex2label(obj, index)
            
            [i, j] = ind2sub([obj.Parameters.nx, obj.Parameters.ny], index);
            
            label = sprintf('(%d, %d)', i, j);
            
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end
        
    end
end
