function [sol, y] = dae43(f, tspan, y0, options)

n = numel(y0);

h = odeget(options, 'InitialStep', []);
reltol = odeget(options, 'RelTol', 1e-3);
abstol = odeget(options, 'AbsTol', 1e-6);
J = odeget(options, 'Jacobian', @(t, y) jacapprox(f, t, y));
M = odeget(options, 'Mass', speye(numel(y0)));
MStateDependence = odeget(options, 'MStateDependence', 'none');

% We won't support state-dependent Mass, simple as that
if strcmp(MStateDependence, 'strong')
    error('OTP:MassStateDependent', 'Strong state dependent mass is not supported.')
end

if ~isa(M, 'function_handle')
    M = @(t, y) M;
end

% Lobatto IIIC
A = [1/6, -1/3, 1/6; 1/6, 5/12, -1/12; 1/6, 2/3, 1/6];
b = [1/6, 2/3, 1/6];
c = [0, 1/2, 1];
bhat = [-1/2, 2, -1/2];

orderM = 4;
orderE = 3;

% Compute initial step size
if isempty(h)
    sc = abstol + reltol*abs(y0);
    f0 = f(tspan(1), y0);
    d0 = sqrt(mean((y0./sc).^2));
    d1 = sqrt(mean((f0./sc).^2));
    h0 = (d0/d1)*0.01;

    y1 = y0 + h0*f0;
    f1 = f(tspan(1) + h0, y1);

    d2 = sqrt(mean(((f1 - f0)./sc).^2))/h0;

    h1 = (0.01/max(d1, d2))^(1/orderM);

    h = min(100*h0, h1);
end

t = tspan(1);
y = y0.';

yc = y0;
tc = tspan(1);

stagenum = size(A, 1);
tend = tspan(end);

step = 1;

Mc = M(tspan(1), y0);
Mfull = zeros(n*stagenum, n*stagenum, 'like', Mc);
gfull = zeros(n*stagenum, 1);
Jfull = zeros(n*stagenum, n*stagenum, 'like', Mc);
newtonk = zeros(n*stagenum, 1);

while tc < tend

    if tc + h > tend
        h = tend - tc;
    end

    % build M
    for stage = 1:stagenum
        si = ((stage - 1)*n + 1):(stage*n);
        Mfull(si, si) = M(tc + h*c(stage), yc);
    end

    np = inf;

    ntol = min(abstol, reltol);
    nmaxits = 1e2;
    its = 0;

    newtonk = 0*newtonk;

    while norm(np) > ntol && its < nmaxits
        % build g and Jacobians
        for stage = 1:stagenum
            si = ((stage - 1)*n + 1):(stage*n);
            staget = tc + c(stage)*h;
            ycs = yc + h*reshape(newtonk, n, [])*(A(stage, :).');
       
            Mc = Mfull(si, si);
            gfull(si) =  Mc*newtonk(si) - f(staget, ycs);
            Jc = J(staget, ycs);

            Jfull(si, :) = kron(A(stage, :), Jc);
        end

        H = Mfull - h*Jfull;

        np = H\gfull;

        newtonk = newtonk - np;
        its = its + 1;
    end

    yhat = yc + h*reshape(newtonk, n, [])*bhat.';
    ycnew = yc + h*reshape(newtonk, n, [])*b.';

    sc = abstol + max(abs(ycnew), abs(yc))*reltol;

    Mc = M(tc + h , ycnew);

    err = sqrt(mean(((Mc*(ycnew - yhat))./sc).^2));

    fac = 0.9;

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

        facmax = 4;
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
