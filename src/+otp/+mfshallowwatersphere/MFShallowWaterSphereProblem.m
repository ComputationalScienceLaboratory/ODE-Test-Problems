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

    methods
        
        function plotSphere(obj, huv, projection)
            if nargin < 3
                projection = 'eqaazim';
            end


            x = obj.Parameters.x;
            y = obj.Parameters.y;
            z = obj.Parameters.z;
            rbf = obj.Parameters.rbf;

            Nplot = 50;
            lambdaplot = linspace(-pi, pi, Nplot);
            thetaplot = linspace(-pi/2, pi/2, Nplot);
            [lambdainterpgrid, thetainterpgrid] = meshgrid(lambdaplot, thetaplot);

            % get the cartesian coordinates for the uniform mesh
            [x2, y2, z2] = sph2cart(lambdainterpgrid(:), thetainterpgrid(:), ones(numel(lambdainterpgrid), 1));
            radiusplot = 0.5;

            %
            Winterp = rbfinterp(x, y, z, x2, y2, z2, radiusplot, rbf);
            Winterp = Winterp./sum(Winterp, 2);

            lon = 360*(lambdainterpgrid/pi + 1)/2;
            lat = 180*(thetainterpgrid/(pi/2))/2;


            load('coastlines', 'coastlat', 'coastlon');

            n = size(huv, 1)/4;
            h = huv(1:n);
            %u = huv((n+1):(2*n));
            %v = huv((2*n+1):end);

            Nplot = sqrt(size(Winterp, 1));

            cmap = interp1([0; 0.5; 1], [1, 0, 0; 1, 1, 1; 0, 0.3, 0.8], linspace(0, 1, 500));
            levels = 20;

            %colormap(cmap);

            %subplot(1, 3, 1); 
            cla;
            axesm(projection);
            contourfm(lat, lon, reshape(Winterp*h, Nplot, Nplot), levels, 'LineStyle','none');
            colorbar;
            ax = gca;
            setm(ax,'FLineWidth', 3, 'Grid','on')
            l = plotm(coastlat, coastlon, '-k');
            l.Color = [l.Color, 0.5];

            %             subplot(1, 3, 2); cla;
            %             axesm(projection);
            %             contourfm(lat, lon, reshape(Winterp*u, Nplot, Nplot), levels, 'LineStyle','none');
            %             colorbar;
            %             ax = gca;
            %             setm(ax,'FLineWidth', 3, 'Grid','on')
            %             l = plotm(coastlat, coastlon, '-k');
            %             l.Color = [l.Color, 0.5];
            %
            %             subplot(1, 3, 3); cla;
            %             axesm(projection);
            %             contourfm(lat, lon, reshape(Winterp*v, Nplot, Nplot), levels, 'LineStyle','none');
            %             colorbar;
            %             ax = gca;
            %             setm(ax,'FLineWidth', 3, 'Grid','on')
            %             l = plotm(coastlat, coastlon, '-k');
            %             l.Color = [l.Color, 0.5];

            drawnow;


        end


    end
    
    
    methods (Access = protected)
        
        function onSettingsChanged(obj)            
            x = obj.Parameters.x;
            y = obj.Parameters.y;
            z = obj.Parameters.z;
            g = obj.Parameters.gravity;
            a = obj.Parameters.radius;
            rbf = obj.Parameters.rbf;
            rbfradius = obj.Parameters.rbfradius;
            f = obj.Parameters.coriolisForce;
            
            % create the interpolation matrix and derivatives
            [W, dWdx, dWdy, dWdz] = rbfinterp(x, y, z, x, y, z, rbfradius, rbf);
            
            Bx = dWdx.*(1 - x.^2) + dWdy.*(-x.*y)    + dWdz.*(-x.*z);
            By = dWdx.*(-x.*y)    + dWdy.*(1 - y.^2) + dWdz.*(-y.*z);
            Bz = dWdx.*(-x.*z)    + dWdy.*(-y.*z)    + dWdz.*(1 - z.^2);

            Bx = Bx/a;
            By = By/a;
            Bz = Bz/a;

            try 
                Wdecomp = decomposition(W, 'chol');
            catch
                error('The selected compination of RBF, radius, and nodes did not result in a SPD collocation matrix.')
            end

            % build Shepard interpolation matrix
            S = W./sum(W, 2);

            % set the right hand side
            obj.Rhs = otp.Rhs(@(t, huvw) ...
                otp.mfshallowwatersphere.f(huvw, S, Wdecomp, Bx, By, Bz, f, g, x, y, z));
            

            %% Distance function

            theta = atan2(z, sqrt(x.^2 + y.^2));
            lambda = atan2(y, x);

            obj.DistanceFunction = @(t, huv, i, j) otp.mfshallowwatersphere.distfn(t, huv, i, j, theta, lambda);

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
