fList = getArgument(); // Find the folder of images to analyse
print(fList);
run("Bio-Formats Macro Extensions");
setBatchMode(true);
Ext.openImagePlus(fList);
name = fList;
print(name);
nyem = split(name, "/");
nyem = nyem[1];
nyem = substring(nyem,0,lengthOf(nyem)-4);
name = fList;
nom = substring(name,0,lengthOf(name)-4);
File.makeDirectory(nom);

getDimensions(width, height, channels, slices, frames);
colours = channels;
for (channel=1;channel<=colours;channel++){
        getDimensions(width, height, channels, slices, frames);
        for (time = 1;time<=frames;time++){
                selectWindow(nyem+".nd2");
                //Stack.setFrame(time);
                //Stack.setChannel(channel);
                run("Duplicate...", "duplicate channels="+channel+" frames="+time);
                if (time<10){
saveAs("Tiff", nom+"/"+nyem+"_c"+channel+"_t0"+time+".tif");
                } else{
saveAs("Tiff", nom+"/"+nyem+"_c"+channel+"_t"+time+".tif");
                }
                close();
        }
}

eval("Script","System.exit(0);");

