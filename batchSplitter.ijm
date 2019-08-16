fList = getArgument(); // Find the image to split
print(fList); //print the image name to the console
run("Bio-Formats Macro Extensions"); //make sure Bioformats is running
setBatchMode(true); //batch mode must be on, or the lack of a GUI will be an issue!
Ext.openImagePlus(fList); //open theimage
name = fList; //make a variable to store the whole name
//print(name);
nyem = split(name, "/"); //turn name into an array of 2 values, the first being "job_input"
nyem = nyem[1]; //take the second value in the array
nyem = substring(nyem,0,lengthOf(nyem)-4); //remove .tif from the end
name = fList;
nom = substring(name,0,lengthOf(name)-4); //make another variable that is essentially "job_input/imageName"
File.makeDirectory(nom); //make a directory with this name

getDimensions(width, height, channels, slices, frames);
colours = channels;
for (channel=1;channel<=colours;channel++){ //for each channel
        getDimensions(width, height, channels, slices, frames);
        for (time = 1;time<=frames;time++){ //for each timepoint
                selectWindow(nyem+".nd2"); //select the image window
                run("Duplicate...", "duplicate channels="+channel+" frames="+time); //duplicate the channel and timepoint
                if (time<10){ //we need to have the same number of characters to describe each timepoint
saveAs("Tiff", nom+"/"+nyem+"_c"+channel+"_t0"+time+".tif"); //save it
                } else{
saveAs("Tiff", nom+"/"+nyem+"_c"+channel+"_t"+time+".tif"); //save it
                }
                close();
        }
}

eval("Script","System.exit(0);"); //when the script is run, close imageJ.

