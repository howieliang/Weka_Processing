//*********************************************
// Weka for Processing
// KNN_LoadModel
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

Table csvData;
String fileName = "data/testData.csv";
boolean b_train = false;
boolean b_test = false;
int K = 1;

void setup() {
  size(500, 500);
  
  //Initiate the dataList and set the header of table
  csvData = loadTable("testData.csv", "header");
  
  try {
    readCSVNominal("testData.csv");
    cls = new IBk(K);
    cls.buildClassifier(training);

    Evaluation eval = new Evaluation(training);
    eval.crossValidateModel(cls, training, 10, new Random(1)); //10-fold cross validation
    System.out.println(eval.toSummaryString("\nResults\n======\n", false));
    System.out.println(eval.toMatrixString());
    System.out.println(eval.toClassDetailsString());

    b_train = false;
    b_test = true;
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}

void draw() {
  background(255);
  
  for (int i = 0; i < csvData.getRowCount(); i++) { 
    TableRow row = csvData.getRow(i);
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    float id = row.getFloat("label");
    int index = (int) id;

    float[] features = { x, y }; //form a feature array
    drawDataPoint(index, features); //draw the data on the Canvas
  }
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