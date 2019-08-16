for folder in job_input/*
do 
    echo $folder
    python n2v_run.py $folder
done 
