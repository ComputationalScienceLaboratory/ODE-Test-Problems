classdef PopovMouSanduIliescu < otp.quasigeostrophic.QuasiGeostrophicProblem
    % A preset for the Quasi-geostrophic equations created for
    % :cite:p:`PMSI21`.
    %
    % The initial condition is given by an internal file and was created by
    % integrating the canonical preset until time $t=100$.
    %
    % The value of the Reynolds number is $Re= 450$, the Rossby number is
    % $Ro=0.0036$, and the spatial discretization is $63$ interior units in
    % the $x$ direction and $127$ interior units in the $y$ direction.
    %
    % The timespan starts at $t=100$ and ends at $t=100.0109$, which is
    % roughly equivalent to one day in model time.
    
    methods
        function obj = PopovMouSanduIliescu(varargin)
            % Create the PopovMouSanduIliescu Quasi-geostrophic problem object.
            %
            % Parameters
            % ----------
            % varargin
            %    A variable number of name-value pairs. The accepted names are
            %
            %    - ``ReynoldsNumber`` – Value of $Re$.
            %    - ``RossbyNumber`` – Value of $Ro$.
            %    - ``Size`` – Two-tuple of the spatial discretization, $[nx, ny]$.
            
            defaultsize = [63, 127];

            Re = 450;
            Ro = 0.0036;
            
            p = inputParser;
            addParameter(p, 'ReynoldsNumber', Re);
            addParameter(p, 'RossbyNumber', Ro);
            addParameter(p, 'Size', defaultsize);

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
            
            %% Load initial conditions

            % OCTAVE BUG: Octave gives a warning on loading the data, even
            % though MATLAB supports this type of private folder loading
            
            spy0s = load('PMISQGICsp.mat');
            psi0 = reshape(double(spy0s.y0), 255, 511);
            
            psi0 = otp.quasigeostrophic.QuasiGeostrophicProblem.resize(psi0, s.Size);
            psi0 = reshape(psi0, [], 1);
            
            %% Do the rest
            
            oneday = 24*80/176251.2;
            
            tspan = [100, 100 + oneday];
            
            obj = obj@otp.quasigeostrophic.QuasiGeostrophicProblem(tspan, ...
                psi0, params);
            
        end
    end
end
