function J = jac(~, y, k, K, klA, Ks, ~, ~)

J = [-k(3)*y(4).^2-k(1)*y(1).^3*sqrt(y(2))*8.0-(k(2)*y(5))./K,-k(1)*y(1).^4*1.0./sqrt(y(2)),k(2)*y(4),k(2)*y(3)-k(3)*y(1)*y(4)*2.0,-(k(2)*y(1))./K,0.0; ...
    -k(3)*y(4).^2-k(1)*y(1).^3*sqrt(y(2))*2.0,-klA-(k(1)*y(1).^4*1.0./sqrt(y(2)))./4.0-(k(4)*1.0./sqrt(y(2))*y(6).^2)./4.0,0.0,k(3)*y(1)*y(4)*-2.0,0.0,-k(4)*sqrt(y(2))*y(6); ...
    k(1)*y(1).^3*sqrt(y(2))*4.0+(k(2)*y(5))./K,(k(1)*y(1).^4*1.0./sqrt(y(2)))./2.0,-k(2)*y(4),-k(2)*y(3),(k(2)*y(1))./K,0.0; ...
    k(3)*y(4).^2*-2.0+(k(2)*y(5))./K,0.0,-k(2)*y(4),-k(2)*y(3)-k(3)*y(1)*y(4)*4.0,(k(2)*y(1))./K,0.0; ...
    -(k(2)*y(5))./K,(k(4)*1.0./sqrt(y(2))*y(6).^2)./2.0,k(2)*y(4),k(2)*y(3),-(k(2)*y(1))./K,k(4)*sqrt(y(2))*y(6)*2.0; ...
    Ks*y(4),0.0,0.0,Ks*y(1),0.0,-1.0];

end
