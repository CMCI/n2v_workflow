fPath = getArgument(); // Find the folder of images to analyse
//print(fPath);
imName = substring(fPath,0,lengthOf(fPath));
print(imName);
fList = getFileList(fPath);
//Array.print(fList);
cMax = 0;
tMax = 0;
//print(fPath+fList[lengthOf(fList)-1]);
open(fPath+"/"+fList[0]);
getDimensions(width, height, channels, slices, frames);
close();
//print("Got Dimensions");
for(i=0;i<lengthOf(fList);i++){
	c = substring(fList[i],lengthOf(fList[i])-18,lengthOf(fList[i])-17);
	t = substring(fList[i],lengthOf(fList[i])-15,lengthOf(fList[i])-13);
//	print(c,t);
	c = parseInt(c);
	t = parseInt(t);
	if (c>cMax){
		cMax = c;
	}
	if (t>tMax){
		tMax = t;
	}
}
run("Image Sequence...", "open="+fPath+" sort");
//getDimensions(width, height, channels, slices, frames);
//print("Slices = "+slices);
//print("Channels = "+cMax);
//print("Frames = "+tMax);
run("Stack to Hyperstack...", "order=xyztc channels="+cMax+" slices="+slices+" frames="+tMax+" display=Composite");
Stack.setFrame(1);
run("Z Project...", "projection=[Max Intensity]");
getDimensions(width, height, channels, slices, frames);
minVal = newArray(channels);
maxVal = newArray(channels);
for (channel = 0;channel<channels;channel++){
	Stack.setChannel(channel+1);
	for(x=1;x<width;x++){
		for(y=1;y<height;y++){
			val = getPixel(x,y);
			if (val<minVal[channel]){
				minVal[channel] = val;}
			if (val>maxVal[channel]){
                                maxVal[channel] = val;}
		}
	}
}
close();//the maximum projection
for (channel = 0;channel<channels;channel++){
	Stack.setChannel(channel+1);
	setMinAndMax(minVal[channel],maxVal[channel]);
}
run("16-bit");

saveAs("tiff",imName+"_denoised.tif");
close();
