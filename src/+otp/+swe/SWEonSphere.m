classdef SWEonSphere < otp.Problem

    methods
        function obj = SWEonSphere(timeSpan, y0, parameters)

            obj@otp.Problem('Shallow Water Equations on a Sphere', [], ...
                timeSpan, y0, parameters);

        end
    end

    properties (SetAccess = private)

        ReshapeFunction
        DistanceFunction

    end

    methods (Access = private)
        function [Dl, Dm] = getD(obj, dl, dm)

            nl = obj.Parameters.nl;
            nm = obj.Parameters.nm;

            val1 = 1/2/dl;
            e1 = (val1)*ones(nl, 1);
            Dl = spdiags([-e1 e1], [-1 1], nl, nl);
            Dl(1, nl) = -val1;
            Dl(nl, 1) = val1;
            
            val2 = 1/2/dm;
            e1 = (val2)*ones(nm, 1);
            Dm = spdiags([e1 -e1], [-1 1], nm, nm);
            Dm(2, 1) = 0;
            Dm(nm - 1, nm) = 0;

        end
    end

    methods (Static)

        function [la, me, dl, dm] = makeMesh(nl, nm)

            la = linspace(0, 2*pi, nl + 1);
            la = la(1:end-1);
            dl = la(2) - la(1);

            me = linspace(-pi/2, pi/2, nm);
            dm = me(2) - me(1);

        end

        function [me] = fixMeridians(me, clamp)

            secme = sec(me);

            [~, inds1] = find(me > clamp);
            secme(inds1) = sec(clamp) + (me(inds1) - clamp)*(sec(clamp).*tan(clamp));

            [~, inds2] = find(me < -clamp);
            secme(inds2) = sec(-clamp) + (me(inds2) + clamp)*(sec(-clamp).*tan(-clamp));

            me = asec(secme);
            me(1:floor(length(me)/2)) = -me(1:floor(length(me)/2));

        end

        function [h, u, v] = reshapeStates(y, n, nl, nm)

            h = y(1:n);
            u = y((n + 1): (2*n));
            v = y((2*n + 1): (3*n));

            hp = [h(1) h(end)];
            h = reshape(h(2:end-1), nl, nm-2);
            h = [hp(1)*ones(nl, 1) h hp(2)*ones(nl, 1)];

            up = [u(1) u(end)];
            u = reshape(u(2:end-1), nl, nm-2);
            u = [up(1)*ones(nl, 1) u up(2)*ones(nl, 1)];

            vp = [v(1) v(end)];
            v = reshape(v(2:end-1), nl, nm-2);
            v = [vp(1)*ones(nl, 1) v vp(2)*ones(nl, 1)];

        end

    end

    methods (Access = protected)

        function onSettingsChanged(obj)

            [la, me, dl, dm] = otp.swe.SWEonSphere.makeMesh(obj.Parameters.nl, obj.Parameters.nm);

            [Dl, Dm] = obj.getD(dl, dm);

            ai = 1/obj.Parameters.a;

            clamp = 87/180*pi;
            fixedme = otp.swe.SWEonSphere.fixMeridians(me, clamp);

            sinme = sin(fixedme);
            cosme = cos(fixedme);

            secmea = ai./cosme;
            tanmea = sinme.*secmea;

            fcoriolis = 2*obj.Parameters.omega*sinme;

            npts = obj.Parameters.nl*(obj.Parameters.nm - 2) + 2;

            obj.ReshapeFunction = @(y) otp.swe.SWEonSphere.reshapeStates(y, npts, obj.Parameters.nl, obj.Parameters.nm);
            obj.DistanceFunction = @(t, y, i, j) otp.swe.distfn(t, y, i, j, obj.Parameters.nl, obj.Parameters.nm, la, me, obj.Parameters.a);
            obj.FlowVelocityMagnitude = @(y) otp.swe.flowvelmag(y, npts);
            obj.TotalEnergy = @(y) otp.swe.totalenergy(y, npts, obj.Parameters.phi, obj.Parameters.g);

            obj.Rhs = otp.Rhs(@(t, y) ...
                otp.swe.f(t, y, obj.ReshapeFunction, Dl, Dm, obj.Parameters.g, ai, fcoriolis, cosme, tanmea, secmea));

        end

        function validateNewState(obj, newTimeSpan, newY0, newParameters)

            validateNewState@otp.Problem(obj, ...
                newTimeSpan, newY0, newParameters)

            otp.utils.StructParser(newParameters) ...
                .checkField('nl', 'finite', 'scalar', 'odd-integer', 'positive') ...
                .checkField('nm', 'finite', 'scalar', 'even-integer', 'positive') ...
                .checkField('g', 'finite', 'scalar', 'real', 'positive') ...
                .checkField('a', 'finite', 'scalar', 'real', 'positive') ...
                .checkField('omega', 'finite', 'scalar', 'real', 'positive') ...
                .checkField('phi', 'finite', 'scalar', 'real', 'positive') ...
                .checkField('um0', 'finite', 'scalar', 'real');

        end

        function sol = internalSolve(obj, varargin)
            sol = internalSolve@otp.Problem(obj, 'Method', @ode45, varargin{:});
        end


    end

end
