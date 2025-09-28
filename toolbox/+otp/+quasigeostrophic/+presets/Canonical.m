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
            %    - ``Nx`` – Spatial discretization in $x$.
            %    - ``Ny`` – Spatial discretization in $y$.
            %    - ``ADLambda`` – Scaling factor for approximate deconvolution RHS 
            %    - ``ADPasses`` – Number of AD passes
            %
            
            params = otp.quasigeostrophic.QuasiGeostrophicParameters( ...
                'Nx', 255, ...
                'Ny', 511, ...
                'ReynoldsNumber', 450, ...
                'RossbyNumber', 0.0036, ...
                'ADLambda', 1, ...
                'ADPasses', 4, ...
                varargin{:});
            
            %% Do the rest
            tspan = [0, 100];
            psi0 = zeros(params.Nx * params.Ny, 1);
            obj = obj@otp.quasigeostrophic.QuasiGeostrophicProblem(tspan, psi0, params);
        end
    end
end
