function Javp = jacobianadjointvectorproduct(f, t, y, u, method)
% JACOBIANADJOINTVECTORPRODUCT
% provides jacobian adjoint times a vector that is calculated using either automatic
% differentiation or through finite differences, depending on their
% availability.

userrequestedad = false;
if nargin < 5 || isempty(method)
    method = 'AD';
    userrequestedad = false;
elseif strcmp(method, 'AD')
    userrequestedad = true;
end


if strcmp(method, 'AD')
    try
        g = @(y, v) adjacobianvectorproductinternal(f, t, y, v)'*u;

        Javp = adjacobianadjointvectorproduct(g, y, u);
        adfailed = false;
    catch
        adfailed = true;
    end
end

if userrequestedad && adfailed
    warning('OTP:ADFailed', "Automatic Differentiation could not be completed for the given function");
end

if strcmp(method, 'FD') || adfailed
    % compute the finite difference step size in a heuristic way
    h = sqrt(max(eps(y)));
    if h < 1e-7
        h = 1e-7;
    end

    g = @(t, v) otp.utils.derivatives.jacobianvectorproduct(f, t, y, v, 'FD')'*u;

    n = numel(y);
    
    for i = n:-1:1
        e = 0*y; e(i) = 1;
        Javp(i, :) = finitediff(g, t, y, e, h);
    end
end


end


function d = finitediff(f, t, y, u, h)

d = (f(t, y + h*u) - f(t, y - h*u))/(2*h);

end

function J = adjacobianvectorproductinternal(f, t, y, u)

n = numel(u);

J = zeros(n, 1, 'like', y);

fy = f(t, y);
for i = 1:n
    J(i) = dlgradient(fy(i), y, 'EnableHigherDerivatives', true).'*u;
end

end

function J = adjacobianadjointvectorproduct(g, y, v)
y = dlarray(y);
v = dlarray(v);

J = dlfeval(@adjacobianadjointvectorproductinternal, g, y, v);

J = extractdata(J);

end

function J = adjacobianadjointvectorproductinternal(g, y, v)

gv = g(y, v);

J = dlgradient(gv, v);

end