function Jvp = jacobianvectorproduct(f, t, y, u, method)
% JACOBIANVECTORPRODUCT
% provides jacobian times a vector that is calculated using either automatic
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
        Jvp = adjacobianvectorproduct(f, t, y, u);
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

    Jvp = finitediff(f, t, y, u, h);
end


end


function d = finitediff(f, t, y, u, h)

d = (f(t, y + h*u) - f(t, y - h*u))/(2*h);

end

function J = adjacobianvectorproduct(f, t, y, u)
y = dlarray(y);

J = dlfeval(@adjacobianvectorproductinternal, f, t, y, u);

J = extractdata(J);

end

function J = adjacobianvectorproductinternal(f, t, y, u)

n = numel(u);

J = zeros(n, 1, 'like', y);

fy = f(t, y);
for i = 1:n
    J(i) = dlgradient(fy(i), y, 'RetainData', true).'*u;
end

end