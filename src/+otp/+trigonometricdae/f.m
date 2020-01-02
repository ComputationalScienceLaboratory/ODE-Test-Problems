function dy = f(~, y,~)

y1 = y(1);
y2 = y(2);

dy = [y1^2/(y2*sqrt((y1/y2)^2 -1 )); y2^2 + 1/(1+y1^2)- y1^2*(1/y2^2-1)];

end
