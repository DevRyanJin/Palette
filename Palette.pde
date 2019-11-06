
int whichPallete = -1; //pallet number to determine which pallete is selected. 
boolean hit =false; //determine if mouse is being pressed on pallete spot or the other. 
int numPressed = 0; //when creating triangle, the steps are twice of (mousePressed -> mouseDragged -> mouseReleased). 
                    //So, we need to keep track of how many mouseReleased occured so that we dont need to drag to last vertex of tiangle 


// store the position when drawing line to make a triangle or dragging the existed triangles 
PVector startP;
PVector endP;
float[] firEndP;
float[] secEndP;
float[] firStartP;


ArrayList <PVector> lines = new ArrayList <PVector> ();     // stores the intermidate lines to create triangle 
ArrayList <PVector> triangles = new ArrayList <PVector> (); // stores the traingles' vertices 
ArrayList <PVector> originTriangles = new ArrayList <PVector> (); // to stroe the origin state traingles' vertices 
ArrayList <PVector> triCenter = new ArrayList <PVector> ();       // the each triangles' center position 
ArrayList <PVector> selectedTri = new ArrayList <PVector> ();     // to determine the current selected triangle by user
ArrayList <Integer> selectedColor = new ArrayList <Integer> ();   // store the drawn color to each triangle  

int triColor =0; //temporaray variable to determine the color of triangle before it is drawn.  
color[] colArr = new color[10];  //colors for the pallete 

//stores the selected triangles number to keep track of (when selecting a triangle)
int selectedA;
int selectedB;
int selectedC;

int selectP; //stores the seleted vertex of specific triangle (when dragging the vertex of the triangles)

//determine whether a triangle has been selected or the vertex of the triangles has been selected. 
boolean selectVer = false;
boolean selectTri = false;

//to differtiate the origin triangles and transformed triangles 
int setOrigin = 0; 

// center position of each triangle
float centerX; 
float centerY; 

// angle to be applpied when keyPressed occur with 'r'  or 'e'
final float angle = PI/48;  


void setup() {
  startP = new PVector(0, 0);
  endP = new PVector(0, 0);
  firEndP = new float[2];
  secEndP = new float[2];
  firStartP = new float[2];
  
  size(800, 600, P3D);
  colorMode(RGB, 1.0f);
  
  //colors for the pallete 
    colArr[0] = color(0.1f, 0.1f, 0.9f);
    colArr[1] = color(0.1f, 0.9f, 0.1f);
    colArr[2] = color(0.9f, 0.1f, 0.1f);
    colArr[3] = color(0.4f, 0.4f, 0.9f);
    colArr[4] = color(0.9f, 0.4f, 0.4f);
    colArr[5] = color(0.9f, 0.9f, 0.1f);
    colArr[6] = color(0.9f, 0.4f, 0.9f);
    colArr[7] = color(0.1f, 0.4f, 0.4f);
    colArr[8] = color(0.4f, 0.1f, 0.4f);
    colArr[9] = color(0.4f, 0.9f, 0.9f);
}
void draw() {
  background(0);
  drawPalette();
  drawIntermLine();
  drawTriangle();
  gravityEffect();
}


//draw Intermidate lines befor creating a tiangle
void drawIntermLine(){
  stroke(255, 255, 255);

  beginShape(LINES);
  for (PVector p : lines) {
    vertex(p.x, p.y);
   }
  endShape();
  
  if(lines.size() == 6){
   makeTriangle(lines.get(0),lines.get(1),lines.get(3));
   lines.clear();
  }
}

//make each triangle when intermidate line process has been finished
void makeTriangle(PVector a1, PVector a2, PVector a3 ){
  triangles.add(a1);
  triangles.add(a2);
  triangles.add(a3);    
  PVector tempCenter = new PVector((a1.x+a2.x+a3.x)/3.0,(a1.y+a2.y+a3.y)/3.0);
  triCenter.add(tempCenter); 
}

//draw triangle on the screen 
void drawTriangle(){
  
//outline color of triangle
stroke(255,255,255);

beginShape(TRIANGLE);
  for (int i=0; i<triangles.size(); i++) {   
    
    //if a triangle has been selected, make it thicker outline. 
     if(i == selectedA && i+1 == selectedB && i+2 == selectedC)
      strokeWeight(7);
     else
      strokeWeight(1);
     
    //default color is blue. 
    //whenever pallete was clicked and then triangle was created, that triangle get that color of pallete
    if(((i+3)%3 ==0) && i/3 ==selectedColor.size()){ 
      if(whichPallete == -1 )
         selectedColor.add(colArr[0]);
      else    
         selectedColor.add(colArr[whichPallete]);  
     }
     
     //fill the color for each triangle
     for(int j=0; j<selectedColor.size(); j++)
         if( i==0 && j==0 || ((i+3)%3 ==0&& i/3 == j))                
             fill(selectedColor.get(j));      
             
    vertex(triangles.get(i).x, triangles.get(i).y);
  }
  endShape();

}


