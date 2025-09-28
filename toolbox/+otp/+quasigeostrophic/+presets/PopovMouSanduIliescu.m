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
            %    - ``Nx`` – Spatial discretization in $x$.
            %    - ``Ny`` – Spatial discretization in $y$.
            %    - ``ADLambda`` – Scaling factor for approximate deconvolution RHS 
            %    - ``ADPasses`` – Number of AD passes
            
            params = otp.quasigeostrophic.QuasiGeostrophicParameters( ...
                'Nx', 255, ...
                'Ny', 511, ...
                'ReynoldsNumber', 450, ...
                'RossbyNumber', 0.0036, ...
                'ADLambda', 1, ...
                'ADPasses', 4, ...
                varargin{:});

            % OCTAVE BUG: Octave gives a warning on loading the data, even
            % though MATLAB supports this type of private folder loading
            spy0s = load('PMISQGICsp.mat');
            psi0 = reshape(double(spy0s.y0), 255, 511);
            
            psi0 = otp.quasigeostrophic.QuasiGeostrophicProblem.resize(psi0, [params.Nx, params.Ny]);
            psi0 = reshape(psi0, [], 1);
            
            %% Do the rest
            oneday = 24*80/176251.2;
            
            tspan = [100, 100 + oneday];
            
            obj = obj@otp.quasigeostrophic.QuasiGeostrophicProblem(tspan, ...
                psi0, params);
        end
    end
end
