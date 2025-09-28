classdef Canonical < otp.zlakinetics.ZLAKineticsProblem
    %CANONICAL The problem as described in the literature
    %
    % See:
    %    Walter Johannes Henricus Stortelder. Parameter estimation in nonlinear dynamical
    %    systems. PhD thesis, Centrum Wiskunde & Informatica, 
    %    Amsterdam, The Netherlands, 1998.
    %
    methods
        function obj = Canonical(varargin)
            tspan = [0, 180];
            params = otp.zlakinetics.ZLAKineticsParameters( ...
                'k', [18.7, 0.58, 0.09, 0.42], ...
                'K', 34.4, ...
                'KlA', 3.3, ...
                'Ks', 115.83, ...
                'PCO2', 0.9, ...
                'H', 737, ...
                varargin{:});            
            y0 = [0.444; 0.00123; 0; 0.007; 0; 0];
            y0(end) = params.Ks * y0(1) * y0(4);
            
            obj = obj@otp.zlakinetics.ZLAKineticsProblem(tspan, y0, params);
        end
    end
end
