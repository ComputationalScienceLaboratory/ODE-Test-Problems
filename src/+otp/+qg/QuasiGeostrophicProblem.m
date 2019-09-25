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
    end
    
    methods (Access = protected)
        
        function onSettingsChanged(obj)
            
            nx = obj.Parameters.nx;
            ny = obj.Parameters.ny;

            Re = obj.Parameters.Re;        
            Ro = obj.Parameters.Ro;
            
            n = [nx, ny];

            xdomain = [0, 1];
            ydomain = [0, 2];
            
            domain = [0, 1; 0, 2];
            diffc = [1, 1];
            bc = 'DD';
            
            % create laplacian
            L = otp.utils.pde.laplacian(n, domain, diffc, bc);
            Ddx = otp.utils.pde.Dd(n, xdomain, 1, 2, bc(1));
            Ddy = otp.utils.pde.Dd(n, ydomain, 2, 2, bc(2));
                        
            % do a Cholesky decomposition on the negative laplacian
            [RdnL, ~, PdnL] = chol(-L);
            
            
            ys = linspace(ydomain(1), ydomain(end), ny + 2);
            ys = ys(2:end-1);
            
            ymat = repmat(ys.', 1, nx);
            ymat = reshape(ymat.', prod(n), 1);

            obj.Rhs = otp.Rhs(@(t, psi) ...
                otp.qg.f(psi, L, RdnL, PdnL, Ddx, Ddy, ymat, Re, Ro), ...
                ...
                otp.Rhs.FieldNames.JacobianVectorProduct, @(t, psi, u) ...
                otp.qg.jvp(psi, u, L, RdnL, PdnL, Ddx, Ddy, Re, Ro), ...
                ...
                otp.Rhs.FieldNames.JacobianAdjointVectorProduct, @(t, psi, u) ...
                otp.qg.javp(psi, u, L, RdnL, PdnL, Ddx, Ddy, Re, Ro) ...
                );
            
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
        
    end
end
