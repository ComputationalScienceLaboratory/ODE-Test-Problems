function [sol, y] = dae24(f, tspan, y0, options)
% See
%    Cameron, F., Palmroth, M., & Piché, R. (2002). 
%    Quasi stage order conditions for SDIRK methods. 
%    Applied numerical mathematics, 42(1-3), 61-75.

f1 = f(tspan(1), y0);
hdefault = norm(y0)/norm(f1)*0.01;

h = odeget(options, 'InitialStep', hdefault);
reltol = odeget(options, 'RelTol', 1e-3);
abstol = odeget(options, 'AbsTol', 1e-6);
J = odeget(options, 'Jacobian', @(t, y) jacapprox(f, t, y));
M = odeget(options, 'Mass', speye(numel(y0)));

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

orderE = 1;

C = sum(A, 2) + gamma;

t = tspan(1);
y = y0.';

yc = y0;
tc = tspan(1);

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

        if stage > 1
            stagedy = h*(stages(:, 1:(stage - 1))*A(stage, 1:(stage - 1)).');
        else
            stagedy = 0;
        end

        newtonk0 = zeros(size(yc));

        np = inf;

        ntol = 1e-6;
        nmaxits = 10;
        its = 0;
        while norm(np) > ntol && its < nmaxits
            Mc = M(staget, yc + stagedy + gh*newtonk0);
            g = Mc*newtonk0 - f(staget, yc + stagedy + gh*newtonk0);
            H = Mc - gh*J(staget, yc + stagedy + gh*newtonk0);
            [np, ~] = lsqr(H, g, [], size(H, 1));

            newtonk0 = newtonk0 - np;
            its = its + 1;
        end

        stages(:, stage) = newtonk0;

    end

    yhat = yc + h*stages*bhat.';
    ycnew = yc + h*stages*b.';

    sc = abstol + max(abs(ycnew), abs(yhat))*reltol;

    Mc = M(tc + h, ycnew);

    err = rms((Mc*(ycnew-yhat))./sc);
    %err = rms(((ycnew-yhat))./sc);

    fac = 0.38^(1/(orderE + 1));

    facmin = 0.1;
    if err > 1 || isnan(err)
        % Reject timestep
        facmax = 1;
    else
        % Accept time step
        tc = tc + h;
        yc = ycnew;

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

function J = jacapprox(f, t, y)

n = numel(y);

J = zeros(n, n);

h = sqrt(1e-6);

f0 = f(t, y);

for i = 1:n
    e = zeros(n, 1); e(i) = 1;
    J(:, i) = (f(t, y + h*e) - f0)/h;
end

end
