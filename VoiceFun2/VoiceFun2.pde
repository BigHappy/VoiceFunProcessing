import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import processing.net.*;
import ddf.minim.*;


Box2DProcessing box2d;
ArrayList<Boundary> boundaries;
ArrayList<Circle> circles;
ArrayList<Rect> rectes;
ArrayList<Voice> voices;
Voice v;
Circle c;
Rect r;
Client myClient;
Minim minim;
AudioPlayer player;

String voice;


float lineX;
float lineY;

boolean boundaryB = true;
int switchNum = 0;
boolean fontB = true;
int fontNum = 0;



ArrayList<Float> vertexX = new ArrayList<Float>();
ArrayList<Float> vertexY = new ArrayList<Float>();

void setup() {
  
  //size(1200,800);
  fullScreen();
  //音源
  minim = new Minim(this);
  player = minim.loadFile("starwars.mp3", 2048);
  player.play(); //再生
  //juliusサーバーと接続
  myClient = new Client(this,"localhost",10500);
  //box2dの世界
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -500);

  //voiceクラスとboundaryクラスの動的配列
  voices = new ArrayList<Voice>();
  boundaries = new ArrayList<Boundary>();
  circles = new ArrayList<Circle>();
  rectes = new ArrayList<Rect>();
  
  boundaries.add(new Boundary(width/5,height-600,width/4-50,10));
  boundaries.add(new Boundary(width/4,height-200,width/4-50,10));
  boundaries.add(new Boundary(2*width/4,height-5,width/2-50,10));
  boundaries.add(new Boundary(3*width/4,height-400,width/2-50,10));
  
  //lines.add(new Line(100,100,300,300));
  
  for(int i = 0; i < 5; i++){
    v = new Voice(width/2,30,"あ");
    voices.add(v);
  }
  for(int i = 0; i < 5; i++){
    v = new Voice(width/2,30,"い",fontNum);
    voices.add(v);
  }
  for(int i = 0; i < 5; i++){
    v = new Voice(width/2,30,"う");
    voices.add(v);
  }
  for(int i = 0; i < 5; i++){
    v = new Voice(width/2,30,"え");
    voices.add(v);
  }
  for(int i = 0; i < 5; i++){
    v = new Voice(width/2,30,"お");
    voices.add(v);
  }
}

void draw() {
  
switch( switchNum ){
  case 0:
    //println( "message 0" ); 
    background(0);
    break;
  case 1:
    background(230,60,53);
    println( "あか" ); 
    break;
  case 2:
    background(103,182,45);
    println( "みどり" ); 
    break;
  case 3:
    background(30,140,190);
    println( "あお");
    break;
  case 4:
    background(255,199,0);
    println( "きいろ" ); 
    break;
  case 5:
    background(255,139,34);
    println( "だいだい" ); 
    break;
  case 6:
    background(160,53,229);
    println( "むらさき" ); 
    break;
}
  //background(30,140,190);
  
  
  //box2dのおまじない
  box2d.step();

  //例外処理
  //try中でthrowが出てきたらその場でcatchに処理を渡す
  try {
    v = new Voice(random(width),30,getWord());
    voices.add(v);
  }catch (Exception e) {
    
    println(e.getMessage());
  }
  
   
  
  for(Voice b: voices) {
    b.display();
  }
  for (Circle c: circles) {
    c.display();
  }
  for (Rect r: rectes) {
    r.display();
  }
  
  if(boundaryB = true){
  for (Boundary wall: boundaries) {
    wall.display();
  }
  
  }
  for (int i = voices.size()-1; i >= 0; i--) {
    Voice b = voices.get(i);
    if (b.done()) {
      print("kill");
      voices.remove(i);
    }
  }
  for (int i = rectes.size()-1; i >= 0; i--) {
    Rect r = rectes.get(i);
    if (r.done()) {
      print("kill");
      rectes.remove(i);
    }
  }
  for (int i = circles.size()-1; i >= 0; i--) {
    Circle c = circles.get(i);
    if (c.done()) {
      print("kill");
      circles.remove(i);
    }
  }
}

String getWord() throws Exception {
    String word = "";
    if (myClient.available()>0){
        String dataIn = myClient.readString();
        String[] sList = split(dataIn, "WORD");
        //print(sList);
        for(int i=1;i<sList.length;i++){
            String tmp = sList[i];
            String[] tList = split(tmp, '"');
            word += tList[1];
        }
    }
    if (word == ""){
      throw new Exception("");
    }
    
    if (word != ""){
       println("HOGEHOGE");
       println(word);
       
    }
  if (word.matches("あか")) {
    switchNum = 1;
  }
  if (word.matches("みどり")) {
    switchNum = 2;
  }
  if (word.matches("あお")) {
    switchNum = 3;
  }
  if (word.matches("きいろ")) {
    switchNum = 4;
  }
  if (word.matches("だいだい")) {
    switchNum = 5;
  }
  if (word.matches("むらさき")) {
    switchNum = 6;
  }
  if (word.matches("えん")) {
    for(int i = 0; i < 5; i++){
    c = new Circle(random(width),30);
    circles.add(c);
  }
  }
  if (word.matches("しかく")) {
    for(int i = 0; i < 5; i++){
    r = new Rect(random(width),30);
    rectes.add(r);
  }
  }
  if (word.matches("いっぱい")) {
     for(int i = 0; i < 10; i++){
    c = new Circle(width/2,30);
    circles.add(c);
  }
  for(int i = 0; i < 10; i++){
    r = new Rect(width/2,30);
    rectes.add(r);
  }
  }
  
return word;
}

//消してもいいやつ 
void keyPressed(){
  if (key == 'f'){
    if (fontNum == 1){
      fontNum = 0;
    }
    if (fontNum == 0){
      fontNum = 1;
    }
    fontB = !fontB;
    for(int i = 0; i < 5; i++){
    v = new Voice(width/2,30,"あ",fontNum);
    voices.add(v);
  }
  }
  if (key == 'c'){
    for(int i = 0; i < 5; i++){
    c = new Circle(width/2,30);
    circles.add(c);
  }
  }
  if (key == 'r'){
    for(int i = 0; i < 5; i++){
    r = new Rect(width/2,30);
    rectes.add(r);
  }
  }
  
  
}