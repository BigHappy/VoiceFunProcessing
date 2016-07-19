ArrayList<PVector> dragpos;
ArrayList<PVector> branch;


  
  dragpos = new ArrayList();
  branch = new ArrayList();


  display() {
  
  fill(64);
  
  //
  stroke(0);
  strokeCap(ROUND);
  strokeWeight(8);
  noFill();
  beginShape();
  if (branch.size()>2) {
    PVector p = branch.get(0);
    vertex(p.x, p.y);
    PVector pa, pb, pc;
    for (int i=0; i<floor((branch.size()-1)/3); i++) {
      pa = branch.get(i*3+1);
      pb = branch.get(i*3+2);
      pc = branch.get(i*3+3);
      bezierVertex(pa.x, pa.y, pb.x, pb.y, pc.x, pc.y);
    }
    endShape();
  }
  //
  noStroke();
  fill(192);
  ellipseMode(CENTER);
  for (int i=0; i<dragpos.size(); i++) {
    PVector pos = dragpos.get(i);
    ellipse(pos.x, pos.y, 4, 4);
  }
}
void mousePressed() {
  dragpos.clear();
  dragpos.add(new PVector(mouseX, mouseY));
}
void mouseDragged() {
  dragpos.add(new PVector(mouseX, mouseY));
}
void mouseReleased() {
  dragpos.add(new PVector(mouseX, mouseY));
  smoothBeizer();
}

void smoothBeizer() {
  if (dragpos.size()<4) return;
  branch.clear();
  PVector p2 = null;
  PVector p0 = null;
  if (dragpos.size()<8) {
  } 
  else {
    for (int i=floor((dragpos.size()-1)/2)*2-1;i>0;i-=2) {
      dragpos.remove(i);
    }
    int rvnb = dragpos.size()-(floor((dragpos.size()-1)/3)*3+1);
    for (int i=0; i<rvnb; i++) {
      float maxd = 100000;
      int maxi = -1;
      for (int j=1;j<dragpos.size()-1;j++) {
        PVector pa = dragpos.get(j);
        PVector pb = dragpos.get(j+1);
        PVector pc = dragpos.get(j-1);
        float m = pa.dist(pb)+ pb.dist(pc);
        if (m<maxd) {
          maxd = m;
          maxi = j;
        }
      }
      dragpos.remove(maxi);
    }
  }
  for (int i=0; i<dragpos.size(); i++) {
    PVector pos = dragpos.get(i);
    switch(i%3) {
    case 0:
      if (p0==null) {
        branch.add(pos);
      }
      p0=pos;
      break;
    case 2: 
      p2=pos;
      break;
    case 1:
      if (p2==null) {
        branch.add(pos);
      } 
      else {
        PVector d = PVector.sub(p2, p0); 
        PVector e = PVector.sub(pos, p0);
        PVector en = e.get();
        en.normalize();
        PVector f = PVector.mult(en, d.mag());
        PVector b = PVector.add(d, f);
        b.normalize();
        PVector u = new PVector(b.y, -b.x);
        PVector v = new PVector(-b.y, b.x);
        if (d.dist(u)<d.dist(v)) {
          print("-");
          branch.add(PVector.add(PVector.mult(u, d.mag()), p0));
          branch.add(p0);
          branch.add(PVector.add(PVector.mult(v, e.mag()), p0));
        }
        else { 
          print("+");
          branch.add(PVector.add(PVector.mult(v, d.mag()), p0));
          branch.add(p0);
          branch.add(PVector.add(PVector.mult(u, e.mag()), p0));
        }
      }
      break;
    }
  }
  for (int i=dragpos.size()-branch.size(); i>0; i--) {
    branch.add(dragpos.get(dragpos.size()-i));
  }
}