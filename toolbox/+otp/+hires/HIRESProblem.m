classdef HIRESProblem < otp.Problem
    % An eight-variable high irradiance response model from plant physiology.
    %
    % In :cite:p:`Sch75`, the following chemical reactions were proposed to explain the high irradiance responses of
    % photomorphogenesis on the basis of phytochrome:
    %
    % $$
    % \begin{array}{cccc}
    % \xrightarrow{o_{k_s}} & \ce{P_{{r}}} & \xrightleftharpoons[k_2]{k_1} & \ce{P_{fr}} \\
    % & {\scriptsize k_6} ↑ & & ↓ {\scriptsize k_3} \\
    % & \ce{P_{{r}}X} & \xrightleftharpoons[k_2]{k_1} & \ce{P_{fr}X} \\
    % & {\scriptsize k_5} ↑ & & ↓ {\scriptsize k_4} \\
    % & \ce{P_{{r}}X'} & \xrightleftharpoons[k_2]{k_1} & \ce{P_{fr}X'} \\
    % \end{array}
    % $$
    %
    % $$
    % \begin{array}{ccccc}
    % \ce{E + P_{{r}}X'} & \xleftarrow{k_2} & \ce{P_{fr}X'E} & \xrightleftharpoons[k_{-}]{k_{+}} & \ce{P_{fr}X' + E} \\
    % & & ↓ {\scriptsize k^*} \\
    % & & \ce{P_{fr}' + X' + E}
    % \end{array}
    % $$
    %
    % Reactants $\ce{P_{{r}}}$ and $\ce{P_{fr}}$ are the red and far-red absorbing form of phytochrome, respectively.
    % These can be bound by receptors $\ce{X}$ and $\ce{X'}$, partially influenced by enzyme $\ce{E}$. The system is
    % modeled by the differential equations :cite:p:`Got77` :cite:p:`dSL98`
    %
    % $$
    % \frac{d}{dt} \ce{[P_{{r}}]} &= -k_1 \ce{[P_{{r}}]} + k_2 \ce{[P_{fr}]} + k_6 \ce{[P_{{r}}X]} + o_{k_s}, \\
    % \frac{d}{dt} \ce{[P_{fr}]} &= k_1 \ce{[P_{{r}}]} - (k_2 + k_3) \ce{[P_{fr}]}, \\
    % \frac{d}{dt} \ce{[P_{{r}}X]} &= -(k_1 + k_6) \ce{[P_{{r}}X]} + k_2 \ce{[P_{fr}X]} + k_5 \ce{[P_{fr}X']}, \\
    % \frac{d}{dt} \ce{[P_{fr}X]} &= k_3 \ce{[P_{fr}]} + k_1 \ce{[P_{{r}}X]} - (k_2 + k_4) \ce{[P_{fr}X]}, \\
    % \frac{d}{dt} \ce{[P_{{r}}X']} &= -(k_1 + k_5) \ce{[P_{{r}}X']} + k_2 \ce{[P_{fr}X']} + k_2 \ce{[P_{fr}X'E]}, \\
    % \frac{d}{dt} \ce{[P_{fr}X']} &= k_4 \ce{[P_{fr}X]} + k_1 \ce{[P_{{r}}X']} - k_2 \ce{[P_{fr}X']}
    % + k_{-} \ce{[P_{fr}X'E]} - k_{+} \ce{[P_{fr}X']} \ce{[E]}, \\
    % \frac{d}{dt} \ce{[P_{fr}X'E]} &= -(k_2 + k_{-} + k^*) \ce{[P_{fr}X'E]} + k_{+} \ce{[P_{fr}X']} \ce{[E]}, \\
    % \frac{d}{dt} \ce{[E]} &= (k_2 + k_{-} + k^*) \ce{[P_{fr}X'E]} - k_{+} \ce{[P_{fr}X']} \ce{[E]}.
    % $$
    %
    % Notes
    % -----
    % +---------------------+--------------------------------------------------------------------+
    % | Type                | ODE                                                                |
    % +---------------------+--------------------------------------------------------------------+
    % | Number of Variables | 8                                                                  |
    % +---------------------+--------------------------------------------------------------------+
    % | Stiff               | typically, depending on $k_1, …, k_6$, $k_{+}$, $k_{-}$, and $k^*$ |
    % +---------------------+--------------------------------------------------------------------+
    %
    % Example
    % -------
    % >>> problem = otp.hires.presets.Canonical;
    % >>> sol = problem.solve('AbsTol', 1e-12);
    % >>> problem.plot(sol);
    
    methods
        function obj = HIRESProblem(timeSpan, y0, parameters)
            % Create a HIRES problem object.
            %
            % Parameters
            % ----------
            % timeSpan : numeric(1, 2)
            %    The start and final time.
            % y0 : numeric(2, 1)
            %    The initial conditions.
            % parameters : otp.hires.HIRESParameters
            %    The parameters.
            obj@otp.Problem('HIRES', 8, timeSpan, y0, parameters);
        end
    end
    
    methods (Access = protected)
        function onSettingsChanged(obj)
            k1 = obj.Parameters.K1;
            k2 = obj.Parameters.K2;
            k3 = obj.Parameters.K3;
            k4 = obj.Parameters.K4;
            k5 = obj.Parameters.K5;
            k6 = obj.Parameters.K6;
            kPlus = obj.Parameters.KPlus;
            kMinus = obj.Parameters.KMinus;
            kStar = obj.Parameters.KStar;
            oks = obj.Parameters.OKS;

            obj.RHS = otp.RHS(@(t, y) otp.hires.f(t, y, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, oks), ...
                'Jacobian', @(t, y) otp.hires.jacobian(t, y, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, oks), ...
                'JacobianVectorProduct', @(t, y, v) ...
                otp.hires.jacobianVectorProduct(t, y, v, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, oks), ...
                'JacobianAdjointVectorProduct', @(t, y, v) ...
                otp.hires.jacobianAdjointVectorProduct(t, y, v, k1, k2, k3, k4, k5, k6, kPlus, kMinus, kStar, oks), ...
                'Vectorized', 'on', ...
                'NonNegative', 1:obj.NumVars);
        end

        function label = internalIndex2label(obj, index)
            switch  index
                case 1
                    label = 'P_r';
                case 2
                    label = 'P_{fr}';
                case 3
                    label = 'P_r X';
                case 4
                    label = 'P_{fr} X';
                case 5
                    label = 'P_r X''';
                case 6
                    label = 'P_{fr} X''';
                case 7
                    label = 'P_{fr} X'' E';
                case 8
                    label = 'E';
            end
        end
        
        function fig = internalPlot(obj, t, y, varargin)
            fig = internalPlot@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
        
        function mov = internalMovie(obj, t, y, varargin)
            mov = internalMovie@otp.Problem(obj, t, y, ...
                'xscale', 'log', 'yscale', 'log', varargin{:});
        end
    end
end
