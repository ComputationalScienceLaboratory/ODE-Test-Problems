classdef Lorenz96PODROM < otp.quadratic.QuadraticProblem
    %LORENZ96PODROM a quadratic reduced order model of the L96 equations
    %
    % See
    %     Popov, A. A., & Sandu, A. (2021). 
    %     Multifidelity ensemble Kalman filtering using surrogate models defined by physics-informed autoencoders. 
    %     arXiv preprint arXiv:2102.13025.
    %
    properties
        Projection
        Interpolation
    end

    methods
        function obj = Lorenz96PODROM(varargin)
            p = inputParser();
            p.addParameter('R', 28);
            p.parse(varargin{:});
            r = p.Results.R;
            
            s = load('l96_ROM_r40.mat');
            
            % This represents roughly ten years
            tspan = [0, 720];

            y0 = 8 * ones(40, 1);
            y0(20) = 8.008;
            u0 = s.Va(1:r, :)*y0;
            
            params = otp.quadratic.QuadraticParameters( ...
                'A', double(s.a(1:r)), ...
                'B', double(s.B(1:r, 1:r)), ...
                'C', double(s.C(1:r, 1:r, 1:r)));
            
            obj = obj@otp.quadratic.QuadraticProblem(tspan, u0, params);
            
            obj.Projection = s.Va(1:r, :);
            obj.Interpolation = s.V(:, 1:r);
        end
    end

end
