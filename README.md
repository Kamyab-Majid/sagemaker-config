# sagemaker-config
this sagemaker config gives you a custom python environment and a auto-stop


to do this first start your jupyter instance and then run the on-create script, install the custom python script in the section that is installing it. https://github.com/aws-samples/amazon-sagemaker-notebook-instance-lifecycle-config-samples/blob/master/scripts/persistent-conda-ebs/on-create.sh then add this to on-start of your life cycle config and add the on-start lifecycle config to your notebook instance