//for conneting verticies, give a "gravity" distance 
void gravityEffect(){
  for(int i=0; i<triangles.size(); i++)
  for(int j=i; j<triangles.size(); j++){
      if(i != j && dist(triangles.get(i).x,triangles.get(i).y,triangles.get(j).x,triangles.get(j).y) <= 7)
      {      
        triangles.set(j,triangles.get(i));
      }                
  }
}


void mousePressed() {
  float x = mouseX; 
  float y = mouseY;
  
  // if mousePressed occured on the pallete 
  if (x>=0 && y>=height-height/9 && x<=width && y<=height) {
    hit =false;
    //specifies which pallete has been pressed 
    if (x<=width/10) {
      whichPallete =0;
    } else if (x<=(width/10) *2) {
      whichPallete =1;
    } else if (x<= (width/10) *3) {
      whichPallete =2;
    } else if (x<= (width/10) *4) {
      whichPallete =3;
    } else if (x<= (width/10) *5) {
      whichPallete =4;
    } else if (x<=(width/10) *6) {
      whichPallete =5;
    } else if (x<=(width/10) *7) {
      whichPallete =6;
    } else if (x<= (width/10) *8) {
      whichPallete =7;
    } else if (x<= (width/10) *9) {
      whichPallete =8;
    } else {
      whichPallete =9;
    }
  } else { // if the screen has been selected, do somthing else

   vertexCollision(x,y);
   collisionCheck(x,y);
   hit = true;
   
   //when mousePressed occured on the vertex of existent triangle, we need to change its position by dragging 
   //But mousePressed occured on outside of all existent triangles, create triangle 
   if(selectVer){
      startP.set(mouseX, mouseY);
      endP.set(mouseX, mouseY);       
   }else if(!selectTri && !selectVer){
      startP.set(mouseX, mouseY);
      endP.set(mouseX, mouseY);          
   }
}
}

//calculate the vertex to be dragged. 
void vertexCollision(float x, float y){
  
  for(int i=0; i<triangles.size(); i++){ 
    float vertConflictX = triangles.get(i).x;
    float vertConflictY = triangles.get(i).y;
 
    if(dist(vertConflictX,vertConflictY,x,y) <=20){
      selectVer =true;
      selectP = i;
    }
  }
}

//determine whether mousePressed occured on inside of a triangle 
void collisionCheck(float x, float y){
  for (int i = triangles.size() - 3; i >= 0; i-=3) {
 
    // need to have 3 vertices  
    float x1 = triangles.get(i).x;
    float y1 =triangles.get(i).y;
    float x2 = triangles.get(i+1).x;
    float y2 =triangles.get(i+1).y;   
    float x3 = triangles.get(i+2).x;
    float y3 =triangles.get(i+2).y; 
      
    //center 
    float areaOrig = abs( (x2-x1)*(y3-y1) - (x3-x1)*(y2-y1) );
           
    float area1 = abs( (x1-x)*(y2-y) - (x2-x)*(y1-y) );
    float area2 = abs( (x2-x)*(y3-y) - (x3-x)*(y2-y) );
    float area3 = abs( (x3-x)*(y1-y) - (x1-x)*(y3-y) );
  

 // if inside triangle 
 if (area1 + area2 + area3 == areaOrig) {
       selectTri = true;

      //remove duplicated triangle which has been selected before from arrayList 
      if(selectedTri.size() >= 6)
         for(int j=0; j<selectedTri.size(); j+=3)
         {         
          if(triangles.get(i).x == selectedTri.get(j).x && 
            triangles.get(i).y == selectedTri.get(j).y  &&
            triangles.get(i+1).x == selectedTri.get(j+1).x && 
            triangles.get(i+1).y == selectedTri.get(j+1).y  &&
            triangles.get(i+2).x == selectedTri.get(j+2).x && 
            triangles.get(i+2).y == selectedTri.get(j+2).y)
              {      
                selectedTri.remove(j);
                selectedTri.remove(j);
                selectedTri.remove(j);
              }
          }
               
   //keep track of selected triangles
   for(int j=0; j<3; j++){
   selectedTri.add(triangles.get(i+j));
   }               
   selectedA = i;
   selectedB = i+1;
   selectedC = i+2;
   
   //temporarily stores the palleted when selected triangle appears. 
   triColor= whichPallete;
   
  //calculate the center of each triangles to transform 
   centerX  = (triangles.get(i).x +triangles.get(i+1).x+triangles.get(i+2).x)/3; 
   centerY  = (triangles.get(i).y +triangles.get(i+1).y+triangles.get(i+2).y)/3;
    }
  } //for
} //collisionCheck


