function jac = jac(~, y, g, l)

jac = [
    0, 1;
    -g/l*cos(y(1)), 0
    ];

end


