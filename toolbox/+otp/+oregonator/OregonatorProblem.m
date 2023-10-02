classdef OregonatorProblem < otp.Problem
    % A periodic, three-variable model for the Belousov–Zhabotinsky reaction.
    %
    % The Oregonator chemical reaction :cite:p:`FN74` is given by
    %
    %
    % $$
    % \ce{
    % A + Y &-> X + P \\
    % X + Y &-> 2P \\
    % A + X &-> 2X + 2Z \\
    % 2X &-> A + P \\
    % B + Z &-> 1/2 $f$ Y.
    % }
    % $$
    %
    % Species $\ce{A = BrO3-}$, $\ce{B = CH2(COOH)2}$, and $\ce{P = HOBr}$ or $\ce{BrCH(COOH)2}$ are assumed to be
    % constant. The dynamic concentrations of intermediate species $\ce{X = HBrO2}$, $\ce{Y = Br-}$, and
    % $\ce{Z = Ce(IV)}$ can be modeled by an ODE in three variables. Field and Noyes :cite:p:`FN74` proposed the
    % nondimensionalized form
    %
    % $$
    % α' &= s(η - η α + α - q α^2), \\
    % η' &= s^{-1}(-η - η α + f ρ), \\
    % ρ' &= w (α - ρ),
    % $$
    %
    % where $α$, $η$, and $ρ$ are scaled concentrations of $\ce{X}$, $\ce{Y}$, and $\ce{Z}$, respectively.
    %
    % Notes
    % -----
    % +---------------------+------------------------------------------------+
    % | Type                | ODE                                            |
    % +---------------------+------------------------------------------------+
    % | Number of Variables | 3                                              |
    % +---------------------+------------------------------------------------+
    % | Stiff               | typically, depending on $f$, $q$, $s$, and $w$ |
    % +---------------------+------------------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.oregonator.presets.Canonical;
    % >>> sol = problem.solve();
    % >>> problem.plotPhaseSpace(sol, 'Vars', [2, 3]);

    methods
        function obj = OregonatorProblem(timeSpan, y0, parameters)
            % Create a Oregonator problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(3, 1)
            %    The initial conditions.
            % parameters : OregonatorParameters
            %    The parameters.
            %
            % Returns
            % -------
            % obj : OregonatorProblem
            %    The constructed problem.
            obj@otp.Problem('Oregonator', 3, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            f = obj.Parameters.F;
            q = obj.Parameters.Q;
            s = obj.Parameters.S;
            w = obj.Parameters.W;
            
            obj.RHS = otp.RHS(@(t, y) otp.oregonator.f(t, y, f, q, s, w), ...
                'Jacobian', @(t, y) otp.oregonator.jacobian(t, y, f, q, s, w), ...
                'Vectorized', 'on');
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, 'yscale', 'log', varargin{:});
        end
        
        function fig = internalPlotPhaseSpace(obj, t, y, varargin)
            fig = internalPlotPhaseSpace@otp.Problem(obj, t, y, 'xscale', 'log', 'yscale', 'log', 'zscale', 'log', ...
                varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = internalMovie@otp.Problem(obj, t, y, 'yscale', 'log', varargin{:});
        end
    end
end

