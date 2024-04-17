# Define variables
export SCENARIO=CORSICA
export processes=4
export hts=entd
export sampling_rate=0.001
export random_seed=1234
export java_memory=8G

# Download data from switch
wget $1/download
mv download download.zip
unzip download.zip -d /odtp/odtp-input

# Run odtp
cd /odtp/odtp-workdir
bash /odtp/odtp-app/app.sh