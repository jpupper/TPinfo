
//todo lo de la escena 3
class Scene3 {

  //defino un reproductor

  AudioPlayer musica; //Reproductor.
  Soldesliders soldesliders; 
  Star [] stars = new  Star[200]; //Cantidad de estrellitas
 
  PauseS3 pause; 

  Planeta [] planetas = new Planeta[10];
  Scene3() {    
    int sum =0;
    //inicializar planetas
    for (int x=0; x<planetas.length; x++) {
      sum++;
      
      //De esta manera puedo poner mas planetas y repetir las imagenes y ya re fueeee
      if (sum == planetas.length/2) {
        sum = 0;
      }
      planetas[x] = new Planeta("planeta"+str(sum+1)+".png", ((x+1)*100)/2);
    }
    
    //inicializar estrellas
    for (int i=0; i<stars.length; i++) {
      stars[i] = new Star();
    }
    
    //inicializar el sol de sliders
    soldesliders = new Soldesliders(width /2, height /2);
    //inicializar la pausa
    pause = new PauseS3();
  }
  void init() {
      //musica = minim.loadFile("sounds/musica_escena3.mp3", 2048); //Cargar musica de la escena 3
      //musica.setGain(-10);
  }
  void run() {

    if (pause.isactive) {
      pause.run();
    } else { 
      update();
      display();
    }
  }

  void display() {
    background(0);
    boton(); //el boton de la pantalla final
    soldesliders.display(); //sol de sliders
    
    
    //mostrar planetas
    for (int x=0; x<planetas.length; x++) {
      planetas[x].display();
    }
    //mostrar estrellas
    for (int i = 0; i<stars.length; i++) {
      stars[i].display();
    }
  }

  void update() {
    //Bueno acá con los sliders del sol se modifica cada variable
    
    //ESTRELLAS
    for (int i = 0; i<stars.length; i++) {
      stars[i].update();
      stars[i].speed = map(soldesliders.sliders[1].value, 0, 1, 0, 20);
      stars[i].size = map(soldesliders.sliders[7].value, 0, 1, 10, 25);
    }
    
    //PLANETAS
    for (int x=0; x<planetas.length; x++) {
      planetas[x].update();
      planetas[x].anglespeed = soldesliders.sliders[3].value * 0.3;
      planetas[x].amp = (x+1) * soldesliders.sliders[2].value*100;
      planetas[x].fase = (x+1) * map(soldesliders.sliders[4].value, 0, 1, 0, TWO_PI);
      planetas[x].fasey = (x+1) * map(soldesliders.sliders[5].value, 0, 1, 0, TWO_PI);
      planetas[x].anglespeedy = soldesliders.sliders[6].value * 0.3;
    }
  }
  //función para meter todo lo del boton para pasar a la pantalla final, es repetitivo de lo que ya explique en las otras escenas
  private void boton() {
    float butonw = 120;
    float butonh = 20;
    float posbutonX = width - butonw/2;
    float posbutonY = height - butonh/2;

    if (overRect(posbutonX, posbutonY, butonw, butonh)) {
      fill(colores[1]);
      if (mousePressed) {
        click.trigger();
        activescene = 4;
      }
    } else {
      fill(colores[2]);
    }
    rect(posbutonX, posbutonY, butonw, butonh);
    fill(colores[3]);
    textSize(12);
    text("Pantalla final", posbutonX, posbutonY);
  }
}

//Clase planeta
class Planeta {
  PImage img; //imagen de la clase planeta
  float angle; //angulo en el eje X y Z
  float angley; //angulo en el eje Y
  float amp; //amplitud
  float anglespeed; //velocidad angular en el eje X y X
  float anglespeedy; //velocidad angular en el eje Y
  float fase; //para cambiar la fase en el eje X y Z

  float fasey;  //para cambiar la fase en el eje Y 
  Planeta(String dir, float _amp) {
    amp = _amp;
    angle = 0;
    angley =0;
    img = loadImage(dir);
    anglespeed = 0.4;
    fase = 0;
    fasey = 0;
  }
  void display() {
    pushMatrix();

    translate(width/2 + amp * sin(angle+fase), height/2 +   amp * sin(angley+fasey), amp * cos(angle+fase));
    image(img, 0, 0, 20, 20);
    popMatrix();
  }
  void update() {
    angle+=anglespeed;
    angley+=anglespeedy;
  }
}

class Star { 
  //Bueno este esta un poco sacado del de shiffman : https://www.youtube.com/watch?v=17WoOqgXsRM
  
  float x; // x de la estrella
  float y; // y de la estrella 
  float z; // z de la estrella

  float px; //X anterior
  float py; //y anterior
  float size; //tamaño

  float speed;
  Star() {
    x = random(-width, width); //como el translate se pone en la mitad, es necesario poner esto para que se spawnee por toda la pantalla
    y = random(-height, height); //como el translate se pone en la mitad, es necesario poner esto para que se spawnee por toda la pantalla
    z = random(width);
    px = x;
    py = y;
    speed = 10;
    size = 10;
  }

