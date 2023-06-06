function J = jacobian(~, y)

% This is very easy to read and understand I will leave a comment with the base
% code so you can read and understand it too

% maindiag      = -1*ones(N, 1);
% uponediag     = [0; y([N, 1:(N-2)])];
% downonediag   = [y([3:N , 1]) - y([N, 1:(N-2)]) ; 0];
% downtwodiag   = [-y(2:(N-1)) ; 0 ; 0];
% 
% negminonediag = [y(N-1); zeros(N-1, 1)];
% mintwodiag    = [zeros(N-2, 1); -y([N, 1])];
% minonediag    = [zeros(N-1, 1); y(2)-y(N-1)];
% 
% size(negminonediag)
% 
% J = spdiags([maindiag, uponediag, downonediag, downtwodiag, negminonediag, mintwodiag, minonediag], ...
%     [0, 1, -1, -2, -(N-1), N-2, N-1], N, N);

n = numel(y);

diagmat = [[y(end - 1); zeros(n - 1, 1)], [-y(2:(end - 1)) ; 0 ; 0], ...
    [y([3:end , 1]) - y([end, 1:(end - 2)]) ; 0], -1*ones(n, 1), [0; y([end, 1:(end - 2)])], ...
    [zeros(n - 2, 1); -y([end, 1])], [zeros(n - 1, 1); y(2)-y(end - 1)]];
dnum = [-(n - 1), -2, -1, 0, 1, n - 2, n - 1];

J = spdiags(diagmat, dnum, n, n);

end
