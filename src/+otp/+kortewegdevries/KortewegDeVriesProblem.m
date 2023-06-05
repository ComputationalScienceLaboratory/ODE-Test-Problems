classdef KortewegDeVriesProblem < otp.Problem
    
    methods
        function obj = KortewegDeVriesProblem(timeSpan, y0, parameters)
            
            obj@otp.Problem('Korteweg de Vries', [], ...
                timeSpan, y0, parameters);
            
        end
    end
    
    properties (SetAccess = private)
        DistanceFunction
        Invariant
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            
            mesh = obj.Parameters.GFDMMesh;
            meshBC = obj.Parameters.GFDMMeshBC;
            order = obj.Parameters.GFDMOrder;
            weightfun = obj.Parameters.GFDMWeightFun;
            hfun = obj.Parameters.GFDMHFun;
            BC = obj.Parameters.BCFun;
            theta = obj.Parameters.Theta;
            alpha = obj.Parameters.Alpha;
            nu = obj.Parameters.Nu;
            rho = obj.Parameters.Rho;

            gridPts = size(mesh, 2);
            
            if obj.NumVars ~= gridPts
                warning('OTP:inconsistentNumVars', ...
                    'NumVars is %d, but there are %d grid points', ...
                    obj.NumVars, gridPts);
            end
         
            [A, B] = otp.utils.pde.gfdm.getAB(mesh, meshBC, order, weightfun, hfun);

            obj.RHS = otp.RHS(@(t, u) ...
                otp.kortewegdevries.f(t, u, BC, meshBC, A, B, theta, alpha, nu, rho));

            %% Distance function and Invariant
            dist = @(x, y) abs(hfun(x, y));

            obj.DistanceFunction = @(t, y, i, j) dist(mesh(i), mesh(j));

            % find the volume of the full mesh
            meshfull = [mesh, meshBC];
            volume = 0;
            for i = 1:numel(mesh)
                ds = sort(dist(meshfull, mesh(i)), "ascend");
                volume = volume + sum(ds(1:3))/2;
            end

            obj.Invariant = @(t, u) ...
                otp.kortewegdevries.invariant(t, u, BC, meshBC, A, B, theta, alpha, nu, rho, volume);

        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end

        function mov = internalMovie(obj, t, y, varargin)
            % BUG This movie is technically broken, and will not work for
            % arbitrary meshes.
            mov = otp.utils.movie.LineMovie('title', obj.Name, varargin{:});
            mov.record(t, y);
        end
        
    end
end
