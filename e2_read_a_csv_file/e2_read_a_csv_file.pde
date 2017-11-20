//*********************************************
// CSV Processing
// e2_read_a_csv_file
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

Table csvData;

void setup() {
  size(500, 500);

  //Initiate the dataList and set the header of table
  csvData = loadTable("iris_relabelled.csv", "header");
}

void draw() {
  background(255);
  if (csvData != null) {
    for (int i = 0; i < csvData.getRowCount(); i++) { 
      //read the values from the file
      TableRow row = csvData.getRow(i);
      float slength = row.getFloat("slength");
      float swidth = row.getFloat("swidth");
      float plength = row.getFloat("plength");
      float pwidth = row.getFloat("pwidth");
      float label = row.getFloat("class");
      int index = (int) label;
      
      //form a feature array
      float xScale = 50;
      float yScale = 50;
      //float[] features = { slength, swidth, plength, pwidth };
      float[] features = { slength*xScale, swidth*yScale, plength*xScale, pwidth*yScale };
      
      //draw the data on the Canvas
      drawDataPoint(index, features);
    }
  }
  noLoop();
}

void drawDataPoint(int _index, float[] _features) {
  pushStyle();
  textSize(12);
  textAlign(CENTER, CENTER);
  
  stroke(0);
  fill((_index==0?255:0),(_index==1?255:0),(_index==2?255:0));
  //ellipse(_features[0], _features[1], 5, 5);
  ellipse(_features[2], _features[3], 5, 5);
  
  popStyle();
}