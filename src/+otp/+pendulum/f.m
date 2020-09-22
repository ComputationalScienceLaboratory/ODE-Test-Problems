function dy = f(~, y, g, l)
dy = [
    y(2);
    -g/l * sin(y(1))
    ];
end
