for folder in job_input/*
do 
    echo $folder
    xvfb-run ImageJ --ij2 --headless --console -macro batchSplitter_3.ijm "$folder"
done 

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
