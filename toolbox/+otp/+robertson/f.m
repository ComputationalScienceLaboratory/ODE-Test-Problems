function dy = f(~, y, k1, k2, k3)
%F The right-hand side function for the Robertson problem
%
%   See also otp.robertson.RobertsonProblem

dy = [-k1*y(1) + k3*y(2)*y(3); k1*y(1)-k2*y(2)^2-k3*y(2)*y(3); k2*y(2)^2];

end
