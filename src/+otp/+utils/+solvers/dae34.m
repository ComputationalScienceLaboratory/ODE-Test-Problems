function [sol, y] = dae34(f, tspan, y0, options)
% See
%    Cameron, F., Palmroth, M., & Piché, R. (2002). 
%    Quasi stage order conditions for SDIRK methods. 
%    Applied numerical mathematics, 42(1-3), 61-75.


J = options.Jacobian;
M = options.Mass;
abstol = options.AbsTol;
reltol = options.RelTol;

if isempty(abstol)
    abstol = 1e-6;
end

if isempty(reltol)
    reltol = 1e-3;
end

if isempty(J)
    error('OTP:DAEJacobianRequired', 'The default DAE solver requires a Jacobian to be provided.')
end

if isempty(M)
    M = speye(numel(y0));
end

if ~isa(M, 'function_handle')
    M = @(t, y) M;
end

gamma = 1/4;

A = zeros(4,4);
A(2,1) = 1/7;
A(3,1) = 61/144;
A(3,2) = -49/144;
A(4,1) = 0;
A(4,2) = 0;
A(4,3) = 3/4;

b = zeros(1, 4);
b(3) = 3/4;
b(4) = 1/4;

bhat = zeros(1, 4);
bhat(1) = -61/600;
bhat(2) = 49/600;
bhat(3) = 79/100;
bhat(4) = 23/100;

orderE = 3;

C = sum(A, 2) + gamma;

t = tspan(1);
y = y0.';

yc = y0;
tc = tspan(1);
h = 1e-3;

stagenum = size(A, 1);

tend = tspan(end);

step = 1;

while tc < tend

    if tc + h > tend
        h = tend - tc;
    end

    stages = zeros(numel(yc), stagenum);

    gh = gamma*h;

    for stage = 1:stagenum

        staget = tc + C(stage)*h;

        stagedy = 0;
        for i = 1:(stage - 1)
            stagedy = stagedy + A(stagenum, i)*h*stages(:, i);
        end

        newtonk0 = zeros(size(yc));

        np = inf;

        ntol = 1e-6;
        nmaxits = 5;
        its = 0;
        while norm(np) > ntol || its < nmaxits
            Mc = M(staget, yc + stagedy + gh*newtonk0);
            g = Mc*newtonk0 - f(staget, yc + stagedy + gh*newtonk0);
            H = Mc - gh*J(staget, yc + stagedy + gh*newtonk0);
            [np, ~] = gmres(H, g);

            newtonk0 = newtonk0 - np;
            its = its + 1;
        end

        stages(:, stage) = newtonk0;

    end

    yhat = yc;
    for bi = 1:numel(b)
        yc = yc + h*b(bi)*stages(:, bi);
        yhat = yhat + h*bhat(bi)*stages(:, bi);
    end

    sc = abstol + max(abs(yc), abs(yhat))*reltol;

    err = rms((M(tc + h, yc)*(yc-yhat))./sc);

    fac = 0.38^(1/(orderE + 1));

    facmin = 0.1;
    if err > 1 || isnan(err)
        % Reject timestep
        facmax = 1;
    else
        % Accept time step
        tc = tc + h;

        if tc + h > tend
            h = tend - tc;
        end

        t(step + 1) = tc;
        y(step + 1, :) = yc.';

        step = step + 1;

        facmax = 2.5;
    end

    % adjust step-size
    h = h*min(facmax, max(facmin, fac*(1/err)^1/(orderE + 1)));

end

if nargout < 2
    sol = struct('x', t, 'y', y.');
else
    sol = t;
end

end
