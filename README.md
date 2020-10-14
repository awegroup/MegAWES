# MWAWES (v<sub>w</sub>=12 ms<sup>-1</sup>)

[![Version](https://img.shields.io/github/v/release/awegroup/MegAWES?label=Latest%20release&sort=semver)](https://github.com/awegroup/MegAWES/releases)
[![Matlab](https://img.shields.io/badge/Matlab%20Simulink-2020A-brightgreen)](https://www.mathworks.com/products/simulink) <!--static-->
[![Matlab](https://img.shields.io/badge/Matlab%20Simulink-2018B-yellow)](https://www.mathworks.com/products/simulink) <!--static-->
[![License](https://img.shields.io/github/license/awegroup/MegAWES?label=License)](http://www.apache.org/licenses/)

![Aircraft](DE2019_Aircraft.jpeg)
<!--<img src="DE2019_Aircraft.jpeg" alt="alt text" width="600"/>-->

MWAWES is a Matlab/Simulink model of an airborne wind energy (AWE) system based on a tethered rigid wing that is operated in pumping cycles producing more than a megawatt of electricity evaluated at 12 meter per second ground wind speed (6m height). The framework is a further development of the graduation project of Dylan Eijkelhof which was jointly supervised by TU Delft, ETH Zurich and DTU [[1,2]](#References). The ultimate purpose is to provide a reference model of a megawatt-range AWE system and a computational framework to simulate its operation. The simulink framework includes the following model components:

* Pre-calculated look-up tables for aircraft's aerodynamic behaviour.
* Segmented tether with a single attachment point at the kite's centre of gravity.
* 3DOF point mass dynamic solver.
* Aircraft controller with initiation phase and power generation flight controls.
* Set-force controlled dynamic winch (based on [[3]](#References)).


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to run the software and how to install them.

1. Install Matlab R2020A, Simulink R2020a and some extra packages (for instructions how te get matlab, click [here](https://www.mathworks.com/products/get-matlab.html)):

	```
	Matlab (version R2020A, 9.8 tested)
	Simulink (version R2020A, 10.1 tested)
	Curve Fitting Toolbox (version 3.5.11 tested)
	Aerospace Blockset (version 4.3 tested)
	Phased Array System Toolbox (version 4.3 tested)
	```

### Installing

A step by step series of examples that tell you how to get a development env running

1. Get a copy of the latest `MWAWES` environment release:

	```
	git clone https://github.com/awegroup/MWAWES.git
	```

## Deployment

1. The following file allows you to run a full simulation until power cycle convergence of the current aircraft.

	```
	Run_OneSimulation.m
	```

2. All input variables are set in:

	```
	initAllSimParams_DE2019.m
	```
	Following parameters are set:
	1. Aircraft is loaded from the `DE2019_params.mat` file.
	2. Environment parameters
	3. Steady base windspeed, 6m altitude (no turbulence is included at this stage).
	4. Simulation initialisation parameters
	5. Simulation constraints
	6. Tether characteristics
	7. Winch characteristics
	8. Flight path shape
	9. Tether force set-point (tracking)
	10. Controller gains
	11. Initialisation phase, loiter

3. In the simulink model, the output parameters are defined in block:

	```
	RequirementModelsAndLogging
	```

An example of the visualisation of the output is given in the main file `Run_OneSimulation.m` at the bottom.
There the continuous power throughout the cycle is plotted, and a visual of the flight path is plotted in a 3D environment with colour coding the power production. 

Also an example is provided on how to visualise the converged power pumping cycle as an animation.

## Built With

* [Matlab](https://www.mathworks.com/products/matlab) - The program language used
* [Simulink](https://www.mathworks.com/products/simulink) - The GUI used for model-based design through block diagrams

<!--## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.-->

## Versioning

For the versions available, see the [tags on this repository](https://github.com/awegroup/MWAWES/tags). 

## Authors

* **Dylan Eijkelhof** - *Initial work current system, multi-MW aircraft* - [GitHub](https://github.com/DylanEij)
* **Urban Fasel** - *Initial framework set-up* 
* **Sebastian Rapp** - *Flight controller design*

See also the list of [contributors](https://github.com/awegroup/MWAWES/graphs/contributors) who participated in this project.

## License

This project is licensed under the Apache License - see the [LICENSE](LICENSE.md) file for details

## References
[1] Eijkelhof, Dylan. "Design and Optimisation Framework of a Multi-MW Airborne Wind Energy Reference System." (2019) Delft University of Technoly and Technical University of Denmark, MSc thesis. [uuid:e759f9ad-ab67-43b3-97e0-75558ecf222d](http://resolver.tudelft.nl/uuid:e759f9ad-ab67-43b3-97e0-75558ecf222d)

[2] Eijkelhof, Dylan, et al. "Reference Design and Simulation Framework of a Multi-Megawatt Airborne Wind Energy System." Journal of Physics: Conference Series. Vol. 1618. No. 3. IOP Publishing, 2020. [doi:10.1088/1742-6596/1618/3/032020](https://doi.org/10.1088/1742-6596/1618/3/032020)

[3] Fechner, Uwe, et al. "Dynamic model of a pumping kite power system." Renewable Energy 83 (2015): 705-716. [doi:10.1016/j.renene.2015.04.028](http://dx.doi.org/10.1016/j.renene.2015.04.028)

## Acknowledgments

* Outstanding guidance of Roland Schmehl (TU Delft) and Mac Gaunaa (DTU wind energy).
* This project is financially supported by the Unmanned Valley Valkenburg project of the European Regional Development Fund.
* A special thank you to the following people whos work helped with the design of the DE2019 aircraft:
	* Dr. Dominic Keidel
	* Cla Mattia Galliard
	* Lorenz Affentranger
	* Gian Joerimann
	* Michael Imobersteg
