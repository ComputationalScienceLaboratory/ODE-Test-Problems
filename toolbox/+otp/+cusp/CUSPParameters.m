classdef CUSPParameters
    % Parameters for the CUSP problem.
    properties
        % The stiffness parameter $\varepsilon$ for the "cusp catastrophe" model.
        Epsilon %MATLAB ONLY: (1,1) {mustBeNumeric}

        % The diffusion coefficient $\sigma$ for all three variables.
        Sigma %MATLAB ONLY: (1,1) {mustBeNumeric}
    end
end

