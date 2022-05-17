function [sol, y] = dae46(f, tspan, y0, options)
% See
%    Cameron, F., Palmroth, M., & Piché, R. (2002). 
%    Quasi stage order conditions for SDIRK methods. 
%    Applied numerical mathematics, 42(1-3), 61-75.


gamma = 1/4;

A = zeros(6,6);
A(2,1) = 1/4;
A(3,1) = -1/36;
A(3,2) = -1/18;
A(4,1) = -21283/32000;
A(4,2) = -5143/64000;
A(4,3) = 90909/64000;
A(5,1) = 46010759/749250000;
A(5,2) = -737693/40500000;
A(5,3) = 10931269/45500000;
A(5,4) = -1140071/34090875;
A(6,1) = 89/444;
A(6,2) = 89/804756;
A(6,3) = -27/364;
A(6,4) = -20000/171717;
A(6,5) = 843750/1140071;

bhat5 = 1/4;
bhat6 = 1/4;
bhat1 = 163/333 + (204072709/112387500)* bhat5 - (725/111)*bhat6;
bhat2 = 17/18 + (5929277/6075000)*bhat5 - (20/3)*bhat6;
bhat3 = -103/182 - (204072709/61425000)*bhat5 + (1074/91)*bhat6; 
bhat4 = 4000/30303 - (48017108/102272625)*bhat5 + (4000/10101)*bhat6;

bhat = [bhat1, bhat2, bhat3, bhat4, bhat5, bhat6];

c = sum(A, 2) + gamma;

orderM = 4;
orderE = 3;

%% Get all relevant options out 
h = odeget(options, 'InitialStep', []);
reltol = odeget(options, 'RelTol', 1e-3);
abstol = odeget(options, 'AbsTol', 1e-6);
J = odeget(options, 'Jacobian', @(t, y) jacapprox(f, t, y));
M = odeget(options, 'Mass', speye(numel(y0)));
MStateDependence = odeget(options, 'MStateDependence', 'none');
laststage = odeget(options, 'InitialSlope', []);

% We won't support state-dependent Mass, simple as that
if strcmp(MStateDependence, 'strong')
    error('OTP:MassStateDependent', 'State dependent mass is not supported.')
end

if ~isa(M, 'function_handle')
    M = @(t) M;
else
    if nargin(M) > 1
        M = @(t) M(t, y0);
    end
end

if isempty(h)
    sc = abstol + reltol*abs(y0);
    f0 = f(tspan(1), y0);
    d0 = mean((y0./sc).^2);
    d1 = mean((f0./sc).^2);
    h0 = (d0/d1)*0.01;

    y1 = y0 + h0*f0;
    f1 = f(tspan(1) + h0, y1);

    d2 = mean(((f1 - f0)./sc).^2)/h0;

    h1 = (0.01/max(d1, d2))^(1/orderM);

    h = min(100*h0, h1);
end

t = tspan(1);
y = y0.';

yc = y0;
tc = tspan(1);

stagenum = size(A, 1);
tend = tspan(end);

newtonk0 = zeros(size(yc));

stages = zeros(numel(yc), stagenum);

step = 1;
while tc < tend

    bnewtonreject = false;

    if tc + h > tend
        h = tend - tc;
    end

    gh = gamma*h;

    if step == 1 && isempty(laststage)
        [laststage, ~] = bicg(M(tc), f(tc, yc));
    end

    stages(:, 1) = laststage;

    for stage = 2:stagenum

        staget = tc + c(stage)*h;

        stagedy = h*(stages(:, 1:(stage - 1))*A(stage, 1:(stage - 1)).');

        newtonk0 = 0*newtonk0;

        ntol = min(abstol, reltol);
        nmaxits = 1e2;
        alpha = 1;
        its = 0;
        etak = inf;
        nnp = inf;
        kappa = 1e-1;
        ng = inf;

        Jc = J(staget, yc + stagedy + gh*newtonk0);
        while kappa*(etak*nnp) >= ntol && its < nmaxits
            Mc = M(staget);
            ycs = yc + stagedy + gh*newtonk0;
            g = Mc*newtonk0 - f(staget, ycs);
            H = Mc - gh*Jc;
            [npnew, ~] = bicg(H, g, [], size(H, 1));

            newtonknew = newtonk0 - alpha*npnew;

            sc = abstol + reltol*abs(ycs);


            if its > 3
                ngnew = sqrt(mean((g./sc).^2));
                % recompute the jacobian
                if ngnew > 1.25*ng
                    Jc = J(staget, ycs);
                end
                ng = ngnew;

                nnpnew = sqrt(mean((npnew./sc).^2));
               
                thetak = nnpnew/nnp;

                if thetak > 10 || isnan(thetak)
                    bnewtonreject = true;
                    break;
                end

                etak = thetak/(1 - thetak);
            end

            newtonk0 = newtonknew;

            np = npnew;
            nnp = sqrt(mean((np./sc).^2));

            its = its + 1;
        end

        if bnewtonreject
            break;
        end

        stages(:, stage) = newtonk0;

    end

    if bnewtonreject
       h = h/2;
       continue;
    end

    yhat = yc + h*stages*bhat.';
    %ycnew = yc + h*stages*b.';

    ycnew = ycs;

    sc = abstol + max(abs(ycnew), abs(yc))*reltol;

    Mc = M(tc + h);

    errdifferential = sqrt(mean(((Mc*(ycnew - yhat))./sc).^2));
    err = errdifferential;

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

        laststage = stages(:, end);

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
