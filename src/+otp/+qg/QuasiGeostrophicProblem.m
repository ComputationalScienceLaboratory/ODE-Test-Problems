classdef QuasiGeostrophicProblem < otp.Problem
    
    methods
        function obj = QuasiGeostrophicProblem(timeSpan, y0, parameters)
            
            obj@otp.Problem('Quasi-geostrophic Model', [], ...
                timeSpan, y0, parameters);
            
        end
    end
    
    properties (SetAccess = private)
        DistanceFunction
        FlowVelocityMagnitude
        JacobianFlowVelocityMagnitudeVectorProduct
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
            
            nx = obj.Parameters.Nx;
            ny = obj.Parameters.Ny;
            
            Re = obj.Parameters.Re;
            Ro = obj.Parameters.Ro;
                        
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
                otp.qg.jacobianvectorproduct(psi, v, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, F, Re, Ro), ...
                ...
                'JacobianAdjointVectorProduct', @(t, psi, v) ...
                otp.qg.jacobianadjointvectorproduct(psi, v, Lx, Ly, P1, P2, L12, Dx, DxT, Dy, DyT, F, Re, Ro));
            

            %% Distance function, and flow velocity
            obj.DistanceFunction = @(t, y, i, j) otp.qg.distfn(t, y, i, j, nx, ny);
            
            obj.FlowVelocityMagnitude = @(psi) otp.qg.flowvelmag(psi, Dx, Dy);
            
            obj.JacobianFlowVelocityMagnitudeVectorProduct = @(psi, u) otp.qg.jacflowvelmagvp(psi, u, Dx, Dy);
            
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
