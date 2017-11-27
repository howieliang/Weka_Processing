//*********************************************
// Weka for Processing
// KNN_LoadModel
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

Table csvData;
String fileName = "data/testData.csv";
boolean b_saveCSV = false;
boolean b_train = false;
boolean b_test = false;

int label = 0;

PGraphics pg;

void setup() {
  size(500, 500);
  
  //Initiate the dataList and set the header of table
  csvData = new Table();
  csvData.addColumn("x");
  csvData.addColumn("y");
  csvData.addColumn("label");
  
  pg = createGraphics(width, height);
  
  try {
    initTrainingSet(csvData);
    cls = (IBk) weka.core.SerializationHelper.read(dataPath("KNN.model"));
    pg = getModelImage(pg, (Classifier)cls, training);
    b_train = false;
    b_test = true;
  } 
  catch (Exception e) {
    e.printStackTrace();
  }

  
}

void draw() {
  background(255);
  
  if (b_train) {
    //Save the table to the file folder
    try {
      initTrainingSet(csvData); // in Weka.pde
      cls = new IBk();
      cls.buildClassifier(training);
      //weka.core.SerializationHelper.write(dataPath("KNN.model"), cls);
      b_train = false;
      b_test = true;
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
  
  image(pg, 0, 0);
  for (int i = 0; i < csvData.getRowCount(); i++) { 
    //read the values from the file
    TableRow row = csvData.getRow(i);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    float id = row.getFloat("label");
    int index = (int) id;

    //form a feature array
    float[] features = { x, y };

    //draw the data on the Canvas
    drawDataPoint(index, features);
  }
  
  if (b_test) {
    Instance inst = new DenseInstance(3);     
    inst.setValue(training.attribute(0), (float)mouseX); 
    inst.setValue(training.attribute(1), (float)mouseY); 

    // "instance" has to be associated with "Instances"
    Instances testData = new Instances("Test Data", attributes, 0);
    testData.add(inst);
    testData.setClassIndex(2);        

    float classification = -1;
    try {
      // have to get the data out of Instances
      classification = (float) cls.classifyInstance(testData.firstInstance());
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    drawMouseCursor((int)classification);
  } else {
    drawMouseCursor(label);
  }

  if (b_saveCSV) {
    //Save the table to the file folder
    saveTable(csvData, fileName); //save table as CSV file
    println("Saved as: ", fileName);
    //reset b_saveCSV;
    b_saveCSV = false;
  }
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    ++label;
    label %= 10;
  }
}

void keyPressed() {
  if (key == 'S' || key == 's') {
    b_saveCSV = true;
  }
  if (key == 'T' || key == 't') {
    b_train = true;
    b_test = false;
  }
  if (key == 'D' || key == 'd') {
    b_train = true;
    b_test = false;
  }
  if (key == ' ') {
    csvData.clearRows();
    label = 0;
  }
  if (key >= '0' && key <= '9') {
    label = key - '0';
  }
}

void drawMouseCursor(int _index) {
  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), 
    color(82, 179, 217), color(244, 208, 63), color(242, 121, 53), 
    color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), 
    color(128, 52, 0), color(52, 128, 0), color(128, 52, 0)
  };
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);
  if (mousePressed) {
    stroke(0);
    fill(255);
  } else { 
    noStroke();
    fill(colors[_index]);
  }
  ellipse(mouseX, mouseY, 20, 20);

  if (mousePressed) {
    noStroke();
    fill(0);
  } else { 
    fill(255);
  }
  text(_index, mouseX, mouseY);

  popStyle();
}

void drawDataPoint(int _index, float[] _features) {
  color colors[] = {
    color(155, 89, 182), color(63, 195, 128), color(214, 69, 65), 
    color(82, 179, 217), color(244, 208, 63), color(242, 121, 53), 
    color(0, 121, 53), color(128, 128, 0), color(52, 0, 128), 
    color(128, 52, 0), color(52, 128, 0), color(128, 52, 0)
  };
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);

  stroke(0);
  fill(colors[_index]);
  ellipse(_features[0], _features[1], 20, 20);

  noStroke();
  fill(0);
  text(_index, _features[0], _features[1]);

  popStyle();
}