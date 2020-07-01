
//Todo lo que corre la escena 2. 

/*La escena 2 tiene nodos que permiten generar distintos dibujos. 


Cuanto mas efectos hay de una misma clase , mas fuerte se escucha ese track
Los controles son : 

R: remover todas.
T: remover ultima.
boton del mouse : ZOOM.

*/
class Scene2 {

  boolean mouseFlag; // Para que no siga mandando señales cuando se agarro el mouse
  ArrayList<Effect> effects; //Efectos
  
  float zoom; //Variable de control para el zoom
  float lastmouseX; //Variable del control para el zoom
  float lastmouseY; //Variable de control para el zoom


  AudioPlayer [] tracks = new AudioPlayer[5];
  public int activeffect = 1;
  PauseS2 pause;
  Scene2() {
    effects = new ArrayList<Effect>() ;
    pause = new PauseS2();
    activeffect = 1;
    //pause.isactive = false;
    zoom =1;
  }

  void init() {

    for (int x=0; x<tracks.length; x++) {
      tracks[x] = minim.loadFile("sounds/track"+str(x+1)+".wav");
      tracks[x].setGain(-200);
    }
  }


  void run() {
    
    /*Bueno aca hay un efecto zoom copado, primero con el boton del mouse del medio
    el lastmouseX e lastmouseY es como para que vaya viendo donde esta el mouse en caso de que este apretado,
    si se deja de estar apretado se va saliendo el punto pero a partir de ese ultimo mouse que fue presionado*/
    
    if (mousePressed && mouseButton == CENTER) {
      zoom += 0.05;//Esta sería como la velocidad del zoom para adentro
      pushMatrix();
      translate(mouseX, mouseY );
      scale(zoom, zoom);
      translate(-mouseX, - mouseY );
      display();
      popMatrix();
      lastmouseX = mouseX;
      lastmouseY = mouseY;
    } else if (zoom > 1) {
      zoom -= 0.1; //Zoom para afuera
      
      //Con esto las va acomodando:
      if (lastmouseX > width / 2) {
        lastmouseX += 0.1;
      }
      if (lastmouseX < width / 2) {
        lastmouseX -= 0.1;
      }
      if (lastmouseY < height / 2) {
        lastmouseY -= 0.1;
      }
      if (lastmouseY > height / 2) {
        lastmouseY += 0.1;
      }
      
      pushMatrix();
      translate(lastmouseX, lastmouseY);
      scale(zoom, zoom);
      translate(-lastmouseX, -lastmouseY);
      display();
      popMatrix();
    } else {
      display();
    }

    if (pause.isactive) {
      pause.run();
    } else { 
      update();
    }
  }

  //Borra el ultimo efecto:
  void removelast() {
    if (effects.size() > 0) {
      effects.remove(effects.size()-1);
    }
  }
  //muestra todos los efectos y reproduce canciones
  void display() {
    background(0);
    
    //muestra efectos
    for (Effect p : effects) {
      p.display();
    }
  
    //reproduce canciones:
    for (int x=0; x<tracks.length; x++) {
      if(!tracks[x].isLooping()){
      tracks[x].loop(1);
      }
    }
  }
  
  //actualiza todas las canciones
  void update() {
    
     //Agregar un nuefo efecto.
    if (mousePressed && mouseFlag && mouseButton == LEFT) {

      effects.add(new Effect(mouseX, mouseY, mouseX, mouseY, activeffect));
      mouseFlag = false;
    }
    
    //Esto es para que seguir moviendolo una vez que se creo y no se solto todavia
    if (mousePressed && !mouseFlag && effects.size() > 0 ) {
      effects.get(effects.size()-1).node1.pos.x = mouseX;
      effects.get(effects.size()-1).node1.pos.y = mouseY;
    }
    
    if (!mousePressed) {
      mouseFlag = true;
    }

    int [] cantefectos = new int[tracks.length]; //esta es para controlar cuantos efectos hay de un mismo tipo y luego setearlo al volumen del track  
    for (int x = effects.size()-1; x>=0; x--) {

      Effect effect = effects.get(x); //esta es la manera de obtener una instancia de un objeto particular cuando se utilizan los arraylist, capitulo 4, sistemas de particulas de shifman, sacado de ahí.
      effect.update();

      cantefectos[effects.get(x).activeffect-1]++; //Aca los cuenta
    }

    for (int x=0; x<tracks.length; x++) {
      //setea las ganancias de losa tracks en relacion con la cantidad de efectos que hay
      tracks[x].setGain(map(cantefectos[x], 0, 10, -40, 40));//El -20, valor hardcodeado y probado de como venía la movida. Es la cantidad de decibeles en el que queda.
    }
  }

