classdef Canonical  < otp.lotkavolterra.LotkaVolterraProblem

    methods
        function obj = Canonical(varargin)
            y0 = [1; 2];
            tspan = [0 50];
            params = otp.lotkavolterra.LotkaVolterraParameters( ...
                'PreyBirthRate', 1, ...
                'PreyDeathRate', 1, ...
                'PredatorDeathRate', 1, ...
                'PredatorBirthRate', 1, ...
                varargin{:});
            obj = obj@otp.lotkavolterra.LotkaVolterraProblem(tspan, y0, params);
        end
    end
    
end
