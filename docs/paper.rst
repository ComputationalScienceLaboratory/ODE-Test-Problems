Summary
=======

ODE Test Problems (OTP) is an object-oriented Octave/MATLAB package
offering a broad range of initial value problems in the form of ordinary
and differential-algebraic equations that can be used to test numerical
methods such as time integration or data assimilation methods. It
includes problems that are linear and nonlinear, homogeneous and
nonhomogeneous, autonomous and nonautonomous, scalar and
high-dimensional, stiff and nonstiff, and chaotic and nonchaotic. Many
are real-world problems from fields such as chemistry, astrophysics,
meteorology, and electrical engineering. OTP also supports partitioned
ODEs for testing split, multirate, and other multimethods. Functions for
plotting solutions and creating movies are available for all problems,
and exact solutions are included when available. OTP is designed for
ease of use—meaning that working with and modifying problems is simple
and intuitive.

Statement of need
=================

   One of the pioneering developments in the history of numerical
   methods for differential equations is the use of standardized test
   problems. These have been useful in identifying reliable and accurate
   software.

   —John C. Butcher [@butcher2021series]

Test problems are essential for developing and evaluating numerical
methods for solving differential equations [@thompson1987collection;
@Enright1975Mar; @SODERLIND2006244]. OTP includes a broad assortment of
test problems that have been extensively used in the literature to
investigate numerical methods. These problems range from simple linear
equations to complex chaotic systems of nonlinear differential
equations. The package can be used to evaluate the accuracy, stability,
and convergence of numerical methods by comparing the numerical
solutions obtained by different methods to reference or known exact
solutions. Many of the existing test problems are quipped with
parameters and derivative functions that can be used in data
assimilation and parameter estimation research projects. Another
important application of this packages is to investigate how numerical
methods behave in the presence of oscillations and chaos. Since its
launch, OTP has been used and cited by the scientific computing
community[@glandon2022linearly; @glandon2020biorthogonal;
@cooper2021augmented; @fish2023adaptive, @subrahmanya2021ensemble].

A number of existing test problem packages are available in Julia
[@rackauckas2017differentialequations] and R with fortran subroutines
[@MAZZIA20124119]. While there are some initial value test problems
written in Matlab for a variety of scientific applications, they are
currently dispersed and not organized into a centralized package with a
uniform API. A well designed open-source collection of test problems for
Matlab with Octave compatibility would greatly facilitate numerical
method comparison and benchmarking across various scientific fields,
ultimately leading to the development of more precise and efficient
computational methods.

Formulation
===========

All test problems in OTP are considered as a first-order
differential-algebraic equation of the form:

.. math::


     M(t, y)\;y'(t) = f(t, y), \qquad
     y(t_0) = y_0,

where :math:`y(t)` is the time-dependent solution to the problem,
:math:`f(t, y)` is the right-hand-side function representing the
time-derivative, and :math:`t` is the independent variable. :math:`M` is
the mass-matrix for the differential-algebraic system and when the test
problem is an ordinary differential equation, :math:`M` is the Identity
matrix. The initial condition :math:`y_0` specifies the value of
:math:`y` at the initial time :math:`t = t_0`.

Features
========

Any problem in OTP can be initialized using the *problem name* and a
*preset* that defines a set of specific parameters and initial
conditions. The ``Canonical`` preset is available for all problems.

Solving test problems
---------------------

Problems can be solved by calling the ``solve()`` method. It is possible
to pass optional parameters to the solver.

.. code:: matlab

   % Create a problem object
   problem = otp.lorenz63.presets.Canonical;

   % Solve the problem
   sol = problem.solve('RelTol', 1e-10);

The ``problem`` object contains a number of useful properties including:

-  ``Name``: The name of the problem
-  ``NumVars``: Number of variables in the state vector
-  ``Parameters``: Vector of problem-specific parameters that can be
   modified
-  ``RHS`` : A Right-hand-side structure that includes the ODE
   right-hand-side function and possibly Jacobians, splittings, etc.
   (depending on the test problem)
-  ``TimeSpan``: Timespan of the integration
-  ``Y0``: Initial condition of the problem

The complete list of test problems implemented in OTP and the
documentation for the package can be found
`here <https://computationalsciencelaboratory.github.io/ODE-Test-Problems/>`__.

Visualizing solutions
---------------------

OTP has built-in plotting capabilities for visualizing the computed
solution. The ``plot()`` method can be used to plot the solution
trajectory. The ``plotPhaseSpace()`` method creates a phase-space
diagram by visualizing all spatial-components of the state vector. OTP
also supports animations for the computed solution.

.. code:: matlab

   % Plot the solution trajectory
   problem.plot(sol);

   % Plot the Phase-Space solution 
   problem.plotPhaseSpace(sol);

   % Create a movie of the solution 
   problem.movie(sol);

Changing the solver
-------------------

OTP uses appropriate internal solvers to integrate each problem.
However, if you are researching time-stepping methods you can plug-in
your specific solver to any test problem by passing the right-hand-side
function, timespan, initial condition and other optional parameters to
the solver. As an example, to use the *Implicit* time-stepping method
``ode23s``:

.. code:: matlab

   sol = ode23s(problem.RHS.F, problem.TimeSpan, problem.Y0, ...
                odeset('Jacobian', problem.RHS.Jacobian));

Getting help and Contributing
-----------------------------

ODE Test Problems documentation is maintained on `this
page <https://computationalsciencelaboratory.github.io/ODE-Test-Problems>`__.
New feature requests, and bug reports can be made through `GitHub
issues <https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/issues>`__.
We also accept pull requests that adhere to our `contributing
guide <https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/blob/master/docs/contrib.rst>`__.
An interactive Jupyter Notebook tutorial of the main features of OTP is
available `in the GitHub
repository <https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems/tree/master/notebooks>`__.

Acknowledgments
===============

We would like to thank Mahesh Narayanamurthi, S. Ross Glandon, Amit
Subrahmanya, Bibek Regmi, Randal Tuggle, Reid Gomillion, and the rest of
the Computational Science Lab at Virginia Tech for their feedback and
support of this project.

References
==========
