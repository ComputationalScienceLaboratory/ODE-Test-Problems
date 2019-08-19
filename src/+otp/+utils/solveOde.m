function sol = solveOde(problem, varargin)

rhs = problem.Rhs;

p = inputParser;
p.KeepUnmatched = true;
p.addParameter('Method', @ode45);
p.parse(varargin{:});

options  = odeset(p.Unmatched);
if isprop(rhs, 'Jacobian')
    options.Jacobian = rhs.Jacobian;
end

sol = p.Results.Method(rhs.F, problem.TimeSpan, problem.Y0, options);

% TODO: add event problem support with odextend

end