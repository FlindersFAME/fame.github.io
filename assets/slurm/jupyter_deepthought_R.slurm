#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=40GB
#SBATCH --time=1-0:00:00
#SBATCH --job-name=R-jupyter
#SBATCH --output=jupyter/R-jupyter-notebook-%J.log

# Slurm script to launch a jupyter notebook. See the fame blog for details on setting this up!

# get tunneling info
XDG_RUNTIME_DIR=""
port=$(shuf -i8000-9999 -n1)
node=$(hostname -s)
user=$(whoami)
cluster=$(hostname -f | awk -F"." '{print $2}')

# print tunneling instructions jupyter-log
echo -e "

Windows MobaXterm info
Forwarded port: 8100
Remote server: ${node}
Remote port: ${port}
SSH server: deepthought.flinders.edu.au
SSH login: $user
SSH port: 22

Use a Browser on your local machine to go to:
localhost:${port}  (prefix w/ https:// if using password)

If ypu have a command line, you can also use this version

ssh ${user}@deepthought.flinders.edu.au -p 22 -L 8100:${node}:${port}

and then open chrome and go to

https://localhost:8100

"

# load conda environments
eval "$(conda shell.bash hook)"
conda activate R_notebook_env

jupyter lab --port=${port} --ip=${node} --no-browser
