class Voice {

  Body body;
  float w;
  float h;
  String voice;
  int fontNum;
  int switchNum = 7;
  int switchNum2 = 0;
  int colorNum = 0;

  
  Voice(float x, float y, String voice_){
    w = random(16, 30);
    h = random(16, 30);
    voice = voice_;
    
    if(voice.matches("びっくり")){
      voice = "!";
    }
    if(voice.matches("はてな")){
      voice = "?";
    }
    
    if (voice.matches("つるつる")) {
    switchNum = 8;
  }
  if (voice.matches("ざらざら")) {
    switchNum = 9;
  }
  if (voice.matches("おもい")){
    w = 50;
    h = 50;
    switchNum2 = 1;
  }
  if (voice.matches("かるい")){
    w = 16;
    h = 16;
    switchNum2 = 2;
  }
  if (voice.matches("からふる")) {
    colorNum = 1;
  }
    makeBody(new Vec2(x, y), w, h);
  }
  
  Voice(float x, float y, String voice_,int fontNum_){
    w = random(16, 30);
    h = random(16, 30);
    fontNum  = fontNum_;
    voice = voice_;
    makeBody(new Vec2(x, y), w, h);
  }
  
  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  
  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }


  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    
    fill(255);
    if(colorNum == 1){
      fill(random(255),random(255),random(255));
    }
    //colorNum = 0;
    stroke(0);
    strokeWeight(2);
    PFont font2 = createFont("MS Gothic",48,true);
    PFont font = createFont("imagine YOKOHAMA",48,true);
    //PFont font3 = createFont("JKG-M_3",48,true);
    
    switch(fontNum){
      case 0:
        textFont(font);
        break;
      case 1:
        textFont(font2);
        break;
      default:
        break;
    }  
    
    
    textSize (w*2); // フォントサイズ指定：48
    text (voice, 0, 0);//文字の描画
    //rect(0, 0, w, h);
    popMatrix();
  }

  void makeBody(Vec2 center, float w_, float h_) {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.density = 1;
    
    //つるつる
    if(switchNum == 8){
      println("つるつる");
      fd.friction = 0.00000001; 
    }
    //ざらざら
    if(switchNum == 9){
      println("ざらざら");
      fd.friction = 1000000000;
    }
    println(fd.friction);
    if(switchNum == 7){
      fd.friction = 0.3;
    }
    fd.restitution = 0.5;
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    body.createFixture(fd);
    if(switchNum2 == 0){
      body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
      body.setAngularVelocity(random(-10, 10));
    }
    if(switchNum2 == 1){
      body.setLinearVelocity(new Vec2(0,0));
      body.setAngularVelocity(0);
    }
    if(switchNum2 == 2){
      body.setLinearVelocity(new Vec2(5,5));
      body.setAngularVelocity(100);
    }
    
  }
}