  void clean() {
    effects.clear();
  }
}

//pausa de la escena 2
class PauseS2 extends Pause {
  PauseS2() {
    super("GuipperFX");
  }

  void run() {
    super.run();

    textAlign(LEFT);
    text("Utilizar nodos para mover los distintos efectos.\nCada efecto tiene su propio track sonoro,\ncuantos mas efectos haya, mas fuerte se \nescuchara el track del efecto", width * 1 /4, height * 2/10);
    text("1 a 8 : Cambiar el efecto seleccionado\nR: Borrar todos los efectos en la pantalla\nT: Borrar el ultimo efecto puesto\nClick izquierdo: Crear nuevos nodos.\nClick derecho: mover nodos existentes\nBoton ruedita del mouse: ZOOM", width * 1 /4, height * 4/10);
  }
}

//Clase del efecto
class Effect {
  float angle;//Esta está mas que nada para las animaciones oscilantes de los dibujos, depende cual sea el efecto depende su funcionalidad
  Node node1 ; //Los 2 nodos del efecto
  Node node2 ; 

  color C1; //Color 1
  color C2; //color 2
  int activeffect; //A que efecto pertenecen
  Effect(float _n1X, float _n1Y, float _n2X, float _n2Y, int _activeeffect) {
    node1 = new Node(_n1X, _n1Y); //inicializar nodo 1 
    node2 = new Node(_n2X, _n2Y); //inicializar nodo 2
    activeffect = _activeeffect; //setear efecto activo
    C1 = color(random(200), random(100), random(255)); //paletanga de colores
    C2 = color(random(200), random(100), random(255)); //paletanga de colores 2
  }
  void display() {
    stroke(2);
    stroke(255, 10);
    line(node1.pos.x, node1.pos.y, node2.pos.x, node2.pos.y); //Esta linita sutil para mostrar de que nodo a que nodo van las cosas
    noStroke();

    node1.display(); //Este display no dura mucho pero bueno
    node2.display();

    int cantcir =15;
    float amp = 30;
    float size = 57 * sin(angle) ;
    
    /*Aca estan todas las animaciones de todos los efectos, están hechos un poco por la inspiración del momento,mucho de esto fue probar a ver que salia y quedo así, hace falta que explique cada cosa? 
    como que ya se entiende lo que hacen las funciones y realmente no hay una algoritmo especificamente complicado en esta sección*/
    
    switch(activeffect) {
    case 1:
      for (int x = 0; x<cantcir; x++) {
        translate(0, 0);
        fill(lerpColor(C1, C2, map(x, 0, cantcir, 0, 1)), 200);
        noStroke();
        ellipse(map(x, 0, cantcir-1, node1.pos.x, node2.pos.x)+amp * cos (angle+map(x, 0, cantcir, 0, TWO_PI)), map(x, 0, cantcir-1, node1.pos.y, node2.pos.y)+amp * sin (angle+map(x, 0, cantcir, 0, TWO_PI)), size, size);
      }
      break;
    case 2:
      fill(C1);
      beginShape();
      for (int x = 0; x<20; x++) {

        vertex(map(x, 0, cantcir-1, node1.pos.x, node2.pos.x), map(x, 0, cantcir-1, node1.pos.y, node2.pos.y)+10 * sin (angle+map(x, 0, cantcir, 0, TWO_PI)));
      }
      endShape();
      break;
    case 3:

      for (int x = 0; x<cantcir; x++) {
        float r1 = 20;
        float r2 = 10;
        float fase = +map(x, 0, cantcir, 0, TWO_PI);
        float j = (r1-r2)* cos(angle/5+fase) + r2 * sin(angle/5*2+fase);
        float k = (r1-r2)* sin(angle/5+fase) - r2 * cos(angle/5*2+fase);
        strokeWeight(5);
        noFill();
        stroke(lerpColor(C1, C2, map(x, 0, cantcir, 0, 1)), 200);
        ellipse(map(x, 0, cantcir-1, node1.pos.x, node2.pos.x)+j, map(x, 0, cantcir-1, node1.pos.y, node2.pos.y)+k, 20, 20);
      }

      break;
    case 4:

      for (int x = 0; x<cantcir; x++) {

        noStroke();
        if (x % 2 == 0) {
          fill(255);
          ellipse(map(x, 0, cantcir-1, node1.pos.x, node2.pos.x)+amp * cos (angle), map(x, 0, cantcir-1, node1.pos.y, node2.pos.y)+amp * sin (angle), 7, 7);
        } else {
          fill(255);
          noFill();
          stroke(255);
          ellipse(map(x, 0, cantcir-1, node1.pos.x, node2.pos.x)+amp * cos (angle+PI/2), map(x, 0, cantcir-1, node1.pos.y, node2.pos.y)+amp * sin (angle+PI/2), 9, 9);
        }
      }

      break;
    case 5:

      for (int x = 0; x<cantcir; x++) {
        float _x = map(x, 0, cantcir, 0, 40) * sin(angle/2);
        float _y = map(x, 0, cantcir, 0, 40) * cos(angle/2);
        fill(100, 200, 300);
        ellipse(map(x, 0, cantcir-1, node1.pos.x, node2.pos.x)+_x, map(x, 0, cantcir-1, node1.pos.y, node2.pos.y)+_y, 10, 10);
      }
      break;
    case 6:

      for (int x = 0; x<cantcir; x++) {
        translate(0, 0);
        fill(lerpColor(C1, C2, map(x, 0, cantcir, 0, 1)), 200);
        noStroke();
        ellipse(map(x, 0, cantcir-1, node1.pos.x, node2.pos.x)+amp * cos (angle+map(x, 0, cantcir, 0, TWO_PI)), map(x, 0, cantcir-1, node1.pos.y, node2.pos.y)+amp * sin (angle+map(x, 0, cantcir, 0, TWO_PI)), size, size);
      }
      break;
    case 7:

      for (int x = 0; x<cantcir; x++) {
        translate(0, 0);
        fill(lerpColor(C1, C2, map(x, 0, cantcir, 0, 1)), 200);
        noStroke();
        ellipse(map(x, 0, cantcir-1, node1.pos.x, node2.pos.x)+amp * cos (angle+map(x, 0, cantcir, 0, TWO_PI)), map(x, 0, cantcir-1, node1.pos.y, node2.pos.y)+amp * sin (angle+map(x, 0, cantcir, 0, TWO_PI)), size, size);
      }
      break;
    case 8:

      for (int x = 0; x<cantcir; x++) {
        translate(0, 0);
        fill(lerpColor(C1, C2, map(x, 0, cantcir, 0, 1)), 200);
        noStroke();
        ellipse(map(x, 0, cantcir-1, node1.pos.x, node2.pos.x)+amp * cos (angle+map(x, 0, cantcir, 0, TWO_PI)), map(x, 0, cantcir-1, node1.pos.y, node2.pos.y)+amp * sin (angle+map(x, 0, cantcir, 0, TWO_PI)), size, size);
      }
      break;
    }
  }
  
  //Actualizar
  void update() {
    angle+=0.05;
    node1.update();
    node2.update();
    //node2.invertedfollow();
  }
}

//nodo !
class Node extends EllipseAgarrable {

  float initialalpha;
  Node(float x, float y) {
    super(x, y, 60);
    agarrable = true;
    initialalpha = 200;
  }

  void display() {

    //mostrar el circulito amarillo del nodo.
    strokeWeight(2);
    colorMode(RGB);
    stroke(255, 255, 0, initialalpha);
    noFill();
    ellipse(pos.x, pos.y, size, size);
  }

  void update() {
    initialalpha--; // para ir borrando el circulito amarillo
    if (agarrable) {
      if (ismouseover() && mousePressed && mouseButton == RIGHT) {
        agarrada = true;
        println("A");
        followmouse();
      }
      if (!mousePressed) {
        agarrada = false;
      }
      if (agarrada) {
        followmouse();
      }
    }
  }
}