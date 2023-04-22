function sol = odextend_(sol, f, tfinal, y0, opts)
% OCTAVE FIX: naive odextend implementation to fix event function

% OCTAVE BUG: Octave solvers fail to detect an event sometimes
solnew = feval(sol.solver, f, [sol.x(end), tfinal], y0, opts);

solnew.x = [sol.x, solnew.x];
solnew.y = [sol.y, solnew.y];

sol = solnew;

end
