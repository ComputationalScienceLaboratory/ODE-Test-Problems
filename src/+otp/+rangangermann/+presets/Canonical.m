classdef Canonical < otp.rangangermann.RangAngermannProblem
    %CANONICAL
    
    methods
        function obj = Canonical(varargin)
            
            p = inputParser;
            p.addParameter('Size', 256);

            % exact solution
            exactu = @(t, x, y) (2*x + y).*sin(t);
            exactv = @(t, x, y) (x + 3*y).*cos(t);

            p.parse(varargin{:});
            
            s = p.Results;
            n = s.Size;

            params = otp.rangangermann.RangAngermannParameters;
            params.Size = n;
            % the forcing functions are based on the excact solution
            params.ForcingU = @(t, x, y) (2*x + y).*cos(t) + 2*x.*sin(t) + y.*sin(t) ...
                - exactu(t, x, y) + exactv(t, x, y);
            params.ForcingV = @(t, x, y) exactu(t, x, y).^2 + exactv(t, x, y).^2;

            % the boundary conditions are the exact solutions
            params.BoundaryConditionsU = exactu;
            params.BoundaryConditionsV = exactv;

            x = linspace(0, 1, n + 2);
            y = linspace(0, 1, n + 2);
            [yfull, xfull] = meshgrid(x, y);

            x = xfull(2:(end-1), 2:(end-1));
            y = yfull(2:(end-1), 2:(end-1));
            uv0 = [reshape(exactu(0, x, y), [], 1); reshape(exactv(0, x, y), [], 1)];

            tspan = [0, 1];
            
            obj = obj@otp.rangangermann.RangAngermannProblem(tspan, uv0, params);
        end
    end
end
