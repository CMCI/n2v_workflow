for folder in job_input/*
do 
    echo $folder
    xvfb-run ImageJ --ij2 --headless --console -macro batchSplitter.ijm "$folder"
done 

#If the workflow is running smoothly for you, you can uncomment line 8; this will save you some disk space
#xvfb-run ImageJ --ij2 --headless --console -macro batchSplitter.ijm 'job_input/'

#rm job_input/*.nd2
for folder in job_input/*
do
if [[ -d "$folder" ]]
then
    echo $folder
    python n2v_run.py $folder
fi
done

for folder in job_output/*
do
if [[ -d "$folder" ]]
then
    xvfb-run ImageJ --ij2 --headless --console -macro stackCombiner.ijm "$folder"
fi
done
