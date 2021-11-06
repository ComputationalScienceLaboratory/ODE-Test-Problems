function dy = jac(~, y, k1, k2, k3)

dy = [-k1, k3*y(3)           , k3*y(2) ; ...
      k1 , -2*k2*y(2)-k3*y(3), -k3*y(2); ...
      0  , 2*k2*y(2)         , 0        ];

end
