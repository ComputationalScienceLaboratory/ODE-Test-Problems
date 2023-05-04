---
title: 'ODE Test Problems'
output:
  rmarkdown::html_vignette:
    keep_md: TRUE
tags:
- Octave
- Matlab
- Initial Value Problems

authors:
  - name: Steven Roberts
    orcid: 0000-0000-0000-0000
    corresponding: true # (This is how to denote the corresponding author)
    equal-contrib: true
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
  - name: Andrey A. Popov
    equal-contrib: true # (This is how you can denote equal contributions between multiple authors)
    affiliation: 2
  - name: Arash Sarshar
    affiliation: 3
  - name: Adrian Sandu
    affiliation: 3
affiliations:
 - name: Lyman Spitzer, Jr. Fellow, Princeton University, USA
   index: 1
 - name: Institution Name, Country
   index: 2
 - name: Virginia Tech
   index: 3

date: 01 May 2023
bibliography: paper.bib
---



# Summary

ODE Test Problems (OTP) is an object-oriented OCTAVE/MATLAB package offering a broad range of initial value problems which can be used to test numerical methods such as time integration or data assimilation methods.  It includes problems that are linear and nonlinear, homogeneous and nonhomogeneous, autonomous and nonautonomous, scalar and high-dimensional, stiff and nonstiff, and chaotic and nonchaotic.  Many are real-world problems from fields such as chemistry, astrophysics, meteorology, and electrical engineering.  OTP also supports partitioned ODEs for testing split, multirate, and other multimethods.  Functions for plotting solutions and creating movies are available for all problems, and exact solutions are included when available. OTP is desgined for ease of use---meaning that working with and modifying problems is simple and intuitive.

[![DOI](https://zenodo.org/badge/201154808.svg)](https://zenodo.org/badge/latestdoi/201154808)


# Statement of need


# Formulation

All test problems in `OTP` are considered as a first-order ordinary differential equation of the form:

$$
\begin{align*}
    Y'(t) &= F(t,Y), \\
    Y(0)  &= Y0,
\end{align*}
$$

where $Y(t)$ is the time-dependent solution to the problem, $F(t,Y)$ is the right-hand-side function representing the time-derivative, and $t$ is the independent variable. The initial condition $Y0$ specifies the value of $Y$ at the initial time $t = 0$.


# Features
Any problems in `OTP` can be initialized using the problem name and a preset that defines well-known parameters and initial conditions for that specific problem. The `Canonical` preset is available for all problems. Problems can be solved by calling the `solve()` method. It is possible to pass optional parameteres to the solver. 

## Basic usage

```Matlab
% Create a problem object
problem = otp.lorenz63.presets.Canonical;

% Solve the problem
sol = problem.solve('RelTol', 1e-10);
```

The `problem` object contains a number of useful properties including:

* `Name`: The name of the problem
* `NumVars`: Number of variables in the state vector
* `Parameters`: Vector of problem-specific parameters that can be modified 
* `RHS` : The Right-hand-side structure includes the ODE right-hand-side function and possibly Jacobians, splittings, etc. (depending on the test problem)
* `TimeSpan`: Timespan of the integration
* `Y0`: Initial condition 

The complete list of test problems implemented in `OTP` can be found [here](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/blob/paper/paper/problems.md).
## Visualizing solutions

`OTP` has built-in plotting capabilities for visualizing the computed solution. The `plot()` method can be used to plot the solution trajectory. The `plotPhaseSpace() ` method creates a phase-space diagram by visualizing all spatial-components of the state vector.

```Matlab
% Plot the solution trajectory
problem.plot(sol);

% Plot the Phase-Space solution 
problem.plotPhaseSpace(sol);
```


##  Changing the solver

You can use any other ODE solvers in `OTP`. This is achievable by passing the right-hand-side function, timespan, initial condition and other optional parameters to the solver. As an example to use the *Implicit* time-stepping method `ode23s`:

```Matlab
sol = ode23s(problem.RHS.F, problem.TimeSpan, problem.Y0, odeset('Jacobian', problem.RHS.Jacobian));
```

# Acknowledgments

# References
