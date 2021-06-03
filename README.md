# Determinant-based-Fast-Greedy-Sensor-Selection-Algorithms-with-Correlated-Measurement-noise
This repository contains Matlab (R2020b) code to reproduce results for the Determinant-based Fast Greedy Sensor Selection Algorithm.


Due to GitHub file size limitations, a dataset is linked online:[NOAA Optimum Interpolation (OI) Sea Surface Temperature (SST) V2](https://www.esrl.noaa.gov/psd/data/gridded/data.noaa.oisst.v2.html)
- sst.wkmean.1990-present.nc
- lsmask.nc


**Ocean sea surface temperature data is provided by NOAA.
NOAA_OI_SST_V2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their Web site at https://www.esrl.noaa.gov/psd/.**

## License
[MIT-License](https://github.com/YujiSaitoJapan/Determinant-based-Fast-Greedy-Sensor-Selection-Algorithm/blob/add-license-1/LICENSE)

## Code  
---
### Main program  
- P_greedy_noise_demo.m  

### Function  
#### Preprocessing  
- F_pre_read_NOAA_SST.m  
- F_pre_SVD_NOAA_SST.m  
- F_pre_truncatedSVD.m  

#### Sensor selection  
- F_sensor_random.m
- F_sensor_DG.m  
  - F_sensor_DG_r.m  
  - F_sensor_DG_p.m
- F_sensor_DGCN.m  
  - F_sensor_DGCN_r.m  
  - F_sensor_DGCN_p.m
- F_sensor_BDG.m  

#### Calculation
- F_calc_det.m  
- F_calc_sensormatrix.  
- F_calc_error.m  
  - F_calc_reconst.m  
  - F_calc_reconst_error.m  

#### Data organization  
- F_data_ave1.m  
- F_data_ave2.m  
- F_data_ave3.m  
- F_data_arrange.m
- F_data_normalize.m  

#### Mapping
- F_map_original.m  
	- F_map_videowriter.m  
		- F_map_plot_sensors_forvideo.m  
- F_map_reconst.m  
	- F_map_plot_sensors.m  
- F_fig_SST_sensors_color_compare.m  
      
## How to cite
If you use the codes in your work, please cite the software itself and relevent paper.
### General software reference:
```bibtex
@misc{yamada2021github,
      author = {Keigo Yamada},
      title = {Determinant-based Fast Greedy Sensor Selection Algorithm with Correlated Measurement Noise},
      howpublished = {Available online},
      year = {2021},
      url = {https://github.com/Aerodynamics-Lab/Determinant-based-Fast-Greedy-Sensor-Selection-Algorithm-with-Correlated-Measurement-noise}
}
```
### Relevent paper reference:
```bibtex
@ARTICLE{yamada2021fast,
  author = {Keigo Yamada and Yuji Saito and Koki Nankai and Taku Nonomura and
	Keisuke Asai and Daisuke Tsubakino},
  title = {Fast greedy optimization of sensor selection in measurement with
	correlated noise},
  journal = {Mechanical Systems and Signal Processing},
  year = {2021},
  volume = {158},
  pages = {107619},
  abstract = {A greedy algorithm is proposed for sparse-sensor selection in reduced-order
	sensing that contains correlated noise in measurement. The sensor
	selection is carried out by maximizing the determinant of the Fisher
	information matrix in a Bayesian estimation operator. The Bayesian
	estimation with a covariance matrix of the measurement noise and
	a prior probability distribution of estimating parameters, which
	are given by the modal decomposition of high dimensional data, robustly
	works even in the presence of the correlated noise. After computational
	efficiency of the algorithm is improved by a low-rank approximation
	of the noise covariance matrix, the proposed algorithms are applied
	to various problems. The proposed method yields more accurate reconstruction
	than the previously presented method with the determinant-based greedy
	algorithm, with reasonable increase in computational time.},
  doi = {https://doi.org/10.1016/j.ymssp.2021.107619},
  issn = {0888-3270},
  keywords = {Data processing, Sensor placement optimization, Greedy algorithm,
	Bayesian state estimation},
  url = {https://www.sciencedirect.com/science/article/pii/S0888327021000145}
}

```
## Author
YAMADA Keigo

[Experimental Aerodynamics Laboratory](http://www.aero.mech.tohoku.ac.jp/en/)
Department of Aerospace Engineering
Graduate School of Engineering

Tohoku University, Sendai, JAPAN

E-mail: keigo.yamada.t5@dc.tohoku.ac.jp

Github: [k5-Yamada](https://github.com/k5-Yamada)
