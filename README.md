# MEASRR
**M**ulti-**E**lectrode **A**nalysis of **S**low-waves: **R**ecomposition and **R**ecurrence

## Research Publication and Citation
Please cite the following paper if you use this software and/or modify this software: 

_PLACEHOLDER: Athavale O.N., Paskaranandavadivel N., Cheng L.K., & Du P. (submitted)_

## Background
Periodic spatiotemporal activity patterns are observed in recordings of gastrointestinal electrophysiology, and in the electrophysiology of other organs. Sinusoidal recomposition methods were introduced by Kuklik et al.<sup>1</sup>. Zeemering et al.<sup>2</sup> used phase signals from marked atrial electrograms to compute reccurrence plots and cluster activity types. Athavale et al.<sup>3</sup> used sinusoidal recomposition in conjunction with recurrence plots to perform markerless analysis of gastric slow wave patterns during cervical vagus nerve stimulation. This software was written to perform the computations in Athavale et al.<sup>3</sup>.

## Usage
1) Clone or download and extract the MEASRR repository.
2) In the MATLAB console window enter ```addpath(genpath('path/to/MEASRR'))```

Developed for MATLAB 2020b.

## Features

**Recomposition**
- Recompose sinusoidal wavelets
- Gastric slow wave recomposition weighting function

**Recurrence**
- Multi-electrode phase signal embedding
- Recurrence plot computation
  
**Synthetic multi-electrode signal generation**
- Radial wavefront
- Linear wavefront
- Colliding wavefronts
- Phase signal to event markers (GEMS<sup>4</sup> format)

**Quantification**
- Recurrence quantification metrics
- Windowed recurrence quantification metrics
- Rolling window recurrence quantification metrics

## References
<sup>1</sup> Kuklik P, Zeemering S, Maesen B, Maessen J, Crijns HJ, Verheule S, Ganesan AN, Schotten U. Reconstruction of instantaneous phase of unipolar atrial contact electrogram using a concept of sinusoidal recomposition and hilbert transform. (2015) IEEE Trans Biomed Eng 62: 296–302. doi: 10.1109/TBME.2014.2350029.

<sup>2</sup> Zeemering S, van Hunnik A, van Rosmalen F, Bonizzi P, Scaf B, Delhaas T, Verheule S, Schotten U. A Novel Tool for the Identification and Characterization of Repetitive Patterns in High-Density Contact Mapping of Atrial Fibrillation. (2020) Front Physiol 11: 1–12. doi: 10.3389/fphys.2020.570118.

<sup>3</sup> _PLACEHOLDER: Athavale O.N., Paskaranandavadivel N., Cheng L.K., & Du P. (submitted)_

<sup>4</sup> Yassi R., O’Grady G., Paskaranandavadivel N., Du P., Angeli T.R., Pullan A.J., Cheng L.K., Erickson J.C. (2012) The gastrointestinal electrical mapping suite (GEMS): Software for analyzing and visualizing high-resolution (multi-electrode) recordings in spatiotemporal detail. BMC Gastroenterol 12: 1–14. doi: 10.1186/1471-230X-12-60.

## License and disclaimer
This repository is licensed under the GPL v3.0 license. See the LICENSE document for details. 

Copyright (C) 2025 Omkar Athavale

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see https://www.gnu.org/licenses/.
