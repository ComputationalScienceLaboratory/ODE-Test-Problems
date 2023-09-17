Usage
================================================================================



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