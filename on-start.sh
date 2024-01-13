
#!/bin/bash
set -e

# 

# PARAMETERS
IDLE_TIME=3600

echo "Fetching the autostop script"
wget https://raw.githubusercontent.com/aws-samples/amazon-sagemaker-notebook-instance-lifecycle-config-samples/master/scripts/auto-stop-idle/autostop.py 


echo "Detecting Python install with boto3 install"

# Find which install has boto3 and use that to run the cron command. So will use default when available
# Redirect stderr as it is unneeded
CONDA_PYTHON_DIR=$(source /home/ec2-user/anaconda3/bin/activate /home/ec2-user/anaconda3/envs/JupyterSystemEnv && which python)
PYTHON_DIR='/usr/bin/python'

echo "Found boto3 at $PYTHON_DIR"


echo "Starting the SageMaker autostop script in cron"

(crontab -l 2>/dev/null; echo "*/5 * * * * $PYTHON_DIR $PWD/autostop.py --time $IDLE_TIME --ignore-connections >> /var/log/jupyter.log") | crontab -

# 

sudo -u ec2-user -i <<'EOF'
unset SUDO_UID
WORKING_DIR=/home/ec2-user/SageMaker/custom-miniconda/
source "$WORKING_DIR/miniconda/bin/activate"

for env in $WORKING_DIR/miniconda/envs/*; do

BASENAME=$(basename "$env")
source activate "$BASENAME"

python -m ipykernel install --user --name "$BASENAME" --display-name "Custom ($BASENAME)"
done
# Optionally, uncomment these lines to disable SageMaker-provided Conda functionality.

# echo "c.EnvironmentKernelSpecManager.use_conda_directly = False" >> /home/ec2-user/.jupyter/jupyter_notebook_config.py

# rm /home/ec2-user/.condarc
EOF
echo "Restarting the Jupyter server.."
systemctl restart jupyter-server