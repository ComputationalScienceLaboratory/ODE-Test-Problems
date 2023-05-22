classdef KortewegDeVriesProblem < otp.Problem
    
    methods
        function obj = KortewegDeVriesProblem(timeSpan, y0, parameters)
            
            obj@otp.Problem('Korteweg de Vries', [], ...
                timeSpan, y0, parameters);
            
        end
    end
    
    properties (SetAccess = private)
        DistanceFunction
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
            
            %Re = obj.Parameters.ReynoldsNumber;
            %Ro = obj.Parameters.RossbyNumber;
         
            [A, B] = otp.utils.pde.gfdm.getAB(mesh, meshBC, order, weightfun, hfun);

            obj.RHS = otp.RHS(@(t, u) ...
                otp.kortewegdevries.f(t, u, BC, meshBC, A, B, theta, alpha, nu, rho));

            %% Distance function
            obj.DistanceFunction = @(t, y, i, j) otp.quasigeostrophic.distanceFunction(t, y, i, j, nx, ny);
        end
        
        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Solver', otp.utils.Solver.Nonstiff, varargin{:});
        end
        
    end
end