  void display() {
    fill(255);
    noStroke();
    
    //Posición en donde empiezan en x e y
    float sx = map(x/z, 0, 1, 0, width);
    float sy = map(y/z, 0, 1, 0, width);
    
    //El radio de la ellipse tiene que ir cambiando para aumentar el efecto ese
    float r = map(z, 0, width, size, 0);
    fill(255, 200);
    pushMatrix();
    translate(width/2, height/2);
    ellipse(sx, sy, r, r);


    popMatrix();
  }

  void update() {
    z-=speed;
    //Esto sería como el regenerate de la ellipse
    if (z < 1) {
      z = width;
      x = random(-width, width);
      y = random(-height, height);
    }
  }
}

//bueno , la clase sol de sliders.
class Soldesliders {

  PVector pos;
  Slider [] sliders = new Slider[8]; //se definen 8, igual se usan 7, hay algo mal con la forma en la que estan puestos
  float size;
  color solcolor; // El color del sol
  //float slidersize = 80;
  float sliderh; //Altura de cada slider
  float sepY; //La separación en y de cada slider

  
  Soldesliders(float _x, float _y) {
    sliderh = 7; //Altura de cada slider
    pos = new PVector(_x, _y); //posición del sol
    size = 80;// El ancho del los sliders
    sepY = size/2+10;
    for (int x=0; x<sliders.length; x++) {
      float sliderw = (size-size*0.1)* abs(sin(map(x, 0, sliders.length, PI, 0))); // Esto esta un toque hardcodeado, por supuesto, pero basicamente es para hacer el primero al ultimo mas chiquito.
      sliders[x] = new Slider(_x, map(x, 0, sliders.length, _y-sepY, _y+sepY), sliderw, sliderh, 0, 1, 0);
    }
    solcolor = color(255, 255, 0);
  }
  void display() {
    colorMode(RGB);
    fill(255, 100, 0, 140);
    stroke(255, 255, 0);
    strokeWeight(3);
    ellipse(pos.x, pos.y, size+15, size+15);
    for (int j=1; j<sliders.length; j++) {
      sliders[j].checkinput();
      sliders[j].display();
    }
  }
}

//Clase slider, esta es la clase slider que se usa dentro del solllll, se puede usar en cualquier lugar igual
public class Slider {

  public float x, y, w, h; //posición en x, posición en y, ancho y alto
  public float value; //El valor actual en el que esta ese slider

  public float min, max; //El minimo y el maximo

  public color backcolor; //Color de atras
  public color topcolor; //color de adelante

  public boolean isActivable; //si se puede o no ser activado (esta quedo de otro, pero la dejo por si alguien que no soy yo la quiere usar en otro lugar


  //Bueno los respectivos parametros
  Slider(float _x, float _y, float _w, float _h, float _min, float _max, float _value) {

    x =_x;
    y =_y;
    w = _w;
    h = _h;

    backcolor = color(120, 150, 120); //Estos se podrían pasar como parametros, pero como los uso una sola vez, los hardcodeo para que tengan los colores dol sol
    topcolor = color(120, 150, 160);

    min = _min;
    max = _max;
    value = _value;

    isActivable = true;
  }

  public void run() {
    display();
    checkinput();
  }

  public void display() {
    noStroke();
    rectMode(CENTER);
    fill(backcolor);
    displayShape();
    fill(255, 0, 0);
    rectMode(CENTER);
  }

  protected void displayShape() {

    strokeCap(ROUND);
    strokeWeight(2);
    
    
    //Bueno , esto para que cambien de color mientras los vas moviendo.
    //Y también los muestra claro
    stroke(255, map(value, min, max, 255, 0), 0);
    fill(255, map(value, min, max, 255, 0), 0);

    rect(x, y, w, h);

    stroke(200, map(value, min, max, 200, 0), 0);
    fill(200, map(value, min, max, 200, 0), 0);
    rectMode(CORNERS);
    rect(x-w/2, y-h/2, map(value, min, max, x-w/2, x+w/2), y+h/2);
    fill(255, 0, 0);
  }
  //Checkea el inputttttt que basicamente es el mouse, y setea el valor a ese input
  public void checkinput() {
    if (isActivable) {
      if (mousePressed 
        && mouseX > x - w/2
        && mouseX < x + w/2
        && mouseY > y - h/2
        && mouseY < y + h/2) {
        value = map(mouseX, x-w/2, x+w/2, min, max);
      }
    }
  }

  public void setpos(float _x, float _y) {
    x = _x;
    y = _y;
  }
}

//Pausa 3sssss
class PauseS3 extends Pause {
  private Soldesliders pausasol;
  PauseS3() {
    super("GuipperImage");
    pausasol = new Soldesliders(width/2, height/2);
  }

  void run() {
    super.run();
    pausasol.display();
    fill(colores[3]);
    textAlign(CENTER);
    text(" Mediante los sliders que estan en el sol \npodremos controlar todos los parametros de la pantalla \nNOTA: No es intención de esta escena recrear el sistema solar con exactitud", width /2, height * 3/10);
  }
}