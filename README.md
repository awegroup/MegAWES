# MegAWES V3

[![Version](https://img.shields.io/github/v/release/awegroup/MegAWES?label=Latest%20release)](https://github.com/awegroup/MegAWES/releases)
[![Matlab19B](https://img.shields.io/static/v1?label=Matlab%20Simulink&message=2019B&color=brightgreen)](https://www.mathworks.com/products/simulink) <!--static-->
[![License](https://img.shields.io/github/license/awegroup/MegAWES?label=License)](http://www.apache.org/licenses/)
[![docs](https://readthedocs.org/projects/pip/badge/)](https://readthedocs.org/projects/megawes)

MegAWES is a Matlab&reg;/Simulink&reg; model of an airborne wind energy (AWE) system based on a tethered fixed-wing that is operated in pumping cycles producing multiple megawatts of electricity. The framework is a further development of Dylan Eijkelhof's graduation project, which was jointly supervised by TU Delft, ETH Zurich, and DTU [[1,2]](references). The ultimate purpose is to provide several reference models of (sub)megawatt-AWE systems and a computational framework to dynamically simulate its operation. The Simulink framework includes the following model components:

* Pre-calculated look-up tables for aircraft's aerodynamic behaviour.
* Segmented tether with a single attachment point at the kite's centre of gravity.
* Choice between 3DoF point-mass (**Version 2**) and 6DoF rigid-body dynamic solver (**Version 2, 3**).
* Modified L0 Aircraft controller for power generation flight controls and path tracking (**Version 3**).
* Non-linear dynamic inversion controller (based on [[6]](#References)) (**Version 2**).
* Different flight patterns possible (**Version 3**): circle, figure-of-eight up-loop and down-loops.
* Optimal (quasi-steady) tether force controlled dynamic winch for traction phase (based on [[3]](#references)) (**Version 3**).
* Set-force controlled dynamic winch for retraction phase (based on [[4]](#references)) (**Version 2, 3**).
* Optimisation strategy (CMA-ES) for cycle power optimisation or controller tuning when implementing a different kite design (**Version 3**).

![](Lib/DE2019_Aircraft.jpeg)

## ⚙️Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

What things you need to run the software and how to install them.

1. Install Matlab/Simulink R2024a (earlier versions might work but not tested) and some extra packages (for instructions how te get matlab, click [here](https://www.mathworks.com/products/get-matlab.html)):
   
   ```matlab
   Matlab
   Simulink
   Aerospace Blockset
   Stateflow
   DSP System Toolbox
   Optimization Toolbox
   ```

2. Install **Git** and **Git-lfs** (for instructions on how to get git and git-lfs, click [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for git and [here](https://docs.github.com/en/github/managing-large-files/installing-git-large-file-storage) for git-lfs). Without git-lfs the libraries might not clone properly (note: other methods might also work).

3. After installation of **git-lfs** run the following command in a terminal (Unix, MacOS)/command window (Windows):
   
   ```bash
   git lfs install
   ```

### Installing

1. Do not forget to check if the [previously mentioned software](#prerequisites) is installed.

2. Get a copy of the latest `MegAWES` environment release:
   
   ```bash
   git clone https://github.com/awegroup/MegAWES.git
   ```

## 💪Deployment

A step by step series of examples that tell you how to get a development env running, tested on macOS 15.3.2

1. The following file allows you to run a full simulation until power cycle convergence of the current aircraft.
   
   ```matlab
   runMain.m
   ```
   
   The input parameters are set in Lib/[pattern]_simInput.yaml, the pattern here links to the demo files showing how to set-up the specific pattern in the pathparam (struct) variable.

2. All input variables are set in:
   
   ```bash
   Lib/[pattern]_simInput.yaml
   ```
   
    where the kite specific variable are set in:
   
   ```bash
   Lib/MegAWESkite.yaml
   ```
   
    Following parameters are set:
   
   1. **ENVMT**: Environment parameters, steady max windspeed (no turbulence is included at this stage).
   2. **simInit**: Simulation initialisation parameters.
   3. **actuatorLimit**: Actuator constraints.
   4. **tetherParams**: Tether characteristics.
   5. **winchParameter**: Winch characteristics.
   6. **pathparam**: Flight path shape.
   7. **controllerGains_traction**: Controller gains (traction).
   8. **controllerGains_retraction**: Controller gains (retraction).

3. In the simulink model, the output parameters are defined in the root of the simulink model on the right side.
   
   An example of the visualisation of the output is given in `demoPlot.m`.
   There the continuous power throughout the cycle is plotted, and a visual of the flight path is plotted in a 3D environment with colour coding the power production.

4. Required libraries are found in the `Lib` folder and the source code can be found in the `Src` folder. Eijkelhof [[5]](#references) gives a more detailed explanation of the controller strategy and reference frames used throughout this framework.

5. Additional, non-required, kite details can be found in the `Lib/additional_kiteData` folder.

## 💎Documentation

A detailed documentation of the simulation framework can be accessed on [github pages]().

## 📐Built With

* [Matlab®](https://www.mathworks.com/products/matlab) - The program language
* [Simulink®](https://www.mathworks.com/products/simulink) - The GUI used for model-based simulation design through block diagrams

<!--## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.-->

## 📌Versioning

For the versions available, see the [tags on this repository](https://github.com/awegroup/MegAWES/tags).

## ✏️Authors

* **Dylan Eijkelhof** - *Initial work current system design, multi-MW aircraft*, core developer  - [GitHub](https://github.com/DylanEij)
* **Urban Fasel** - *Initial framework set-up*
* **Nicola Rossi** - *Updated flight controller implementation*
* **Jesse Hummel** - *Winch design* - [GitHub](https://github.com/jesseishi)

See also the list of [contributors](https://github.com/awegroup/MegAWES/graphs/contributors) who participated in this project.

## 👋Contributing (optional)

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests where appropriate.

## ⚠️License and Waiver

This project is licensed under the Apache License - see the LICENSE file for details

> Technische Universiteit Delft hereby disclaims all copyright interest in the program “MegAWES (a fixed-wing power computation model) written by the Author(s).
> 
> Prof.dr. H.G.C. (Henri) Werij, Dean of Aerospace Engineering
> 
> Copyright (c) 2025 Dylan Eijkelhof

## 📚References

[1] D. Eijkelhof: Design and Optimisation Framework of a Multi-MW Airborne Wind Energy Reference System. MSc Thesis Delft University of Technoly and Technical University of Denmark, 2019. [uuid:e759f9ad-ab67-43b3-97e0-75558ecf222d](http://resolver.tudelft.nl/uuid:e759f9ad-ab67-43b3-97e0-75558ecf222d)

[2] D. Eijkelhof, S. Rapp, U. Fasel, M. Gaunaa, R. Schmehl: Reference Design and Simulation Framework of a Multi-Megawatt Airborne Wind Energy System. Journal of Physics: Conference Series, Vol. 1618, No. 3, 2020. [doi:10.1088/1742-6596/1618/3/032020](https://doi.org/10.1088/1742-6596/1618/3/032020)

[3] J. Hummel, T. Pollack, D. Eijkelhof, E. -J. van Kampen and R. Schmehl, "Winch Sizing for Ground-Generation Airborne Wind Energy Systems," *2024 European Control Conference (ECC)*, Stockholm, Sweden, 2024, pp. 675-680, doi: [10.23919/ECC64448.2024.10590780](https://doi.org/10.23919/ECC64448.2024.10590780).

[4] U. Fechner, R. van der Vlugt, E. Schreuder, R. Schmehl: Dynamic model of a pumping kite power system. Renewable Energy, Vol. 83, pp. 705-716, 2015. [doi:10.1016/j.renene.2015.04.028](http://doi.org/10.1016/j.renene.2015.04.028)

[5] D. Eijkelhof, N. Rossi, and R. Schmehl: Optimal Flight Pattern Debate for Airborne Wind Energy Systems: Circular or Figure-of-eight?, Wind Energ. Sci. Discuss. [preprint], in review, 2024. [doi:10.5194/wes-2024-139](https://doi.org/10.5194/wes-2024-139).

[6] S. Rapp: Robust Automatic Pumping Cycle Operation of Airborne Wind Energy Systems. PhD Thesis, Delft University of Technology, 2021. [doi:10.4233/uuid:ab2adf33-ef5d-413c-b403-2cfb4f9b6bae](https://doi.org/10.4233/uuid:ab2adf33-ef5d-413c-b403-2cfb4f9b6bae)

## 👀Acknowledgments

* Outstanding guidance of Roland Schmehl (TU Delft) and Mac Gaunaa (DTU wind energy).
* This project is partially financially supported by the Unmanned Valley Valkenburg project of the European Regional Development Fund.
* This project is partially financially supported by Dutch Research Council NWO (project NEON: New Energy and Mobility Outlook for the Netherlands under grant number 17628).
* The project was supported by the Digital Competence Centre, Delft University of Technology.
* A special thank you to the following people whos work helped with the design of the fixed-wing monoplane kite:
  * Dominic Keidel
  * Cla Mattia Galliard
  * Lorenz Affentranger
  * Gian Joerimann
  * Michael Imobersteg
