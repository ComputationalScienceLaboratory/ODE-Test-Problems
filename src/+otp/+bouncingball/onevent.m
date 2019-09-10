function [isterminal, newProblem] = onevent(sol, problem)

% The general idea behind the transformation that we will do here is
% as follows: We transform the ball hitting the surface into a
% horizontal plane, we then invert the y velocity, and transform
% back.

params = problem.Parameters;

% get all the variables that we need.
px = sol.ye(1, end);
py = sol.ye(2, end);
xVel = sol.ye(3, end);
yVel = sol.ye(4, end);

% Get the slope of the surface
slope = params.dgroundFunction(px);

% rotate into horizontal space, invert the y velocity, then rotate back into our normal space.
xVelNew = ((1 - slope^2)*xVel + 2*slope*yVel)/(slope^2 + 1);
yVelNew = (2*slope*xVel - (1 - slope^2)*yVel)/(slope^2 + 1);

isterminal = false;
newProblem = otp.bouncingball.BouncingBallProblem([sol.xe(end), problem.TimeSpan(end)], [px; py; xVelNew; yVelNew], params);

end