void mouseDragged() {

  //need to differentiate the drag for either creting triangle or draggin vertices 
  if (hit && !selectTri) {
    
   endP.set(mouseX, mouseY);  
   
   if(numPressed ==0)
      line(startP.x,startP.y,mouseX,mouseY);
   else if(numPressed ==1)
      line(firEndP[0],firEndP[1],mouseX,mouseY);
      
  }else if(selectVer){ // if vertices to be dragged 
    
   triangles.set(selectP,new PVector(mouseX,mouseY));
   
   for(int i=0; i<triangles.size(); i++)
     if(selectP != i && dist(triangles.get(selectP).x,triangles.get(selectP).y,triangles.get(i).x,triangles.get(i).y)<=20)
          triangles.set(i,triangles.get(selectP));
  }
  
}


void mouseReleased() {
// when mouseReleased occured, need to save all the vertices were drawn to form a traingle
 if (hit && !selectTri) {
  if(numPressed ==0){
    lines.add(new PVector(startP.x,startP.y));
    lines.add(new PVector(endP.x,endP.y));
    firStartP[0]= startP.x;
    firStartP[1]= startP.y;
    firEndP[0] = endP.x;
    firEndP[1] = endP.y;
    numPressed++; 
  }else if(numPressed ==1){
    lines.add(new PVector(firEndP[0],firEndP[1]));
    lines.add(new PVector(endP.x,endP.y));
    lines.add(new PVector(endP.x,endP.y));
    lines.add(new PVector(firStartP[0],firStartP[1]));
    
    numPressed=0;
  }
 }

 selectTri = false;
 selectVer = false;
}
 
 
void keyPressed(){

//to store origin triangles before any transformation.   
  setOrigin++;
if(setOrigin ==1){
  for(int k=0; k<triangles.size(); k++){
    originTriangles.add(triangles.get(k));
  }
}

if(key == 'z'){
  for(int k=0; k<triangles.size(); k++)
    triangles.set(k,originTriangles.get(k));
    
    setOrigin=0;
}


//for the transformations 
pushMatrix();
translate(centerX,centerY);
 for (int i=0; i<triangles.size(); i++) 
 if(i == selectedA && i+1 == selectedB && i+2 == selectedC && selectedTri.size()>0 ){
  doTranslation(i);   
  doRotation(i); 
  doScale(i);
 }
popMatrix();
 
}


void doTranslation(int i){
  
 pushMatrix();
 translate(centerX,centerY);
     if(key == 'w'){
        triangles.set(i,new PVector(triangles.get(i).x,triangles.get(i).y-5));
        triangles.set(i+1,new PVector(triangles.get(i+1).x,triangles.get(i+1).y-5));
        triangles.set(i+2,new PVector(triangles.get(i+2).x,triangles.get(i+2).y-5));

      }else if(key == 'a'){
        triangles.set(i,new PVector(triangles.get(i).x-5,triangles.get(i).y));
        triangles.set(i+1,new PVector(triangles.get(i+1).x-5,triangles.get(i+1).y));
        triangles.set(i+2,new PVector(triangles.get(i+2).x-5,triangles.get(i+2).y));
    
      }else if(key == 's'){
        triangles.set(i,new PVector(triangles.get(i).x,triangles.get(i).y+5));
        triangles.set(i+1,new PVector(triangles.get(i+1).x,triangles.get(i+1).y+5));
        triangles.set(i+2,new PVector(triangles.get(i+2).x,triangles.get(i+2).y+5));
    
      }else if(key == 'd'){
        triangles.set(i,new PVector(triangles.get(i).x+5,triangles.get(i).y));
        triangles.set(i+1,new PVector(triangles.get(i+1).x+5,triangles.get(i+1).y));
        triangles.set(i+2,new PVector(triangles.get(i+2).x+5,triangles.get(i+2).y));
      }
      
 popMatrix();
 
}


