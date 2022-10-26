# MegAWES (3DoF & 6DoF kite dynamics)

[![Version](https://img.shields.io/github/v/release/awegroup/MegAWES?label=Latest%20release)](https://github.com/awegroup/MegAWES/releases)
[![Matlab19B](https://img.shields.io/static/v1?label=Matlab%20Simulink&message=2019B&color=brightgreen)](https://www.mathworks.com/products/simulink) <!--static-->
[![License](https://img.shields.io/github/license/awegroup/MegAWES?label=License)](http://www.apache.org/licenses/)
[![Documentation Status](https://readthedocs.org/projects/megawes/badge/?version=latest)](https://megawes.readthedocs.io/en/latest/?badge=latest)

MegAWES is a Matlab/Simulink model of an airborne wind enrgy (AWE) system based on a tethered rigid wing that is operated in pumping cycles producing multiple megawatt of electricity. Additional info can be foud in the publication in Journal of Renewable Energy [[1]](#References). The framework is a further development of the graduation project of Dylan Eijkelhof which was jointly supervised by TU Delft, ETH Zurich and DTU [[2,3]](#References). The ultimate purpose is to provide a reference model of a megawatt-range AWE system and a computational framework to simulate its operation. The simulink framework includes the following model components:

* Pre-calculated look-up tables for aircraft's aerodynamic behaviour.
* Segmented tether with a single attachment point at the kite's centre of gravity.
* Choice between 3DoF point-mass  and 6DoF rigid-body dynamic solver.
* Aircraft controller for power generation flight controls and path tracking.
* Set-force controlled dynamic winch (based on [[4]](#References)).

![](DE2019_Aircraft.jpeg)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

What things you need to run the software and how to install them.

1. Install Matlab/Simulink R2019B and some extra packages (for instructions how te get matlab, click [here](https://www.mathworks.com/products/get-matlab.html)):

	```
	Matlab (version R2019B, 9.7)
	Simulink (version R2019B, 10.0)
	Curve Fitting Toolbox (version 3.5.10, only needed for 6DoF)
	Stateflow (version 10.1)
	DSP System Toolbox (version 9.9, only needed for tether test cases)
	```
	
2. Install Git and Git-lfs (for instructions how te get git and git-lfs, click [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for git and [here](https://docs.github.com/en/github/managing-large-files/installing-git-large-file-storage) for git-lfs). Without git-lfs the libraries might not clone properly (note: other methods might also work).
3. After installation of git-lfs run the following command in a terminal (Unix, MacOS)/command(Windows) window:

	```
	git lfs install
	```

### Installing

1. Do not forget to check if the [previously mentioned software](#Prerequisites) is installed.
2. Get a copy of the latest `MegAWES` environment release:

	```
	git clone https://github.com/awegroup/MegAWES.git
	```

## Deployment

A step by step series of examples that tell you how to get a development env running, tested on macOS 11.2.3

1. The following file allows you to run a full simulation until power cycle convergence of the current aircraft.

	```
	Run_OneSimulation.m
	```
	
	Two important parameters are set here:
	
	```
	Kite_DOF: Kite degrees of freedom, 3 (point-mass) or 6 (rigid-body)
	windspeed: Maximum wind speed of the wind shear profile, occurs at 250m altitude and above,
		3DoF: Always forced to 22m/s
		6DoF: 8m/s, 10m/s, 14m/s, 16m/s, 18m/s, 20m/s, 22m/s, 25m/s, 28m/s, 30m/s
	```

2. All input variables are set in:

	```
	Src/Common/Get_simulation_params.m
	```
		
	where base variables are set in:
	
	```
	Src/Common/initAllSimParams_DE2019.m
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
	11. Initialisation phase (loiter)

3. In the simulink models for both 3 and 6 DoF, the output parameters are defined in block:

	```
	RequirementModelsAndLogging
	```

	An example of the visualisation of the output is given in the main file `Run_OneSimulation.m` at the bottom.
	There the continuous power throughout the cycle is plotted, and a visual of the flight path is plotted in a 3D environment with colour coding the power production. 
	
	Also an example is provided on how to visualise the converged power pumping cycle as an animation.

4. Required libraries are found in the `Lib` folder and the source code can be found in the `Src` folder which are divided up between code required for 3DoF, 6DoF or both simulations. Rapp [[5]](#References) gives a more detailed explanation of the controller strategy and reference frames used throughout this framework.

## Documentation

A detailed documentation of the simulation framework can be accessed on [readthedocs](https://megawes.readthedocs.io/en/latest/).

## Built With

* [Matlab](https://www.mathworks.com/products/matlab) - The program language used
* [Simulink](https://www.mathworks.com/products/simulink) - The GUI used for model-based design through block diagrams

<!--## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.-->

## Versioning

For the versions available, see the [tags on this repository](https://github.com/awegroup/MegAWES/tags). 

## Authors

* **Dylan Eijkelhof** - *Initial work current system design, multi-MW aircraft* - [GitHub](https://github.com/DylanEij)
* **Urban Fasel** - *Initial framework set-up* 
* **Sebastian Rapp** - *Flight controller design* - [GitHub](https://github.com/sebrap)

See also the list of [contributors](https://github.com/awegroup/MegAWES/graphs/contributors) who participated in this project.

## License

This project is licensed under the Apache License - see the [LICENSE](LICENSE.md) file for details

## References
[1] D. Eijkelhof, R. Schmehl: Six-degrees-of-freedom simulation model for future multi-megawatt airborne wind energy systems. Renewable Energy, Vol. 196, pp. 137-150, 2022. [doi:10.1016/j.renene.2022.06.094](https://doi.org/10.1016/j.renene.2022.06.094)

[2] D. Eijkelhof: Design and Optimisation Framework of a Multi-MW Airborne Wind Energy Reference System. MSc Thesis Delft University of Technoly and Technical University of Denmark, 2019. [uuid:e759f9ad-ab67-43b3-97e0-75558ecf222d](http://resolver.tudelft.nl/uuid:e759f9ad-ab67-43b3-97e0-75558ecf222d)

[3] D. Eijkelhof, S. Rapp, U. Fasel, M. Gaunaa, R. Schmehl: Reference Design and Simulation Framework of a Multi-Megawatt Airborne Wind Energy System. Journal of Physics: Conference Series, Vol. 1618, No. 3, 2020. [doi:10.1088/1742-6596/1618/3/032020](https://doi.org/10.1088/1742-6596/1618/3/032020)

[4] U. Fechner, R. van der Vlugt, E. Schreuder, R. Schmehl: Dynamic model of a pumping kite power system. Renewable Energy, Vol. 83, pp. 705-716, 2015. [doi:10.1016/j.renene.2015.04.028](http://doi.org/10.1016/j.renene.2015.04.028)

[5] S. Rapp: Robust Automatic Pumping Cycle Operation of Airborne Wind Energy Systems. PhD Thesis, Delft University of Technology, 2021. [doi:10.4233/uuid:ab2adf33-ef5d-413c-b403-2cfb4f9b6bae](https://doi.org/10.4233/uuid:ab2adf33-ef5d-413c-b403-2cfb4f9b6bae)

## Acknowledgments

* Outstanding guidance of Roland Schmehl (TU Delft) and Mac Gaunaa (DTU wind energy).
* This project is financially supported by the Unmanned Valley Valkenburg project of the European Regional Development Fund.
* A special thank you to the following people whos work helped with the design of the DE2019 aircraft:
	* Dominic Keidel
	* Cla Mattia Galliard
	* Lorenz Affentranger
	* Gian Joerimann
	* Michael Imobersteg
