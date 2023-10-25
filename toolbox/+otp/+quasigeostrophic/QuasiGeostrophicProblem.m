classdef QuasiGeostrophicProblem < otp.Problem
    % A chaotic PDE modeling the flow of a fluid on the earth.
    %
    % The governing partial differential equation that is discretized is,
    %
    % $$
    % Δψ_t = -J(ψ,ω) - {Ro}^{-1} ψ_x -{Re}^{-1} Δω - {Ro}^{-1} F, \\
    % $$
    % where the Jacobian term is a quadratic function,
    % $$
    % J(ψ,ω) \equiv ψ_x ω_y - ψ_y ω_x,
    % $$
    % the relationship between the vorticity $ω$ and the stream function $ψ$ is
    % $$
    % ω = -Δψ,
    % $$
    % the term $Δ$ is the two dimensional Laplacian over the
    % discretization, $Ro$ is the Rossby number, $Re$ is the Reynolds
    % number, and $F$ is a forcing term.
    % The spatial domain is fixed to $x ∈ [0, 1]$ and $y ∈ [0, 2]$, and
    % the boundary conditions of the PDE are assumed to be zero dirichlet
    % everywhere.
    %
    % A second order finite difference approximation is performed on the
    % grid to create the first derivative operators and the Laplacian
    % operator. The Jacobian is discretized using the Arakawa approximation
    % CITEME 
    % $$
    % J(ψ,ω) = \frac{1}{3}[ψ_x ω_y - ψ_y ω_x + (ψ ω_y)_x - (ψ ω_x)_y + (ψ_x ω)_y - (ψ_y ω)_x],
    % $$
    % in order for the system to not become unstable.
    %
    % The Poisson equation is solved by the eigenvalue sylvester method for
    % computational efficiency.
    %
    % A ADLES MORE HERE.
    %
    % Notes
    % -----
    % +---------------------+-----------------------------------------------------------+
    % | Type                | ODE                                                       |
    % +---------------------+-----------------------------------------------------------+
    % | Number of Variables | $nx \times ny$                                            |
    % +---------------------+-----------------------------------------------------------+
    % | Stiff               | not typically, depending on $Re$, $Ro$, $Nx$, and $Ny$    |
    % +---------------------+-----------------------------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.quasigeostrophic.presets.PopovMouSanduIliescu;
    % >>> sol = problem.solve();
    % >>> problem.movie(sol);
    %

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
        JacobianFlowVelocityMagnitudeAdjointVectorProduct
    end
    
    methods (Static)
        
        function psi = resize(psi, newsize)
            % Resizes the state onto a new grid by performing interpolation
            %
            % Parameters
            % ----------
            % psi : numeric(nx, ny)
            %     the old state on the $x \times y$ grid.
            % newsize : numeric(1, 2)
            %      the new size as a two-tuple $[nx, ny]$ indicating the new state of the system.
            %

            s = size(psi);

            X = linspace(0, 1, s(1) + 2);
            Y = linspace(0, 2, s(2) + 2).';
            X = X(2:end-1);
            Y = Y(2:end-1);

            Xnew = linspace(0, 1, newsize(1) + 2);
            Ynew = linspace(0, 2, newsize(2) + 2).';
            Xnew = Xnew(2:end-1);
            Ynew = Ynew(2:end-1);

            psi = interp2(Y, X, psi, Ynew, Xnew);
            
        end
      
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            
            nx = obj.Parameters.Nx;
            ny = obj.Parameters.Ny;
            gridPts = nx * ny;
            
            if obj.NumVars ~= gridPts
                warning('OTP:inconsistentNumVars', ...
                    'NumVars is %d, but there are %d grid points', ...
                    obj.NumVars, gridPts);
            end
            
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
            
            % define the ydomain for the external force
            ys = linspace(ydomain(1), ydomain(end), ny + 2);
            ys = ys(2:end-1);
            
            % compute the external force
            ymat = repmat(ys.', 1, nx);
            F = sin(pi*(ymat.' - 1));

            % OCTAVE FIX: find out if the function pagemtimes exists, and
            % if it does not, replace it with a compatible function
            if exist('pagemtimes', 'builtin') == 0
                pmt = @otp.utils.compatibility.pagemtimes;
            else
                pmt = @pagemtimes;
            end
            
            obj.RHS = otp.RHS(@(t, psi) ...
                otp.quasigeostrophic.f(psi, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, F, Re, Ro, pmt), ...
                ...
                'JacobianVectorProduct', @(t, psi, v) ...
                otp.quasigeostrophic.jacobianVectorProduct(psi, v, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, F, Re, Ro, pmt), ...
                ...
                'JacobianAdjointVectorProduct', @(t, psi, v) ...
                otp.quasigeostrophic.jacobianAdjointVectorProduct(psi, v, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, F, Re, Ro, pmt));
            

            %% AD LES
            adpasses = obj.Parameters.ADPasses;
            adlambda = obj.Parameters.ADLambda;

            adcoeffs = arrayfun(@(k) (-1)^(k + 1) * nchoosek(adpasses + 1, k), ...
                1:(adpasses + 1));

            % Equivalent to solving I - (lambda*hx)^2 L
            L12filter = -(hx2*hy2./(-hx2*hy2 + 2*((adlambda^2)*hx2)*(-hx2 - hy2 + hy2*cos(pi*cx).' + hx2*cos(pi*cy))));

            Fbar = P1*(L12filter.*(P1*F*P2))*P2;

            obj.RHSADLES = otp.RHS(@(t, psi) ...
                otp.quasigeostrophic.fApproximateDeconvolution(psi, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, F, Re, Ro, pmt, adcoeffs, L12filter, Fbar));

            %% Distance function, and flow velocity
            obj.DistanceFunction = @(t, y, i, j) otp.quasigeostrophic.distanceFunction(t, y, i, j, nx, ny);
            
            obj.FlowVelocityMagnitude = @(psi) otp.quasigeostrophic.flowVelocityMagnitude(psi, Dx, Dy);
            
            obj.JacobianFlowVelocityMagnitudeVectorProduct = @(psi, u) otp.quasigeostrophic.jacobianFlowVelocityMagnitudeVectorProduct(psi, u, Dx, Dy);

            obj.JacobianFlowVelocityMagnitudeAdjointVectorProduct = @(psi, u) otp.quasigeostrophic.jacobianFlowVelocityMagnitudeAdjointVectorProduct(psi, u, Dx, Dy);

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
