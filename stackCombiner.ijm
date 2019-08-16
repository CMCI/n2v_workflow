fPath = getArgument(); // Find the folder of images to process
imName = substring(fPath,0,lengthOf(fPath)); //remove the "/" from the end of the file path
print(imName);
fList = getFileList(fPath);
cMax = 0;
tMax = 0;
open(fPath+"/"+fList[0]); //open the first image in the folder pointed to by the bash script
getDimensions(width, height, channels, slices, frames); //how many z slices are there?
close(); 
for(i=0;i<lengthOf(fList);i++){ //for each image in the folder
	c = substring(fList[i],lengthOf(fList[i])-18,lengthOf(fList[i])-17); //what channel is it?
	t = substring(fList[i],lengthOf(fList[i])-15,lengthOf(fList[i])-13); //what timepoint is it?
	c = parseInt(c); //make these "letters" into numbers
	t = parseInt(t);
	if (c>cMax){ //if the channel of this image is higher than any previously recorded
		cMax = c; //record it
	}
	if (t>tMax){ //as above, but for t
		tMax = t;
	}
} //now we know how mazy Z, T and C we have
run("Image Sequence...", "open="+fPath+" sort"); //open every image in the folder, in order
run("Stack to Hyperstack...", "order=xyztc channels="+cMax+" slices="+slices+" frames="+tMax+" display=Composite"); //merger into a hyperstack with the dimesions determined above
Stack.setFrame(1); //go to the first frame (assuming this is the brightest)
run("Z Project...", "projection=[Max Intensity]"); //max project it
getDimensions(width, height, channels, slices, frames); //get the dimensions of the image
minVal = newArray(channels); //make a place to store the min and max of the channel information
maxVal = newArray(channels);
for (channel = 0;channel<channels;channel++){ //for every channel
	Stack.setChannel(channel+1); //go to the channel
	for(x=1;x<width;x++){ //find the brightest and dimmest pixel in the image
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
for (channel = 0;channel<channels;channel++){ //for each channel
	Stack.setChannel(channel+1); //go to that channel
	setMinAndMax(minVal[channel],maxVal[channel]); //set the min and max based on the values found above
}
run("16-bit"); //convert the image to a 16-bit image 

saveAs("tiff",imName+"_denoised.tif"); //save it
close();
