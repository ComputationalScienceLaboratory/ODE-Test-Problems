# ODE Test Problems

A MATLAB suite of initial value problems

## Installation

TODO

### Installation from Source

OTP can be installed as a local MATLAB toolbox or Octave package
by running

```matlab
OTP.install
```

from the root directory of the project.  If no longer needed, it can be
uninstalled with `OTP.uninstall`.

## Example

```matlab
% Create a problem
problem = otp.lotkavolterra.presets.Canonical;

% Solve the problem
sol = problem.solve('RelTol', 1e-10);

% Plot the solution
problem.plot(sol);

% Adjust a parameter
problem.Parameters.preyDeathRate = 2;

% Manually use a MATLAB ODE solver to solve the problem
options = odeset('Jacobian', problem.Rhs.Jacobian);
[t, y] = ode15s(problem.Rhs.F, problem.TimeSpan, problem.Y0, options);

% Plot the phase space with a custom title
problem.plotPhaseSpace(t, y, 'Title', 'The Circle of Life');

% Create a movie and write to file
mov = problem.movie(t, y, 'Save', 'lotka-volterra.avi');
```
