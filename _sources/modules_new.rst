Functions and Simulink models
=============================

.. toctree::
   :maxdepth: 4

Functions
**********
Pre-simulation
---------------
.. automodule:: Src
  :members:
  :show-inheritance:
  :undoc-members:

Main simulink model
********************
The following image shows the root level of the simulink model. This shows how the different modules work together.
This level is similar for both 3DoF and 6DoF simulations.

.. simulink-diagram:: simL0_multiPath
  :dir: ..
  :addpath: ..

Simulink parts
***************

Environment
------------
The following image shows the environment subsystem of the simulink model.
This subsystem is similar for both 3DoF and 6DoF simulations.
It is used to determine the wind speed at each tether particle and at the kite.

.. simulink-diagram:: simL0_multiPath
  :dir: ..
  :subsystem: Environment_WindModel

Flight controller
------------------
The following image shows the root level of the flight controller

.. simulink-diagram:: simL0_multiPath
  :dir: ..
  :subsystem: Controls

Ground station
---------------
The following image shows the ground station subsystem of the simulink model.
This subsystem is similar for both 3DoF and 6DoF simulations.

.. simulink-diagram:: simL0_multiPath
  :dir: ..
  :addpath: ..
  :subsystem: GroundStationMegAWES

Tether dynamics
----------------

The functions are described inside simulink.
The following image shows the what the inputs and outputs are of the tether module.
This subsystem is similar for both 3DoF and 6DoF simulations.


.. simulink-diagram:: simL0_multiPath
  :dir: ..
  :addpath: ..
  :subsystem: ParticleTetherModel
