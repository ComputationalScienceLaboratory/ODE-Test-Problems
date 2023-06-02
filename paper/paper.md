---
title: 'ODE Test Problems'
output:
  rmarkdown::html_vignette:
    keep_md: TRUE
tags:
- Octave
- Matlab
- Initial Value Problems
- Ordinary Differential Equations
- Differential algebraic equations

authors:
  - name: Steven Roberts
    orcid: 0000-0002-7225-2501
    corresponding: true # (This is how to denote the corresponding author)
    equal-contrib: true
    affiliation: "1" # (Multiple affiliations must be quoted)
  - name: Andrey A. Popov
    equal-contrib: true # (This is how you can denote equal contributions between multiple authors)
    orcid: 0000-0002-7726-6224
    affiliation: 2
  - name: Arash Sarshar
    affiliation: 3
    orcid: 0000-0002-6633-8915
  - name: Adrian Sandu
    orcid: 0000-0002-5380-0103
    affiliation: 3
affiliations:
 - name: Lawrence Livermore National Laboratory
   index: 1
 - name: Oden Institute for Computational Engineering & Sciences, The University of Texas at Austin
   index: 2
 - name: Department of Computer Science and Applications, Virginia Tech
   index: 3

date: 01 May 2023
bibliography: paper.bib
---

# Summary

ODE Test Problems (`OTP`) is an object-oriented OCTAVE/MATLAB package offering a broad range of initial value problems in the form of ordinary and differential-algebraic equations that can be used to test numerical methods such as time integration or data assimilation methods.  It includes problems that are linear and nonlinear, homogeneous and nonhomogeneous, autonomous and nonautonomous, scalar and high-dimensional, stiff and nonstiff, and chaotic and nonchaotic.  Many are real-world problems from fields such as chemistry, astrophysics, meteorology, and electrical engineering.  OTP also supports partitioned ODEs for testing split, multirate, and other multimethods.  Functions for plotting solutions and creating movies are available for all problems, and exact solutions are included when available. OTP is designed for ease of use---meaning that working with and modifying problems is simple and intuitive.

[![DOI](https://zenodo.org/badge/201154808.svg)](https://zenodo.org/badge/latestdoi/201154808)


# Statement of need

Test problems are essential for developing and evaluating numerical methods for solving differential equations [@thompson1987collection; @Enright1975Mar; @SODERLIND2006244]. `OTP` includes a broad assortment of test problems that have been extensively used in the literature to investigate numerical methods. These problems range from simple linear equations to complex chaotic systems of nonlinear differential equations. The package can be used to evaluate the accuracy, stability, and convergence of numerical methods by comparing the numerical solutions obtained by different methods to reference or known exact solutions. Many of the existing test problems are quipped with parameters and derivative functions that can be used in data assimilation and parameter estimation research projects. Another important application of this packages is to investigate how numerical methods behave in the presence of oscillations and chaos. Since its launch, `OTP` has been used and cited by the scientific computing community[@glandon2022linearly; @glandon2020biorthogonal; @cooper2021augmented; @fish2023adaptive, @subrahmanya2021ensemble].

A number of existing test problem packages are available in Julia [@rackauckas2017differentialequations] and R with fortran subroutines [@MAZZIA20124119].  While there are some initial value test problems written in Matlab for a variety of scientific applications, they are currently dispersed and not organized into a centralized package with a uniform API.  A well designed open-source collection of test problems for Matlab with Octave compatibility would greatly facilitate numerical method comparison and benchmarking across various scientific fields, ultimately leading to the development of more precise and efficient computational methods.

# Formulation

All test problems in `OTP` are considered as a first-order  differential-algebraic equation of the form:

$$
    \mathbf{M}\;Y'(t) = \mathbf{F}(t,Y), \qquad
    Y(t_0)  = Y_0,
$$

where $Y(t)$ is the time-dependent solution to the problem, $F(t,Y)$ is the right-hand-side function representing the time-derivative, and $t$ is the independent variable. $\mathbf{M}$ is the mass-matrix for the differential-algebraic system and when the test problem is an ordinary differential equation, $\mathbf{M}$ is the Identity matrix. The initial condition $Y_0$ specifies the value of $Y$ at the initial time $t = t_0$.


# Features

Any problem in `OTP` can be initialized using the *problem name* and a *preset* that defines a set of specific parameters and initial conditions. The `Canonical` preset is available for all problems. 

## Solving test problems

Problems can be solved by calling the `solve()` method. It is possible to pass optional parameters to the solver.

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
* `RHS` : A Right-hand-side structure that includes the ODE right-hand-side function and possibly Jacobians, splittings, etc. (depending on the test problem)
* `TimeSpan`: Timespan of the integration
* `Y0`: Initial condition of the problem

The complete list of test problems implemented in `OTP` and the documentation for the package can be found [here](https://computationalsciencelaboratory.github.io/ODE-Test-Problems/).

## Visualizing solutions

`OTP` has built-in plotting capabilities for visualizing the computed solution. The `plot()` method can be used to plot the solution trajectory. The `plotPhaseSpace() ` method creates a phase-space diagram by visualizing all spatial-components of the state vector. `OTP` also supports animations for the computed solution. 

```Matlab
% Plot the solution trajectory
problem.plot(sol);

% Plot the Phase-Space solution 
problem.plotPhaseSpace(sol);

% Create a movie of the solution 
problem.movie(sol);
```


##  Changing the solver

`OTP` uses appropriate internal solvers to integrate each problem. However, if you are researching time-stepping methods you can plug-in your specific solver to any test problem by passing the right-hand-side function, timespan, initial condition and other optional parameters to the solver. As an example, to use the *Implicit* time-stepping method `ode23s`:

```Matlab
sol = ode23s(problem.RHS.F, problem.TimeSpan, problem.Y0, ...
              odeset('Jacobian', problem.RHS.Jacobian));
```

## Getting help and Contributing

`ODE Test Problems` documentation is maintained on [this page](https://computationalsciencelaboratory.github.io/ODE-Test-Problems).  

New feature requests, and bug reports can be made through 
[GitHub issues](https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/issues).
We also accept pull requests that adhere to our
[contributing guide](../docs/contrib.rst).



An interactive tutorial on the main features of `OTP` is available in a Jupyter notebook [in the repository](github.com/ComputationalScienceLaboratory/ODE-Test-Problems/blob/master/notebooks)

# Acknowledgments

We would like to thank Drs. M. Narayanamurthi and S. R. Glandon as well as A. Subrahmanya , B. Regmi, R. Tuggle, R. Gomillion, and the rest of the Computational Science Lab at Virginia Tech for their feedback and support of this project.

# References
