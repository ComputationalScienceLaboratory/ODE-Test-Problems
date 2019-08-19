# ODE Test Problems

A MATLAB suite of initial value problems

## Installation

ODE Test Problems can be installed by running the MATLAB script `install` from the root directory of the project.

## Example

```matlab
% Create a problem
problem = otp.brusselator.presets.Canonical;

% Use a MATLAB ODE solver to solve the problem
options = odeset('Jacobian', problem.Rhs.Jacobian);
sol = ode15s(problem.Rhs.F, problem.TimeSpan, problem.Y0, options);

% Plot the solution
problem.plot(sol);

% Adjust a parameter
problem.Parameters.a = 2;

% Solve the problem again but this time using a built-in utility
sol = otp.utils.solveOde(problem);

% Plot the phase space with a custom title
problem.plotPhaseSpace(sol, 'title', 'Reactant X versus Reactant Y');

% Create a movie and write to file
mov = problem.movie(sol, 'Save', 'brusselator.avi');
```
