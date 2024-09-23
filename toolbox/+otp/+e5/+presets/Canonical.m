classdef Canonical < otp.e5.E5Problem
    methods
        function obj = Canonical(varargin)            
            y0 = [1.76e-3; 0; 0; 0];
            tspan = [0, 1e13];
            params = otp.e5.E5Parameters('A', 7.89e-10, 'B', 1.1e7, 'C', 1.13e3, 'M', 1e6, varargin{:});            
            obj = obj@otp.e5.E5Problem(tspan, y0, params);
        end
    end
end
