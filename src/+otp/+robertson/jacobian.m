function dy = jacobian(~, y, k1, k2, k3)
%JACOBIAN The Jacobian for the Robertson problem
%
%   See also otp.robertson.f, otp.robertson.RobertsonProblem

dy = [-k1, k3*y(3)           , k3*y(2) ; ...
      k1 , -2*k2*y(2)-k3*y(3), -k3*y(2); ...
      0  , 2*k2*y(2)         , 0        ];

end
