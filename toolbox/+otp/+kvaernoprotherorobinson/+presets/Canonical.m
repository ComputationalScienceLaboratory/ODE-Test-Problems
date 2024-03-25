classdef Canonical < otp.kvaernoprotherorobinson.KvaernoProtheroRobinsonProblem
    methods
        function obj = Canonical(varargin)
            y0 = [2; sqrt(3)];
            tspan = [0, 2.5 * pi];
            params = otp.kvaernoprotherorobinson.KvaernoProtheroRobinsonParameters('Omega', 20, ...
                'Lambda', -10 * eye(2), ...
                varargin{:});
            obj = obj@otp.kvaernoprotherorobinson.KvaernoProtheroRobinsonProblem(tspan, y0, params);
        end
    end
end