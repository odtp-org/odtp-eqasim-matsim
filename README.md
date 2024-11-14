# ODTP Eqasim Matsim Component

ODTP component for running Eqasim Matsim Pipeline.

| Tool Info | Links |
| --- | --- |
| Original Tool (IDF & Corsica)| [https://github.com/eqasim-org/ile-de-france](https://github.com/eqasim-org/ile-de-france) |
| Current Tool Version (IDF & Corsica) | [3c9b137b9e4b3c17e163cae2e170f18611adcf56](https://github.com/eqasim-org/ile-de-france/commit/3c9b137b9e4b3c17e163cae2e170f18611adcf56) |
| Original Tool (CH Scenario)| [https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop](https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop) |
| Current Tool Version (CH Scenario) | [4658daa2e441dcda132622e7fcb47da1df8c47d6](https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop/-/commit/4658daa2e441dcda132622e7fcb47da1df8c47d6) |


## ODTP command 

```odtp new component 
odtp new odtp-component-entry \
--name odtp-eqasim-matsim \
--component-version v0.1.6 \
--repository https://github.com/odtp-org/odtp-eqasim-matsim
``` 

## Tutorial

### Prepare dataset

1. IDF
    - Download the switchdrive zip file provided. 

2. CH
    - Download the data provided by Milos. Copy and paste all folders located in `hafas/2018` in `hafas`. 

3. Corsica
    - Download the switchdrive zip file provided. 

### How to run this component in docker. 

1. Prepare manually a folder called `odtp-input` containing the following datafolders of our selected scenario. 

- `data`: Original eqasim input.
- `cache`: Eqasim cache folder.
- `eqasim-output`: Eqasim output

2. Create your `.env` file based on the following examples.

Add the selected scenario `CORSICA`, `IDF`, or `CH`. 

For Corsica:
```
SCENARIO=CORSICA
processes=4
hts=entd
sampling_rate=0.001
random_seed=1234
java_memory=8G
output_id=output
```

For IDF
```
SCENARIO=IDF
processes=8
sampling_rate=0.001
random_seed=1234
java_memory=24G
hts=entd
output_id=output
```

For CH
```
SCENARIO=CH
threads=4
random_seed=0
hot_deck_matching_runnners=2
java_memory=100G
input_downsampling=0.01
enable_scaling=true
scaling_year=2020
use_freight=true
hafas_date=01.10.2018
output_id=output
```

3. Build the dockerfile 

```
docker build -t odtp-eqasim-matsim .
```

4. Run the following command. Mount the correct volumes for input/output folders. 

```
docker run -it --rm \
-v {PATH_TO_YOUR_INPUT_VOLUME}:/odtp/odtp-input \
-v {PATH_TO_YOUR_OUTPUT_VOLUME}:/odtp/odtp-output \
--env-file .env odtp-eqasim-matsim
```


### Example of `tmux` session

In order to run this container in a remote server and detach from the task you can use `tmux`. In this example you will run the isolated container with the CORSICA scenario.

```
tmux new -s odtp-test
docker run -it --rm \
-v {PATH_TO_YOUR_INPUT_VOLUME}:/odtp/odtp-input \
-v {PATH_TO_YOUR_INPUT_VOLUME}:/odtp/odtp-output \ 
-e SCENARIO=CORSICA \
-e processes=4 \
-e hts=entd \
-e sampling_rate=0.001 \
-e random_seed=1234 \
-e java_memory=8GB \
--name odtp-matsim-eqasim odtp-matsim-eqasim
```

Now you can push Control + B, and then D to dettach from the tmux session. In order to come back to the session you can do: 

```
tmux attach-session -t odtp-test
```
If you want to kill the session just write `exit`. Also use `tmux ls` to list all available tmux sessions.


## Changelog

- v0.1.6
    - Simplified Dockerfile and compatibility with Windows building
    - Github actions
    - Fixed rasterio and fiona versions

- v0.1.5

- v0.1.4

- v0.1.3:
    - Ubuntu fixed at 22.04
    - Python fixed at 3.10

- v0.1.2: 
    - Corrected bug related to installation of dependencies for `odtp-component-client`
    - Corrected typo in `odtp.yml`
    - Added java simulation command to templates to trigger `matsim`
    - Added `output_id` as a parameter
    - Updating `odtp-component-client`

- v0.1.1: Updated `odtp.yml` to version v0.3.4 (https://github.com/odtp-org/odtp-component-template/commit/c4732294bb57bd5dfdc9630f4676f69462a3c07e)
- v0.1.0: Version compatible with Corisca, Ile de France, and Swiss scenarios.  

## Development. 

Developed by SDSC/CSFM.

