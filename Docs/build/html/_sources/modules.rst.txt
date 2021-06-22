Functions and Simulink models
=============================

.. toctree::
   :maxdepth: 4

Functions
**********

.. automodule:: Src.Common
  :members:
  :show-inheritance:
  :undoc-members:

.. automodule:: Extra
  :members:
  :show-inheritance:
  :undoc-members:

Main simulink model
********************

.. simulink-diagram:: Dyn_PointMass_r2019b
  :dir: ../../Src/3DoF/Simulink
  :addpath: ../../Common/Environment;../../Common/FlightController;
      ../../Common/Flightpaths;../../Common/Flightpaths/boothLem;
      ../../Common/GroundStation;../../Common/Tether;../../Common/Visualisation;
      ../..;../../..

Simulink parts
***************

Environment
------------
.. simulink-diagram:: Dyn_PointMass_r2019b
  :dir: ../../Src/3DoF/Simulink
  :addpath: ../../Common/Environment;../../Common/FlightController;
      ../../Common/Flightpaths;../../Common/Flightpaths/boothLem;
      ../../Common/GroundStation;../../Common/Tether;../../Common/Visualisation;
      ../..;../../..
  :subsystem: Environment


.. automodule:: Src.Common.Environment
  :members:
  :show-inheritance:
  :undoc-members:

Flight controller
------------------

.. simulink-diagram:: Dyn_PointMass_r2019b
  :dir: ../../Src/3DoF/Simulink
  :addpath: ../../Common/Environment;../../Common/FlightController;
      ../../Common/Flightpaths;../../Common/Flightpaths/boothLem;
      ../../Common/GroundStation;../../Common/Tether;../../Common/Visualisation;
      ../..;../../..
  :subsystem: AirborneSystem/FlightControlSystem

.. automodule:: Src.Common.FlightController
  :members:
  :show-inheritance:
  :undoc-members:

Flightpaths
^^^^^^^^^^^^
These functions are called by the PathFollowingController.

.. .. simulink-diagram:: Dyn_PointMass_r2019b
..     :dir: ../../Src/3DoF/Simulink
..     :addpath: ../../Common/Environment;../../Common/FlightController;
..         ../../Common/Flightpaths;../../Common/Flightpaths/boothLem;
..         ../../Common/GroundStation;../../Common/Tether;../../Common/Visualisation;
..         ../..;../../..
..     :subsystem: AirborneSystem/FlightControlSystem/PathFollowingController

.. automodule:: Src.Common.Flightpaths
  :members:
  :show-inheritance:
  :undoc-members:

.. automodule:: Src.Common.Flightpaths.boothLem
  :members:
  :show-inheritance:
  :undoc-members:

Ground station
---------------

.. simulink-diagram:: Dyn_PointMass_r2019b
  :dir: ../../Src/3DoF/Simulink
  :addpath: ../../Common/Environment;../../Common/FlightController;
      ../../Common/Flightpaths;../../Common/Flightpaths/boothLem;
      ../../Common/GroundStation;../../Common/Tether;../../Common/Visualisation;
      ../..;../../..
  :subsystem: GroundSystem/StateMachine

.. automodule:: Src.Common.GroundStation
  :members:
  :show-inheritance:
  :undoc-members:

Tether dynamics
----------------

The functions are described inside simulink.

.. simulink-diagram:: Dyn_PointMass_r2019b
  :dir: ../../Src/3DoF/Simulink
  :addpath: ../../Common/Environment;../../Common/FlightController;
      ../../Common/Flightpaths;../../Common/Flightpaths/boothLem;
      ../../Common/GroundStation;../../Common/Tether;../../Common/Visualisation;
      ../..;../../..
  :subsystem: ParticleTetherModel/Tether

.. automodule:: Src.Common.Tether
  :members:
  :show-inheritance:
  :undoc-members:

Offline visualisation
----------------------

.. automodule:: Src.Offline_visualisation
  :members:
  :show-inheritance:
  :inherited-members:
  :undoc-members:
