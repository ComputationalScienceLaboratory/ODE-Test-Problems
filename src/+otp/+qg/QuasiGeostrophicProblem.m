classdef QuasiGeostrophicProblem < otp.Problem
    
    methods
        function obj = QuasiGeostrophicProblem(timeSpan, y0, parameters)
            
            obj@otp.Problem('Quasi-geostrophic Model', [], ...
                timeSpan, y0, parameters);
            
        end
    end
    
    properties
        DistanceFunction
        FlowVelocityMagnitude
        JacobianFlowVelocityMagnitudeVectorProduct
        RhsAD
    end
    
    methods (Static)
        
        function [nx, ny] = name2size(name)
            
            switch name
                case 'atomic'
                    nx = 3;
                case 'miniscule'
                    nx = 7;
                case 'tiny'
                    nx = 15;
                case 'small'
                    nx = 31;
                case 'medium'
                    nx = 63;
                case 'large'
                    nx = 127;
                case 'huge'
                    nx = 255;
                case 'monsterous'
                    nx = 511;
                case 'bigly'
                    nx = 1023;
                otherwise
                    error('Cannot convert string to grid sizes');
            end
            
            ny = 2*nx + 1;
            
        end
        
        function u = relaxprolong(u, newsizename)
            
            s1 = size(u, 1);
            
            [s2x, s2y] = otp.qg.QuasiGeostrophicProblem.name2size(newsizename);
            
            size2n = @(s) round(log2((round(sqrt(1 + 8*s)) + 3)/4));
            
            n1 = size2n(s1);
            n2 = size2n(s2x*s2y);
            
            if n1 > n2
                
                for i = 1:(n1 - n2)
                    
                    ni = n1 - i + 1;
                    
                    six = 2^ni - 1;
                    siy = 2^(ni + 1) - 1;
                    
                    sjx = 2^(ni - 1) - 1;
                    sjy = 2^ni - 1;
                    
                    [If2c, ~] = otp.utils.pde.relaxprolong2D(six, sjx, siy, sjy);
                    
                    u = If2c*u;
                    
                end
                
            elseif n1 < n2
                
                for i = 1:(n2 - n1)
                    
                    ni = n1 + i - 1;
                    
                    six = 2^ni - 1;
                    siy = 2^(ni + 1) - 1;
                    
                    sjx = 2^(ni + 1) - 1;
                    sjy = 2^(ni + 2) - 1;
                    
                    [~, Ic2f] = otp.utils.pde.relaxprolong2D(sjx, six, sjy, siy);
                    
                    u = Ic2f*u;
                    
                end
                
            end
            
        end
        
    end
    
    methods (Access = protected)
        
        function onSettingsChanged(obj)
            
            nx = obj.Parameters.nx;
            ny = obj.Parameters.ny;
            
            Re = obj.Parameters.Re;
            Ro = obj.Parameters.Ro;
            
            lambda = obj.Parameters.les.lambda;
            passes = obj.Parameters.les.passes;
            %dfiltertype = obj.Parameters.les.filtertype;
            
            n = [nx, ny];
            
            hx = 1/(nx + 1);
            hy = 2/(ny + 1);
            
            xdomain = [0, 1];
            ydomain = [0, 2];
            
            domain = [0, 1; 0, 2];
            diffc = [1, 1];
            bc = 'DD';
            
            % create Laplacian
            L = otp.utils.pde.laplacian(n, domain, diffc, bc);
            Ddx = otp.utils.pde.Dd(n, xdomain, 1, 2, bc(1));
            Ddy = otp.utils.pde.Dd(n, ydomain, 2, 2, bc(2));
            
            Dx = otp.utils.pde.Dd(nx, xdomain, 1, 1, bc(1));
            
            % The transpose here is important
            DyT = otp.utils.pde.Dd(ny, ydomain, 1, 1, bc(2)).';
            
            % create the x and y Laplacians
            Lx = otp.utils.pde.laplacian(nx, xdomain, 1, bc(1));
            Ly = otp.utils.pde.laplacian(ny, ydomain, 1, bc(2));
            
            % do a Cholesky decomposition on the negative laplacian
            [RdnL, ~, PdnL] = chol(-L);
            RdnLT = RdnL.';
            PdnLT = PdnL.';
            
            % do decompositions for the eigenvalue sylvester method. see
            %
            % Kirsten, Gerhardus Petrus. Comparison of methods for solving Sylvester systems. Stellenbosch University, 2018.
            %
            % for a detailed method, the "Eigenvalue Method" which makes this
            % particularly efficient
            
            %nfLx = -full(Lx);
            %nfLy = -full(Ly);
            %[P1, Lambda] = eig(nfLx);
            %[P2, D] = eig(nfLy);
            
            % We can represent the eigenvalues as
            dLambda = (4/(hx^2) * (sin(pi*(1:nx)/(2*(nx + 1))).^2)).';
            dD = (4/(hy^2) * (sin(pi*(1:ny)/(2*(ny + 1))).^2)).';
            L12 = 1./(dLambda + dD.');
            P1 = sqrt(2/(nx + 1))*sin((1:nx).'*(1:nx)*pi/(nx + 1));
            P2 = sqrt(2/(ny + 1))*sin((1:ny).'*(1:ny)*pi/(ny + 1));


            %L12 = 1./(diag(Lambda) + diag(D).');
            %P1T = P1.';
            %P2T = P2.';
            
            ys = linspace(ydomain(1), ydomain(end), ny + 2);
            ys = ys(2:end-1);
            
            ymat = repmat(ys.', 1, nx);
            %ymat = reshape(ymat.', prod(n), 1);
            %F = sin(pi*(ymat - 1));
            F = sin(pi*(ymat.' - 1));
            
            obj.Rhs = otp.Rhs(@(t, psi) ...
                otp.qg.f(psi, Lx, Ly, P1, P2, L12, Dx, DyT, F, Re, Ro), ...
                ...
                otp.Rhs.FieldNames.JacobianVectorProduct, @(t, psi, u) ...
                otp.qg.jvp(psi, u, L, RdnL, PdnL, Ddx, Ddy, Re, Ro), ...
                ...
                otp.Rhs.FieldNames.JacobianAdjointVectorProduct, @(t, psi, u) ...
                otp.qg.javp(psi, u, L, RdnL, PdnL, Ddx, Ddy, Re, Ro));
            

            % AD LES
            fmat = speye(prod(n)) - ((lambda*hx)^2)*L;
            
            [Rfmat, ~, Pfmat] = chol(fmat);
            RfmatT = Rfmat.';
            PfmatT = Pfmat.';
            
            if ~isfield(obj.Parameters, 'filter') || isempty(obj.Parameters.filter)
                filter = @(u) Pfmat*(Rfmat\(RfmatT\(PfmatT*u)));
            else
                filter = obj.Parameters.filter;
            end
            
            Fbar = filter(reshape(F, nx*ny, 1));
            obj.RhsAD = otp.Rhs(@(t, psi) ...
                   otp.qg.fAD(psi, L, RdnL, RdnLT, PdnL, PdnLT, Ddx, Ddy, Fbar, Re, Ro, filter, passes));

            %% Distance function, and flow velocity
            obj.DistanceFunction = @(t, y, i, j) otp.qg.distfn(t, y, i, j, nx, ny);
            
            obj.FlowVelocityMagnitude = @(psi) otp.qg.flowvelmag(psi, Ddx, Ddy);
            
            obj.JacobianFlowVelocityMagnitudeVectorProduct = @(psi, u) otp.qg.jacflowvelmagvp(psi, u, Ddx, Ddy);
            
        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            
            validateNewState@otp.Problem(obj, ...
                newTimeSpan, newY0, newParameters)
            
            otp.utils.StructParser(newParameters) ...
                .checkField('nx', 'finite', 'scalar', 'integer', 'positive') ...
                .checkField('ny', 'finite', 'scalar', 'integer', 'positive') ...
                .checkField('Re', 'finite', 'scalar', 'real', 'positive') ...
                .checkField('Ro', 'finite', 'scalar', 'real');
            
        end
        
        function label = internalIndex2label(obj, index)
            
            [i, j] = ind2sub([obj.Parameters.nx, obj.Parameters.ny], index);
            
            label = sprintf('(%d, %d)', i, j);
            
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
        end
        
    end
end
