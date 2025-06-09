Dialog.create("Files to process"); 
Dialog.addNumber("Enter total number of files to be processed", 0);
Dialog.show(); 
numFiles = Dialog.getNumber(); 
run("Options...", "iterations=1 count=1 black do=Nothing"); 
dir = getDirectory("Choose Export Directory "); 
setBatchMode("hide"); 
for (count = 0; count < numFiles; count++) { 
	run("Set Scale...", "distance=0 known=0 unit=pixel"); 
	print(getTitle()); 
	rename("cell"); 
	run("Duplicate...", "title=lys duplicate channels=1");  
	dog(lys);  
	setAutoThreshold("Otsu dark stack"); 
	setOption("BlackBackground", false);  
	run("Convert to Mask", "method=Otsu background=Dark black"); 
	selectWindow("cell"); 
	run("Duplicate...", "title=particle duplicate channels=2");
	setAutoThreshold("Intermodes dark stack");
	setOption("BlackBackground", false);
	run("Convert to Mask", "method=Intermodes background=Dark black"); 
	run("3D Objects Counter", "threshold=128 slice=15 min.=0 max.=489552 statistics summary"); 
	run("Summarize"); 
	if (nResults == 1){
  		getResult("Volume (pixel^3)");
	} 
	else{ 
		getResult("Volume (pixel^3)",nResults-4);
	} 
	run("Clear Results"); 
	imageCalculator("Add create 32-bit stack", "Result of b-1","particle"); 
	setMinAndMax(0, 510); 
	setAutoThreshold("Default dark stack"); 
	setThreshold(260.0000, 1000000000000000000000000000000.0000); 
	run("Convert to Mask", "method=Default background=Dark black"); 
	run("3D Objects Counter", "threshold=128 slice=17 min.=0 max.=733040 statistics summary"); 
	run("Summarize"); 
	if (nResults == 1){ 
		getResult("Volume (pixel^3)"); 
	} 
	else{ 
		getResult("Volume (pixel^3)",nResults-4); 
	} 
	run("Clear Results"); 
	selectWindow("cell");
  	close("\\Others"); 
  	run("Open Next"); 
  	run("Select None"); 
} 

function dog() { 
 rename("a");  
 run("Duplicate...", "title = a-1 duplicate"); 
 run("Duplicate...", "title = a-2 duplicate");  
 run("Gaussian Blur...", "sigma=2 stack"); 
 selectWindow("a-1"); 
 run("Gaussian Blur...", "sigma=1 stack");
 imageCalculator("Subtract create stack", "a-1","a-2");
} 