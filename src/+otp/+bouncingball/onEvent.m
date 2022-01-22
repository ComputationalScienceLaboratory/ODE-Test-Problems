function [isterminal, newProblem] = onEvent(sol, problem)

% The general idea behind the transformation that we will do here is
% as follows: We transform the ball hitting the surface into a
% horizontal plane, we then invert the y velocity, and transform
% back.

pos = sol.ye(1:2, end);
vel = sol.ye(3:4, end);

% Get the slope of the surface
slope = problem.Parameters.GroundSlope(pos(1));

% rotate into horizontal space, invert the y velocity, then rotate back into our normal space.
newVel = [1 - slope^2, 2*slope; 2*slope, slope^2 - 1] * vel / (slope^2 + 1);

isterminal = false;
newProblem = otp.bouncingball.BouncingBallProblem([sol.xe(end), problem.TimeSpan(end)], [pos; newVel], problem.Parameters);

end
