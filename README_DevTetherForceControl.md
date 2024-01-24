# Development branch for Kite Tether Force control

This development branch was used for the MSc thesis of Jesse Hummel [1]. From his work:

> Power output during flight operation of multi-megawatt airborne wind energy systems is substantially affected by the mass of the airborne subsystem, resulting in power fluctuations. In this paper, an approach to control the tether force using the airborne subsystem is presented that improves the quality of the power output. This kite tether force control
concept is implemented on the 3DOF dynamic simulation of the MegAWES reference model. First, the winch of MegAWES is resized because an analysis of winch inertia and radius shows its effect on power output and tether force overshoot. Second, the power consuming sections during the traction phase are eliminated by using a feedforward winch controller. Finally, the peak power is substantially reduced by implementing the kite tether force controller which uses a measurement of the tether force, angle of attack, and airspeed to keep the tether force constant when the system is at its power limit. This reduces the range between minimum and maximum power output by 75%.

## Changes to MegAWES
To achieve this a few modifications have been made to MegAWES:
- `Run_OneSimulation.m`:
    - Add some parameters to the `params` struct that are required for kite tether force control.
    - Added a section to save a simulation run.
- `initAllSimParams_DE2019.m`:
    - Different size for the winch (radius and inertia).
- `Dyn_PointMass_r2019b`:
    - `WinchControl`:
        - Added `PassiveTorqueControl` (colored yellow) which implements a passive torque feedback law like in [2].
        - Added `Choose which signal to use` (colored yellow) to switch between the original and new winch torque controller.
    - `PathFollowingController`:
        - Routed `f_t_kite` to `FlightOnSphere (traction)`.
    - `FlightOnSphere (traction)`:
        - Routed `f_t_kite` to `FlightPathLoopTraction`.
        - Routed `sub_flight_state` to `FlightPathLoopTraction`.
    - `FlightPathLoopTraction`:
        - Added `kiteTetherForceControl` (colored yellow) which implements the kite tether force controller.
        - Added `Choose which signal to use` (colored yellow) which switches between the original and new angle of attack controller.
- Added `compare_runs.m`:
    - Compare different runs after you've saved them using the new section in `Run_OneSimulation.m`.

## Further improvements
His work had a few limitations that further development on this branch aims to fix:
- The retraction and transition controllers do not work anymore because of the increase in winch inertia and radius. The simulation consistency fails during retraction or transition from retraction to traction.
- During the transition to traction, the controller makes a sudden switch from winch control strategy, this makes the tether force oscillate for a bit.
- The parameters (such as controller gains) are only tuned for the 3DOF case at 22 m/s. For lower wind speeds, a minimum tether force is likely required to keep the kite afloat when flying upwards in the figure of eight.
- The system currently assumed a 2-phase strategy [2], but could also work with a 3-phase strategy [2] if there is an additional communication link to communicate the start/end of the different phases.
- The passive winch controller assumes an ideal reel-out factor of 1/3. Slightly lowering this gives a higher mean cycle power [2]. Furthermore, these quasi-steady models don't take into account the effect of gravity. It could prove very beneficial to find a winch control curve specially derived for MegAWES [1].

Some other, more general, improvements to MegAWES were also identified:
- In `simOut`, `P_mech` is calculated as tether force multiplied by reel-out speed. However, this is the mechanical power that the kite transfers into the winch, not the mechanical power that the winch aims to convert to electrical energy, which is equal to torque times rotational speed. It would be useful to add this to the model, together with a utility function to go from mechanical power to electrical power.
- The winch dynamics uses a discrete integrator instead of a continuous integrator but it is unclear why.
- Flying outside-down figures of eight. On the outside of the figure-of-eight, the wind power is lowest but currently the kite is flying upwards here. It could be beneficial to fly upwards in the middle, where the most wind power is available.

## References
[1] J. Hummel, “Kite Tether Force Control: Reducing Power Fluctuations for Utility-Scale Airborne Wind Energy Systems,” Delft University of Technology, Delft, Netherlands, 2023. [Online]. Available: http://resolver.tudelft.nl/uuid:2a0b5cb1-ab4d-44bf-b6b6-929c612941fb

[2] R. H. Luchsinger, “Pumping Cycle Kite Power,” in Airborne Wind Energy, U. Ahrens, M. Diehl, and R. Schmehl, Eds., in Green Energy and Technology. Berlin, Heidelberg: Springer Berlin Heidelberg, 2013, pp. 47–64. doi: 10.1007/978-3-642-39965-7_3.
