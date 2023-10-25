classdef Canonical < otp.quasigeostrophic.QuasiGeostrophicProblem
    % A preset of the Quasi-geostrophic equations starting at the unstable
    % state $ψ_0 = 0$.
    %
    % The value of the Reynolds number is $Re= 450$, the Rossby number is
    % $Ro=0.0036$, and the spatial discretization is $255$ interior units in
    % the $x$ direction and $511$ interior units in the $y$ direction.
    %
    % The timespan starts at $t=0$ and ends at $t=100$, which is
    % roughly equivalent to $25.13$ years.
    %

    methods
        function obj = Canonical(varargin)
            % Create the Canonical Quasi-geostrophic problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``ReynoldsNumber`` – Value of $Re$.
            %    - ``RossbyNumber`` – Value of $Ro$.
            %    - ``Size`` – Two-tuple of the spatial discretization, $[nx, ny]$.
            %

            Re = 450;
            Ro = 0.0036;
            
            p = inputParser;
            addParameter(p, 'ReynoldsNumber', Re);
            addParameter(p, 'RossbyNumber', Ro);
            addParameter(p, 'Size', [255, 511]);

            parse(p, varargin{:});
            
            s = p.Results;
            
            nx = s.Size(1);
            ny = s.Size(2);
            
            params = otp.quasigeostrophic.QuasiGeostrophicParameters;
            params.Nx = nx;
            params.Ny = ny;
            params.ReynoldsNumber = s.ReynoldsNumber;
            params.RossbyNumber   = s.RossbyNumber;
            params.ADLambda = 1;
            params.ADPasses = 4;
            
            %% Construct initial conditions

            psi0 = zeros(nx, ny);

            psi0 = psi0(:);
            
            %% Do the rest
            
            tspan = [0, 100];
            
            obj = obj@otp.quasigeostrophic.QuasiGeostrophicProblem(tspan, ...
                psi0, params);
            
        end
    end
end
