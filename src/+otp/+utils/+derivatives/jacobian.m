function J = jacobian(f, t, y, method)
% JACOBIAN
% provides a jacobian that is calculated using either automatic
% differentiation or through finite differences, depending on their
% availability.

userrequestedad = false;
if nargin < 4 || isempty(method)
    method = 'AD';
    userrequestedad = false;
elseif strcmp(method, 'AD')
    userrequestedad = true;
end


if strcmp(method, 'AD')
    try
        J = adjacobian(f, t, y);
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

    n = numel(y);

    for i = n:-1:1
        e = zeros(n, 1);
        e(i) = 1;
        J(:, i) = finitediff(f, t, y, e, h);
    end
end


end


function d = finitediff(f, t, y, u, h)

d = (f(t, y + h*u) - f(t, y - h*u))/(2*h);

end

function J = adjacobian(f, t, y)
y = dlarray(y);

J = dlfeval(@adjacobianinternal, f, t, y);

J = extractdata(J);

end

function J = adjacobianinternal(f, t, y)

n = numel(y);

fy = f(t, y);

J = zeros(n, n, 'like', y);

for  i = 1:n
    J(i, :) = dlgradient(fy(i), y, 'RetainData', true).';
end

end