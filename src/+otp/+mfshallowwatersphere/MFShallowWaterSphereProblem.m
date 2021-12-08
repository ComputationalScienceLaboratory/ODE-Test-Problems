classdef MFShallowWaterSphereProblem < otp.Problem
    
    methods
        function obj = MFShallowWaterSphereProblem(timeSpan, y0, parameters)
            
            obj@otp.Problem('Meshfree Shallow Water on a Sphere', [], ...
                timeSpan, y0, parameters);
            
        end
    end
    
    properties (SetAccess = private)
        DistanceFunction
    end

    properties (Access = private)
        PlottingInterp
        PlottingLatitude
        PlottingLongitude
    end

    methods
        
        function plotSphere(obj, huv, projection)
            if nargin < 3
                projection = 'eqaazim';
            end

            load('coastlines', 'coastlat', 'coastlon');

            n = size(huv, 1)/3;
            h = huv(1:n);
            u = huv((n+1):(2*n));
            v = huv((2*n+1):end);

            Winterp = obj.PlottingInterp;

            Nplot = sqrt(size(Winterp, 1));

            lat = obj.PlottingLatitude;
            lon = obj.PlottingLongitude;

            cmap = interp1([0; 0.5; 1], [1, 0, 0; 1, 1, 1; 0, 0.3, 0.8], linspace(0, 1, 500));

            colormap(cmap);

            subplot(1, 3, 1); cla;
            axesm(projection);
            contourfm(lat,lon,reshape(Winterp*h, Nplot, Nplot),'LineStyle','none')
            ax = gca;
            setm(ax,'FLineWidth', 3, 'Grid','on')
            l = plotm(coastlat, coastlon, '-k');
            l.Color = [l.Color, 0.5];

            subplot(1, 3, 2); cla;
            axesm(projection);
            contourfm(lat,lon,reshape(Winterp*u, Nplot, Nplot),'LineStyle','none')
            ax = gca;
            setm(ax,'FLineWidth', 3, 'Grid','on')
            l = plotm(coastlat, coastlon, '-k');
            l.Color = [l.Color, 0.5];

            subplot(1, 3, 3); cla;
            axesm(projection);
            contourfm(lat,lon,reshape(Winterp*v, Nplot, Nplot),'LineStyle','none')
            ax = gca;
            setm(ax,'FLineWidth', 3, 'Grid','on')
            l = plotm(coastlat, coastlon, '-k');
            l.Color = [l.Color, 0.5];

            drawnow;


        end


    end
    
    
    methods (Access = protected)
        
        function onSettingsChanged(obj)            
            lambda = obj.Parameters.lambda;
            phi = obj.Parameters.phi;
            g = obj.Parameters.gravity;
            a = obj.Parameters.radius;
            Omega = obj.Parameters.angularSpeed;

            f = 2*Omega*sin(phi.');

            cosphi = cos(phi.');
            tanphi = tan(phi.');
            
            % create the interpolation matrix and derivatives
            rbf = @otp.utils.rbf.quadratic;

            interpolationradius = pi/3;
            [W, dWdl, dWdp] = rbfinterp(lambda, phi, lambda, phi, interpolationradius, rbf);
            
            % create the interploation matrix for plotting
            Nplot = 50;
            lambdaplot = linspace(-pi, pi, Nplot);
            phiplot = linspace(-pi/2, pi/2, Nplot);
            [lambdainterpgrid, phiinterpgrid] = meshgrid(lambdaplot, phiplot);
            radiusplot = pi/6;
            Wplot = rbfinterp(lambda, phi, lambdainterpgrid(:).', phiinterpgrid(:).', radiusplot, rbf);


            plotlongitude = 360*(lambdainterpgrid/pi + 1)/2;
            plotlatitude = 180*(phiinterpgrid/(pi/2))/2;

            obj.PlottingInterp = Wplot;
            obj.PlottingLatitude = plotlatitude;
            obj.PlottingLongitude = plotlongitude;

            % set the right hand side
            obj.Rhs = otp.Rhs(@(t, huv) ...
                otp.mfshallowwatersphere.f(huv, W, dWdl, dWdp, cosphi, tanphi, g, a, f));
            

            %% Distance function
            obj.DistanceFunction = @(t, huv, i, j) otp.mfshallowwatersphere.distfn(t, huv, i, j, lambda, phi);

        end
        
        function validateNewState(obj, newTimeSpan, newY0, newParameters)
            
            validateNewState@otp.Problem(obj, ...
                newTimeSpan, newY0, newParameters)
            
            %otp.utils.StructParser(newParameters) ...
            %    .checkField('nx', 'finite', 'scalar', 'integer', 'positive') ...
            %    .checkField('ny', 'finite', 'scalar', 'integer', 'positive') ...
            %    .checkField('Re', 'finite', 'scalar', 'real', 'positive') ...
            %    .checkField('Ro', 'finite', 'scalar', 'real');
            
        end
        
        function label = internalIndex2label(obj, index)


            label = [];
            
            %[i, j] = ind2sub([obj.Parameters.nx, obj.Parameters.ny], index);
            
            %label = sprintf('(%d, %d)', i, j);
            
        end
        
        function sol = internalSolve(obj, varargin)
            % This really requires an SSP method
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
        end
        
    end
end
