run("Set Measurements...", "mean redirect=None decimal=3"); 
Dialog.create("Files to process"); 
Dialog.addNumber("Enter total number of files to be processed", 0); 
Dialog.show(); 
numFiles = Dialog.getNumber(); 
dir = getDirectory("Choose Data Export Directory "); 
setBatchMode("hide"); 
run("Set Measurements...", "mean redirect=None decimal=3"); 
for (count=0; count<numFiles; count++){ 
	 imageName = getTitle(); 
	 colSize = nSlices(); 
	 rename("cell"); 
	 run("Duplicate...", "title=lamp1 duplicate channels=1"); 
	 selectWindow("cell"); 
	 run("Duplicate...", "title=particle duplicate channels=2"); 
	 run("Z Project...", "projection=[Max Intensity]"); //Gaussian blur may be applied to improve thresholding
	 setAutoThreshold("Intermodes dark stack"); //Otsu can also be used 
	 setOption("BlackBackground", true); 
	 run("Convert to Mask", "method=Intermodes background=Dark black"); 
	 run("Analyze Particles...", "circularity=0.7-1.00 add");
	 particleNumber = roiManager("count"); 
	 datasetInfo = imageName+":"+particleNumber+" particles"+":"+colSize+"slices"; 
	 print(datasetInfo); 
	 if(roiManager("count") == 0){
		  print("No particles detected"); 
		  roiManager("reset") 
		  selectWindow("cell");  
		  close("\\Others"); 
		  run("Open Next");  
		  run("Select None");  
	 } 
	 else{  
		  selectWindow("lamp1"); 
		  roiManager("Multi Measure"); 
		  selectWindow("particle"); 
		  roiManager("multi-measure measure_all one append"); 
		  saveAs("Results", dir+imageName+"_Results.csv");
		  roiManager("reset") 
		  selectWindow("cell");
		  close("\\Others"); 
		  run("Open Next"); 
		  run("Select None"); 
	 } 
}