void doRotation(int i){
  
 pushMatrix();
 translate(centerX,centerY);

 if(key == 'e'){
 float newX = (triangles.get(i).x - centerX)* cos(angle) - (triangles.get(i).y - centerY) * sin(angle) +centerX; 
 float newY = (triangles.get(i).x - centerX)* sin(angle) +(triangles.get(i).y - centerY) * cos(angle) +centerY; 
 float newX1 = (triangles.get(i+1).x - centerX)* cos(angle) - (triangles.get(i+1).y - centerY) * sin(angle) +centerX; 
 float newY1 = (triangles.get(i+1).x - centerX)* sin(angle) +(triangles.get(i+1).y - centerY) * cos(angle) +centerY; 
 float newX2 = (triangles.get(i+2).x - centerX)* cos(angle) - (triangles.get(i+2).y - centerY) * sin(angle) +centerX; 
 float newY2 = (triangles.get(i+2).x - centerX)* sin(angle) +(triangles.get(i+2).y - centerY) * cos(angle) +centerY; 
  
   triangles.set(i,new PVector(newX,newY));
   triangles.set(i+1,new PVector(newX1,newY1));
   triangles.set(i+2,new PVector(newX2,newY2));
   
 }else if(key == 'r'){

   
 float newX = (triangles.get(i).x - centerX)* cos(-angle) - (triangles.get(i).y - centerY) * sin(-angle) +centerX; 
 float newY = (triangles.get(i).x - centerX)* sin(-angle) +(triangles.get(i).y - centerY) * cos(-angle) +centerY; 
 float newX1 = (triangles.get(i+1).x - centerX)* cos(-angle) - (triangles.get(i+1).y - centerY) * sin(-angle) +centerX; 
 float newY1 = (triangles.get(i+1).x - centerX)* sin(-angle) +(triangles.get(i+1).y - centerY) * cos(-angle) +centerY; 
 float newX2 = (triangles.get(i+2).x - centerX)* cos(-angle) - (triangles.get(i+2).y - centerY) * sin(-angle) +centerX; 
 float newY2 = (triangles.get(i+2).x - centerX)* sin(-angle) +(triangles.get(i+2).y - centerY) * cos(-angle) +centerY; 
  
  triangles.set(i,new PVector(newX,newY));
   triangles.set(i+1,new PVector(newX1,newY1));
   triangles.set(i+2,new PVector(newX2,newY2));
   
 }
 popMatrix();

  
}
void doScale(int i){
  
float newX=0; 
float newY=0;

  pushMatrix();
  translate(centerX,centerY);

 if(key == 'c'){
   newX = centerX +(triangles.get(i).x- centerX) * 0.9;
   newY = centerY +(triangles.get(i).y- centerY) * 0.9;
   
 triangles.set(i,new PVector(newX,newY));
  
   newX = centerX +(triangles.get(i+1).x- centerX) * 0.9;
   newY = centerY +(triangles.get(i+1).y- centerY) * 0.9;
 
 triangles.set(i+1,new PVector(newX,newY));
 
   newX = centerX +(triangles.get(i+2).x- centerX) * 0.9;
   newY = centerY +(triangles.get(i+2).y- centerY) * 0.9;

 triangles.set(i+2,new PVector(newX,newY));


 }else if(key == 'v'){
   
   newX = centerX +(triangles.get(i).x- centerX) * 1.1;
   newY = centerY +(triangles.get(i).y- centerY) * 1.1;
   
    triangles.set(i,new PVector(newX,newY));
  
  newX = centerX +(triangles.get(i+1).x- centerX) * 1.1;
  newY = centerY +(triangles.get(i+1).y- centerY) * 1.1;
 
    triangles.set(i+1,new PVector(newX,newY));
 
  newX = centerX +(triangles.get(i+2).x- centerX) * 1.1;
  newY = centerY +(triangles.get(i+2).y- centerY) * 1.1;

    triangles.set(i+2,new PVector(newX,newY));

   
 }
 
 popMatrix();

}

//draw pallete 
void drawPalette() {
  float x =0; 
  float y =height-height/9;
  float x1 =width/10;
  float y1 =height;

  for (int i=0; i<10; i++) { 

    strokeWeight(1);
    stroke(0); 
 
    if (whichPallete == i) {
      strokeWeight(3);
      stroke(255, 255, 255);
    }
    
    fill(colArr[i]);
    
    beginShape(QUADS);
    vertex(x, y);
    vertex(x, y1);
    vertex(x1, y1);
    vertex(x1, y);
    endShape();
    x +=width/10;
    x1+=width/10;
  }
}