Dialog.create("Files to process"); 
Dialog.addNumber("Enter total number of files to be processed", 0); 
Dialog.show(); 
numFiles = Dialog.getNumber(); 
run("Options...", "iterations=1 count=1 black do=Nothing"); 
dir = getDirectory("Choose Export Directory "); 
run("Set Measurements...", "mean redirect=None decimal=3"); 
setBatchMode("hide"); 
for (i = 0; i < numFiles; i++){ 
 imageName = getTitle(); 
 print(imageName); 
 rename("a"); 
 run("Duplicate...", "title=b duplicate range=3-3");
 run("Duplicate...", " "); 
 rename("b-1"); 
 run("Duplicate...", " "); 
 rename("b-2"); 
 run("Gaussian Blur...", "sigma=2"); 
 selectImage("b-1"); 
 run("Gaussian Blur...", "sigma=1"); 
 imageCalculator("Subtract create", "b-1","b-2"); 
 selectImage("Result of b-1"); 
 run("Gaussian Blur...", "sigma=0.5");  
 setAutoThreshold("Otsu dark"); 
 run("Convert to Mask"); 
 run("Analyze Particles...", "size=6-infinity pixel exclude add"); 
 print(roiManager("count")); 
 if (roiManager("count") == 0){ 
  selectWindow("a"); 
  close("\\Others"); 
  run("Open Next"); 
  run("Select None"); 
 } 
 else { 
  selectImage("a"); 
  run("Duplicate...", "title=[sera green] duplicate range=1-1"); 
  intensities(); 
  selectWindow("a"); 
  run("Duplicate...", "title=[sera red] duplicate range=2-2"); 
  intensities();
  saveAs("Results", dir+imageName+"_Results.csv"); 
  run("Clear Results"); 
  roiManager("reset"); 
  selectWindow("a"); 
  close("\\Others"); 
  run("Open Next"); 
  run("Select None"); 
  } 
}  
function intensities() { 
 setBatchMode("hide"); 
 rename("mip"); 
 mode = getValue("Mode"); 
 if (mode > 65000){ 
  mode = 0; 
  print("saturated signal"); 
 } 
 run("Subtract...", "value=mode"); 
 roiManager("multi-measure measure_all append"); 
 return "Results";
}