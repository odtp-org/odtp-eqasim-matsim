#!/bin/bash
if [ "$SCENARIO" == "IDF" ]; then
    echo "IDF SCENARIO."
    
    # Cloning Scenario
    git clone https://github.com/eqasim-org/ile-de-france.git /odtp/odtp-workdir/scenario
    cd /odtp/odtp-workdir/scenario
    git checkout 3c9b137b9e4b3c17e163cae2e170f18611adcf56

    # Preparing parameters & config file
    # Reading placeholders and create config file from environment variables 
    echo "Running Matsim PIPELINE"
    python3 /odtp/odtp-client/parameters.py /odtp/odtp-app/config_templates/config_matsim_idf.yml /odtp/odtp-workdir/scenario/config.yml

    # Preparing input data folder
    ln -s /odtp/odtp-input/data /odtp/odtp-workdir/data

    # We need to copy output files from previous step in output folder
    cp -r /odtp/odtp-input/eqasim-output/* /odtp/odtp-workdir/output
    

elif [ "$SCENARIO" == "CORSICA" ]; then
    echo "CORSICA SCENARIO."
    
    # Cloning Scenario
    git clone https://github.com/eqasim-org/ile-de-france.git /odtp/odtp-workdir/scenario
    cd /odtp/odtp-workdir/scenario
    git checkout 3c9b137b9e4b3c17e163cae2e170f18611adcf56

    # Preparing parameters & config file
    # Reading placeholders and create config file from environment variables
    echo "Running Matsim PIPELINE"
    python3 /odtp/odtp-component-client/parameters.py /odtp/odtp-app/config_templates/config_matsim_corsica.yml /odtp/odtp-workdir/scenario/config.yml

    # Preparing input data folder
    ln -s /odtp/odtp-input/data /odtp/odtp-workdir/data

    # We need to copy output files from previous step in output folder
    cp -r /odtp/odtp-input/eqasim-output/* /odtp/odtp-workdir/output

    # Cache files are needed
    cp -r /odtp/odtp-input/cache/* /odtp/odtp-workdir/cache


else
    echo "CH SCENARIO."

    # Cloning Scenario
    git clone https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop /odtp/odtp-workdir/scenario
    cd /odtp/odtp-workdir/scenario
    git switch develop
    git checkout 4658daa2e441dcda132622e7fcb47da1df8c47d6
    
    # Preparing parameters & config file
    # Reading placeholders and create config file from environment variables
    echo "Running Matsim PIPELINE"
    python3 /odtp/odtp-client/parameters.py /odtp/odtp-app/config_templates/config_matsim_ch.yml /odtp/odtp-workdir/scenario/config.yml

    # Preparing input data folder
    ln -s /odtp/odtp-input/data /odtp/odtp-workdir/data

    # We need to copy output files from previous step in output folder
    cp -r /odtp/odtp-input/eqasim-output/* /odtp/odtp-workdir/output

fi

# Running Eqasim pipeline
python3 -m synpp

if [ "$SCENARIO" == "IDF" ] || [ "$SCENARIO" == "CORSICA" ]; then
    cd /odtp/odtp-workdir/output
    java -Xmx$java_memory -cp ${output_id}run.jar org.eqasim.ile_de_france.RunSimulation --config-path ${output_id}config.xml
fi

# In some cases it fails the first time the command is executed it appears a maven related issue 
# However another run seems to fix this
# Could not transfer artifact org.geotools:gt-opengis:jar:24.2 from/to osgeo
# sleep 10
# python3 -m synpp


# Copying output in odtp-output
mkdir /odtp/odtp-output/eqasim-matsim-output
cp -r /odtp/odtp-workdir/output/* /odtp/odtp-output/eqasim-matsim-output