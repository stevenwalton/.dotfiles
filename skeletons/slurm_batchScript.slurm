#!/usr/bin/env bash
# ^ /usr/bin/env means use user's environment
# /bin/bash uses systems bash which will not load your bashrc
################################################################################
# Authors: Steven Walton (slurm@walton.mozmail.com) 
#				 Ali Hassani
# Example sbatch script written by Steven Walton and Ali Hassani
# To use:
#   SBATCH variables:
#       (job-name): Set YOUR_JOB_NAME to something descriptive (will display in squeue)
#       (nodes): Set HOW_MANY_NODES to the number nodes you will use
#       (mail-*): uncomment and place your email here if you want emails when 
#       the job finishes
#   Loading Modules and environments:
#       We provide an example of how to load modules (see `module avail`) and a
#       local environment like conda
#   Torchrun:
#       distributed launch is deprecated, use torchrun instead. You don't need
#       to change anything here except the filename and any arguments 
#
# Use `sbatch my_file.slurm` to run a job instead of `srun main.py`. 
# srun is ONLY for running interactive jobs: e.g. create an interactive session
# so you can install torch with cuda (can't do from head node because no GPUs)
# All other jobs should be submitted through the queue (i.e. sbatch)
################################################################################

##### SLURM VARIABLES #####
# Anything starting with SBATCH has a "#" but "##" is commented (like #!/bin/bash)
#SBATCH --job-name=YOUR_JOB_NAME
#SBATCH --nodes=HOW_MANY_NODES
#SBATCH --ntasks-per-node=1       # Max: (max_cpus_per_node - 1) / n_GPUs_per_node )
#SBATCH --cpus-per-task=4         # 128 CPUs per node (don't use max!)
#SBATCH --mem=512G                # 972.8 GB/node max
#SBATCH --gres=gpu:8              # Max 8
#SBATCH --time=250:00:00          # 5 days
# Uncomment to get mail about job status
##SBATCH --mail-type=begin        # send email when job begins
##SBATCH --mail-type=end          # send email when job ends
##SBATCH --mail-user=YOUR_EMAIL
###########################

# Get info about nodes (run outside this script)
#.    will show GPU type and group by partition
# sinfo -o "%20N  %10c  %10m  %25f  %10G "

# Getting the master address (only necessary for multi-node jobs)
MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_ADDR=$MASTER_ADDR
echo "MASTER_ADDR="$MASTER_ADDR

######################################################
##### Can be in your bashrc (uncomment if needed) ####
## Load any modules you need (see `module avail`)
#module load cuda11.7

## Load relevant environments if necessary
#export PATH="~/.anaconda3/bin:$PATH"
#eval "$(conda shell.bash hook)"
# If you're using conda
#conda activate myCondaEnv
# If you're using virtual environments
#source venv/bin/activate

# If needing distributed debugging
# export NCCL_P2P_LEVEL=NVL
# export NCCL_DEBUG=INFO
######################################################

# Using torchrun (python -m torch.distributed.launch is deprecated)
# Torchrun is much more fault tolerant 
srun torchrun \
     --rdzv_id=$SLURM_JOB_ID \
     --rdzv_backend=c10d \
     --rdzv_endpoint=$MASTER_ADDR \
     --nnodes=$SLURM_JOB_NUM_NODES \
     --nproc_per_node=$SLURM_GPUS_ON_NODE \
     main.py 

# If you really need a fault tolerant code AND you have properly implemented
# snapshots then you may want to consider adding `--max-restarts=$MAX_RESTARTS`
# to your torchrun job
# Make sure you really understand
# https://pytorch.org/docs/stable/elastic.run.html
# before using this
