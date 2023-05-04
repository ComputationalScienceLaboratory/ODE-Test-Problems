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

ODE Test Problems (OTP) is an object-oriented OCTAVE/MATLAB package offering a broad range of initial value problems which can be used to test numerical methods such as time integration or data assimilation methods.  It includes problems that are linear and nonlinear, homogeneous and nonhomogeneous, autonomous and nonautonomous, scalar and high-dimensional, stiff and nonstiff, and chaotic and nonchaotic.  Many are real-world problems from fields such as chemistry, astrophysics, meteorology, and electrical engineering.  OTP also supports partitioned ODEs for testing split, multirate, and other multimethods.  Functions for plotting solutions and creating movies are available for all problems, and exact solutions are princluded when available. OTP is desgined for ease of use---meaning that working with and modifying problems is simple and intuitive.

[![DOI](https://zenodo.org/badge/201154808.svg)](https://zenodo.org/badge/latestdoi/201154808)


# Statement of need


# Formulation


# Components


# Use cases

##  Changing the solver

```{octave}
sol = ode23s(problem.RHS.F, problem.TimeSpan, problem.Y0, odeset('Jacobian', problem.RHS.Jacobian));
```

# Available test problems

You can use any of the problems using the template command

`model = otp.{problem name}.presets.{Preset name};`

Here is a table of test problems currently implemented in `OTP`. A default `{Preset name}` for all implemented problems is `Canonical`. Other presets are specific to each test problem.

| Test Problem       | Description                                                                                         |
|--------------------|-----------------------------------------------------------------------------------------------------|
| allencahn          | The Allen-Cahn equation models phase separation and pattern formation.                               |
| ascherlineardae    | A linear advection-diffusion equation used to study numerical stability.                            |
| arenstorf          | The Arenstorf orbit problem models a spacecraft's trajectory around the moon.                        |
| bouncingball       | A simple bouncing ball model used to study event detection and simulation.                           |
| brusselator        | The Brusselator is a simple model for chemical reactions that exhibits oscillatory behavior.         |
| cusp               | The cusp equation models a system with a fold bifurcation.                                           |
| e5                 | A set of differential equations describing a predator-prey model with spatial interactions.         |
| hires              | A set of differential equations used to study high-dimensional chaos and long-term integration.     |
| inverterchain      | A chain of inverters used to study coupled oscillators.                                              |
| kpr                | The KPR model is used to study pattern formation in chemical reactions.?                              |
| lienard            | The Lienard equation models a system with a Hopf bifurcation.                                        |
| lorenz63           | The Lorenz 63 system is a simple model for atmospheric convection that exhibits chaotic behavior.    |
| lorenz96           | A set of differential equations used to study atmospheric dynamics and chaos.                       |
| lotkavolterra      | A set of differential equations modeling population dynamics in predator-prey systems.             |
| nbody              | A set of differential equations describing the motion of N interacting point masses.               |
| oregonator         | The Oregonator model is a set of differential equations used to study oscillatory behavior.         |
| pendulum           | The simple pendulum equation models the motion of a swinging pendulum.                               |
| protherorobinson   | The Prothero-Robinson system is used to study the stability of numerical schemes.                   |
| quadratic          | A simple quadratic model used to study numerical methods for ODEs.                                   |
| robertson          | The Robertson reaction model is a set of differential equations used to study chemical kinetics.     |
| sanzserna          | A set of differential equations used to study numerical methods for DAEs.                           |
| torus              | The torus equation models the motion of a point on a torus.                                           |
| transistoramplifier | A set of differential equations modeling the behavior of a common emitter transistor amplifier circuit. |
| trigonometricdae   | A set of differential-algebraic equations used to study numerical methods for DAEs.                 |
| vanderpol          | The van der Pol oscillator models the behavior of an electronic oscillator.                          |



# Acknowledgments

# References
