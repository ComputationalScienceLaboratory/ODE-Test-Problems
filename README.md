# ODE Test Problems

<p align="center">
    <img width="30%" src="images/logo.png" alt="ODE Test Problems" title="ODE Test Problems">
</p>

[![Version](https://img.shields.io/github/v/release/ComputationalScienceLaboratory/ODE-Test-Problems?label=Version)](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/releases)
[![License](https://img.shields.io/github/license/ComputationalScienceLaboratory/ODE-Test-Problems?label=License)](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/blob/master/license.txt)
[![Tests](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/actions/workflows/tests.yml/badge.svg)](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/actions/workflows/tests.yml)
[![Build Documentation](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/actions/workflows/docs.yml/badge.svg)](https://computationalsciencelaboratory.github.io/ODE-Test-Problems/)

ODE Test Problems (OTP) is an object-oriented MATLAB/Octave package offering a broad range of initial value problems in
the form of ordinary and differential-algebraic equations that can be used to test numerical methods such as time
integration or data assimilation. It includes problems that are linear and nonlinear, homogeneous and nonhomogeneous,
autonomous and nonautonomous, scalar and high-dimensional, stiff and nonstiff, and chaotic and nonchaotic. Many are
real-world problems in fields such as chemistry, astrophysics, meteorology, and electrical engineering. OTP also
supports partitioned ODEs for testing split, multirate, and other multimethods. Functions for plotting solutions and
creating movies are available for all problems, and exact solutions are included when available. OTP is designed for
ease of use meaning that working with and modifying problems is simple and intuitive.

OTP is actively under development. We are currently writing full documentation in order to release version 1.0.0

## Installation

### MATLAB

1. Download the latest [OTP toolbox file](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/releases/latest/download/OTP.mltbx).
2. Open the toolbox file from MATLAB and follow the installer. See [MATLAB's instructions](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html) for additional details.

### Octave

In Octave, run

```matlab
pkg install 'https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/releases/latest/download/OTP.zip'
```

then load the package with

```matlab
pkg load 'ode test problems'
```

### From Source

For local development, OTP can be installed by running

```matlab
OTP.install
```

from the root directory of the project. If no longer needed, it can be uninstalled with `OTP.uninstall`.

## Example

```matlab
% Create a problem
problem = otp.lotkavolterra.presets.Canonical;

% Solve the problem
sol = problem.solve('RelTol', 1e-10);

% Plot the solution
problem.plot(sol);

% Adjust a parameter
problem.Parameters.PreyDeathRate = 2;

% Manually use a MATLAB ODE solver to solve the problem
options = odeset('Jacobian', problem.RHS.Jacobian);
[t, y] = ode15s(problem.RHS.F, problem.TimeSpan, problem.Y0, options);

% Plot the phase space with a custom title
problem.plotPhaseSpace(t, y, 'Title', 'The Circle of Life');

% Create a movie 
mov = problem.movie(t, y);
```
