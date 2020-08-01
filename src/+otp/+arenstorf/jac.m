function dfy = jac(~, y, m1 ,m2)

D1 = m1/((m2 - y(1))^2 + y(2)^2)^(3/2);
D2 = m2/((m1 + y(1))^2 + y(2)^2)^(3/2);
L1 = (2*((m2 - y(1))^2 + y(2)^2)^(5/2));
L2 = ((m1 + y(1))^2 + y(2)^2)^(5/2);


dfy =[ 0,  0,  1, 0;
       0,  0,  0, 1;
       (3*m1*(2*m2 - 2*y(1))*(m2 - y(1)))/L1 - D1 - D2 + (3*m2*(2*m1 + 2*y(1))*(m1 + y(1)))/(2*L2) + 1,  (3*m2*y(2)*(m1 + y(1)))/L2 - (3*m1*y(2)*(m2 - y(1)))/((m2 - y(1))^2 + y(2)^2)^(5/2),  0, 2;
       (3*m2*y(2)*(m1 + y(1)))/L2 - (3*m1*y(2)*(2*m2 - 2*y(1)))/L1, (3*m1*y(2)^2)/((m2 - y(1))^2 + y(2)^2)^(5/2) - D1 - D2 + (3*m2*y(2)^2)/L2 + 1, -2, 0];

end
