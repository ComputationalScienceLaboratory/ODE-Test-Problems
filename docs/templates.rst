Adding new problems to ``OTP``
==============================

To add a new test problem to ``ODE Test Problems`` follow these steps.

1. Check out the latest version of ``OTP`` from Github

.. code:: bash

   git clone https://github.com/ComputationalScienceLaboratory/ODE-Test-Problems.git
   cd cd ODE-Test-Problems/

2. Create a new folder in the ``src/+opt/`` directory. Follow the same
   naming convention such as starting the name with ``+`` to maintain
   the structure of the Matlab/Octave package. Also create a subfolder
   named ``+presets`` in the new problem folder:

.. code:: bash

   mkdir src/+otp/+newtest
   mkdir src/+otp/+newtest/+presets
   cd src/+otp/

3. The minimal set of files needed inside the problem folder to set up a
   new test problem are:

-  The right-hand-side function named as ``f.m``
-  The problem class to initialize problem objects and its methods adn
   properties
-  The parameters class define the parameters of the new problem
-  A ``Canonical.m`` preset inside the ``+presets`` subfolder to set the
   initial condition and parameters for your case

The right-hand-side function
----------------------------
