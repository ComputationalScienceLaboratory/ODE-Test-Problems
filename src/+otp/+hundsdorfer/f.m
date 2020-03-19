function [dy] = f(t, y, alpha, D1x, k, s ,bfun, boundaryVec)
u = y(1:numel(y)/2);
v = y(numel(y)/2+1:end);
bv  = bfun(t);

ut = -alpha(1)*(D1x*u + boundaryVec(bv)) - k(1)*u + k(2)*v +s(1);
vt = k(1)*u - k(2)*v +s(2);
dy = [ut;vt];
end

