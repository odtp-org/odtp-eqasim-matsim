# ODTP Eqasim Matsim Component

ODTP component for running Eqasim Matsim Pipeline.

| Tool Info | Links |
| --- | --- |
| Original Tool (IDF & Corisca)| [https://github.com/eqasim-org/ile-de-france](https://github.com/eqasim-org/ile-de-france) |
| Current Tool Version (IDF & Corisca) | [fb1112d2a7d1817746be84413da584c391059ad1](https://github.com/eqasim-org/ile-de-france/commit/fb1112d2a7d1817746be84413da584c391059ad1) |
| Original Tool (IDF & Corisca)| [https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop](https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop) |
| Current Tool Version (IDF & Corisca) | [4658daa2e441dcda132622e7fcb47da1df8c47d6](https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop/-/commit/4658daa2e441dcda132622e7fcb47da1df8c47d6) |


## ODTP command 

```odtp new component 
odtp new odtp-eqasim-matsim\
--name odtp-eqasim-matsim \
--component-version 0.1.0 \
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
java_memory=8GB
```

For IDF
```
SCENARIO=IDF
processes=8
sampling_rate=0.001
random_seed=1234
java_memory=24G
hts=entd
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
output_id=test
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
--name odtp-eqasim odtp-eqasim
```

Now you can push Control + B, and then D to dettach from the tmux session. In order to come back to the session you can do: 

```
tmux attach-session -t odtp-test
```
If you want to kill the session just write `exit`. Also use `tmux ls` to list all available tmux sessions.


## Changelog

- v.0.1.0: Version compatible with Corisca, Ile de France, and Swiss scenarios.  

## Development. 

Developed by SDSC/CSFM.

