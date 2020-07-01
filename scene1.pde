
//Clase que corre todo lo que sucede en la escena 1.
class Scene1 {


  color bgcolor = color(255);
  ParticleSystem PS;
  PauseS1 pause; 
  Scene1() {
    PS = new ParticleSystem();
    pause = new PauseS1();
    // pause.isactive = true;
  }

  //Correr todo
  void run() {
    display();
    if (pause.isactive) {
      pause.run();
    } else { 
      update();
    }
  }

  //mostrar
  void display() {
    colorMode(HSB);
    background(bgcolor);

    PS.display();
    fill(0);
  }

  //Actualizar
  void update() {
    PS.update();

    if (PS.particulaagarrada() != -1) {
      bgcolor = PS.bgcolor;
    }
  }
}

//Clase para manejar los sistema de particulas
class ParticleSystem {
  //VALORES A DEVOLVER :

  AudioPlayer C, D, E, F, G, A, B, C2; //NOTAS
  
  //Todas estas variables son las variables que son las que se modifican cada vez que movemos una particula especial
  float posx, posy;  //posicion
  int Nefecto = 0; //Numero de efecto
  color bgcolor; //Color para el fondo (no se pasa como parametro, se modifica dentro de la clase escena)
  color particlecolor ; // Color de la particula
  float ampx, ampy, aspeedx, aspeedy; //Amplitud y velocidad de oscilación
  color strokecolor; //Color del borde
  float speedx, speedy; //Velocidad
  float size, strokesize; //tamaño del la figura y del borde
  float spawnposx, spawnposy; // El radio de spawn en el eje x e y
  boolean mouseFlag;

  ArrayList<Particle> particles; //ArrayList que maneja las particulas
  boolean particulaagarrada; // Esta es una variable que nos indica si hay o no hay una particula agarrada.

  //Dos consctructores de sistemas de particulas
  ParticleSystem() {
    particles = new ArrayList<Particle>();
    bgcolor = color(random(255), 150, 255);
    particlecolor = color(random(255), 150, 255);

    //Se inicializan las variables
    posx = width/2;
    posy = height/2;
    ampx=0;
    ampy=0; 
    aspeedx =0; 
    aspeedy=0;
    strokecolor = color(0);
    speedx = 2; //Este va a ser un solo numero que va a ir cambiando, y va a ser un random entre -(el valor de este) y este valor en positivo
    speedy = 2; //Este va a ser un solo numero que va a ir cambiando, y va a ser un random entre -(el valor de este) y este valor en positivo
    size = 40;
    spawnposx=0;
    spawnposy=0;
    particles = new ArrayList<Particle>();
    init();
  }
  void init() {
    //Cargar los sonidossss
    C = minim.loadFile("sounds/C.wav"); 
    D = minim.loadFile("sounds/D.wav"); 
    E = minim.loadFile("sounds/E.wav"); 
    F = minim.loadFile("sounds/F.wav"); 
    G = minim.loadFile("sounds/G.wav"); 
    A = minim.loadFile("sounds/A.wav"); 
    B = minim.loadFile("sounds/B.wav"); 
    C2 = minim.loadFile("sounds/C2.wav");
  }

  //mostrar sistema de particulas
  void display() {
    if (mousePressed && Nefecto == 6) {
      fill(255, 255, 0, 50);
      ellipse(posx, posy, map(mouseX, 0, width, 0, 400), map(mouseY, 0, height, 0, 400));
    }
    for (int x = particles.size()-1; x>0; x--) {
      Particle p = particles.get(x);
      p.display();
    }
  } 

  //Actualizar todo lo que tiene que ver con el sistema de particula
  void update() {
    for (int x=0; x<4; x++) {
      addParticle(); //Agragar particula
    }
    //Recorrer , actualizar y remover las particulas que que esten por fuera de la altura
    for (int x = particles.size()-1; x>0; x--) {
      Particle p = particles.get(x);
      p.update();
      //Si la particula muerta. 
      if (p.isDead()) {
        particles.remove(p);
      }
    }

    //aca viene la aprte extendida que reconoce que particula esta agarrada y demas
    for (int x = particles.size()-1; x>0; x--) {
      Particle p = particles.get(x);
      //p.update();
      if (particulaagarrada() == -1 || !mousePressed) {
        //pone en pausa todos los sonidos en caso de que no haya ninguna particula agarrada o que la particula agarrada no sea especial (particulaagarrada() == -1)
        C.pause();
        D.pause();
        E.pause();
        F.pause();
        G.pause();
        A.pause();
        B.pause();
        C2.pause();
        
        
        p.agarrable = true; //Deja o no agarrar las demas particulas
        mouseFlag = true; // Esta para activar una sola vez los sonidos, si no se disparan bocha y todo mal.
        Nefecto = 0; // Si el efecto es 0 no pasa nada.
      } else if (x != particulaagarrada()) {
        p.agarrable = false;
      } else {
        Nefecto  = particles.get(particulaagarrada()).type; // El numero de efecto va a ser el tipo de particula especial que se este agarrando
 
        colorMode(HSB);
        //Nefecto, variable que detecta cual es la variable que esta agarrada y que es lo que tiene que hacer en relacion con eso
        switch(Nefecto) {

        case 1:
          //Cambiar color del fondo.
          
          if(mouseFlag)C.loop(5);
          bgcolor = color (hue(p.colorShape), map(mouseX, 0, width, 0, 255), map(mouseY, 0, height, 255, 0));
          break;
        case 2:
          //Cambiar color de la particula
          if(mouseFlag)D.loop(5);
          println("P.ANIMA", p.anima);
          particlecolor = color(p.anima, map(mouseX, 0, width, 0, 255), map(mouseY, 0, height, 255, 0));
          break;
        case 3:
          //Oscilar
          if(mouseFlag)E.loop(5);
          ampx = map(mouseX, 0, width, 0, 5);
          ampy = map(mouseY, 0, width, 0, 5);
          //ampx = 20;
          //ampy = 20;
          aspeedx = map(mouseX, 0, width, 0.5, 0.1);
          aspeedy = map(mouseX, 0, width, 0.5, 0.1);
          println("OSCILAR ");
          break;
        case 4:
          if(mouseFlag)F.loop(5);
          //manejar el color del borde de las particulas
          strokecolor = color(hue(p.colorStroke), map(mouseX, 0, width, 0, 255), map(mouseY, 0, height, 0, 255));
          break;
        case 5:
          if(mouseFlag)G.loop(5);
          //cambiar la velocidad
          speedx = map(mouseX, 0, width, 1, 10);
          speedy = map(mouseY, 0, height, 1, 10);
          break;
        case 6:
          if(mouseFlag)A.loop(5);
          //Cambiar la posición del spawn
          spawnposx = map(mouseX, 0, width, 0, 100) ;
          spawnposy = map(mouseY, 0, height, 0, 100) ; 
          break;
        case 7:
          if(mouseFlag)B.loop(5);
          //Cambiar el tamaño del borde y del tamaño de la particula
          size = map(mouseX, 0, width, 5, 70);
          strokesize = map(mouseY, 0, height, 0, 5);
          break;
        case 8:
          if(mouseFlag)C2.loop(5);
          //Cambiar el random que... modifica... el movimiento en random? (sera mejorado para la versión final).
          println("Case 8");
          posx= mouseX;
          posy = mouseY;
          // rdm = map(mouseX, 0, width, 0, 2);

          break;
        }
          mouseFlag = false;
      }
      if (!mousePressed) {
        Nefecto = 0;
      }
    }
  }
  //Devuelve si efectivamente hay una particula agarrada, y que tipo de particula es esa particula que esta agarrada, si no hay ninguna particula agarrada entonces devuelve -1
  int particulaagarrada() {
    for (int x = particles.size()-1; x>0; x--) {
      Particle p = particles.get(x);
      if (p.agarrada) {
        return x;
      }
    }
    return -1; //devuelve -1 si no hay
  }
  //Agregar particula
  void addParticle() {
    float spawnlotery = random(10); //LAS POSIBILIDADES DE QUE SE SPAWNEEN UNA PARTICULA
    //Special_Particle P;

    //Aca viene el algoritmo que decide las posibilidades de que se spawnee las particulas especiales
    int nrospecial = 0;
    if (spawnlotery < 1) {

      float spawnspecial = random(11); // LAS POSIBILIDADES DE QUE LA PARTICULA SEA ESPECIAL
      float auxsize = random(15, size);
      float auxstrokesize = random(0, strokesize);
      if (spawnspecial < 1) {
        nrospecial = int(random(1, 10)); //Selección random dentro de toda la cantidad posible de particulas especiales; //esto funciona un toque mal creo, pero bueno, estadistica para la prox.
      } 

      particles.add(new Particle(posx + spawnposx * sin(random(TWO_PI)), posy + spawnposy * cos(random(TWO_PI)), 
        random(-speedx, speedx), random(-speedy, speedy), 
        ampx, ampy, 
        aspeedx, aspeedy, 
        auxsize, auxstrokesize, 
        particlecolor, 
        strokecolor, 
        nrospecial, 
        strokecolor));
    }
  }

  /*Esta es una funcion que optiene que numero de particula en la lista del sistema de particulas tiene agarrada.
   Devuelve -1 si no hay ninguna agarrada , ya que ese -1 servira para setear todas en agarrables*/

  //Por ahora esta solo funciona en addParticle del sistema de particulas heredado en la escena 1.
}

//Menu de pausa de la escena 1
class PauseS1 extends Pause {

  Particle [][] specialparticles = new Particle[4][2]; //Array de 2 dimensiones para mostrarlo en formato de filas y columnas

  private float posx; //Posición en x de todo el texto, centrado desde esquina
  private float posy; //Posición en y
  private float sepy; //Separacion en Y de los elementos
  private float sepx;//Separacion en X de los elementos
  private float sepxtext; // Separacion del texto con respecto a las particulas
  private float ellipsesize; //tamaño de particulas

  PauseS1() {
    super("Guipperticulas"); //Nombre de la escena

    posx = width * 1/5;
    posy = height * 3/10;
    sepy = 50;
    sepx = 250;
    sepxtext = 40;
    ellipsesize = 40;

    int type = 0;
    color colorshape  = color(random(255), random(150, 200), random(150, 255));
    color colorshape2 = color(random(255), random(200), 255);
    for (int k=0; k<4; k++) {
      for (int j=0; j<2; j++) {
        type++;
        specialparticles[k][j] = new Particle(posx + j*sepx, posy + k*sepy, ellipsesize, type, colorshape, colorshape2);
        specialparticles[k][j].strokesize = 1;
      }
    }
  }

  void run() {

    super.run();
    String [] textos = { "Fondo", "Oscilacion", "Velocidad", "Tamaño", "Color Particula", "Color borde", "Radio de spawn", "Posición de spawn" }; //Arrays para los textos
    int numerodetexto = 0;
    // textAlign(LEFT);

    text("Los valores  que se modifiquen (2 por particula : en el eje x e y) \n dependen de la posición de la particula especial en relación \n con el eje de coordenadas. R: reiniciar Sistema de particulas", posx-ellipsesize, posy-80);
    //Muestra todos los textos y todos las particulas.
    for (int j=0; j<2; j++) {
      for (int k=0; k<4; k++) { 
        noStroke();
        specialparticles[k][j].display();
        specialparticles[k][j].animate();

        fill(255);
        //textAlign(LEFT,CENTER);
        text(textos[numerodetexto], posx + j*sepx + sepxtext, posy+k*sepy);
        numerodetexto++;
      }
    }
  }
}



//Special particle, esta particula es la que decidira cuales son las particulas especiales, las particulas especiales son aquellas que funcionan
//como interfaz. Es decir las particulas que a nosotros nos permiten controlar las variables globales del sistema de particulas y de la escena en general.
//Hasta este momento ,estan hechas con clases heredadas cada particulas. Pero a fines de optimización veo muchas mas prudente utilizar una sola clase heredada
//que hacer 8 clases heredadas una por cada particula.

class Particle extends EllipseAgarrable {

  //Movimiento
  //PVector pos; //Vector para manejar la posicion
  PVector speed;// Velocidad
  PVector accel; //Aceleracion
  float topspeed;

  //Oscilacion
  PVector amp; //Amplitud de la oscilacion
  // float angle; //Angulo
  PVector angle;
  PVector Aspeed;

  //DISEÑO : 
  //float size; //Tamaño de la figura
  color colorShape; //Color de la figura
  color colorStroke; // Color del borde
  float strokesize; //tamaño del borde
  boolean agarrada; //Lee si está agarrada, solo puede estar agarrada si es agarrable
  boolean agarrable; //Permite determinar si la particula es o no es agarrable.   

  //Special Particle control
  int type; //Tipo de particula
  color Pcolor; //color de las miniparticulas que estan dentro de cada particula
  private float anima; //Variable que maneja las animaciones de las particulas

  private color colorshape2; //Color para la figurita de adentro
  //float anima; //Variable que hara distintas cosas en relación a cual es el tipo especial de particula
  private float maxsize;
  private boolean animatedir; //esta es para controla la dirección en la que se mueven las variables, como por ejemplo el del spawn radius que usa un limite;

  //Constructor para la escena
  Particle(float _x, float _y, 
    float _speedx, float _speedy, 
    float _ampx, float _ampy, 
    float _Aspeedx, float _Aspeedy, 
    float _size, float _strokesize, 
    color _colorshape, 
    color _colorstroke, 
    int _type, 
    color _colorshape2
    ) {
    
    super( _x, _y, _size);

    strokesize = _strokesize;   
    pos = new PVector(_x, _y);
    speed = new PVector(_speedx, _speedy);
    amp = new PVector(_ampx, _ampy); //Amplitud de la oscilacion
    angle = new PVector(random(TWO_PI), random(TWO_PI)); //Angulo
    Aspeed = new PVector(_Aspeedx, _Aspeedy);
    size = _size;
    amp = new PVector(_ampx, _ampy);
    Aspeed = new PVector(_Aspeedx, _Aspeedy);
    colorShape = _colorshape;
    colorStroke = _colorstroke;


    speed = new PVector(_speedx, _speedy);

    //Cositas de la particula especial
    type = _type;
    maxsize = _size;
    colorshape2 = _colorshape2;
    topspeed = 10;
    if (type == 4) {
      strokesize = 3;
    }
  }

  //Constructor que se va a utilizar en la pausa
  Particle(float _x, float _y, float _size, int _type, color _colorshape, color _colorshape2) {

    super( _x, _y, _size);
    type = _type;
    maxsize = _size;
    colorShape = _colorshape;
    colorshape2 = _colorshape2;

    strokesize = 0;   
    speed = new PVector(0, 0);
    amp = new PVector(0, 0); //Amplitud de la oscilacion
    angle = new PVector(0, 0); //Angulo
    Aspeed = new PVector(0, 0);
    size = _size;
    amp = new PVector(0, 0);
    Aspeed = new PVector(0, 0);
    colorShape = _colorshape;
    colorStroke = color(255);

    size = _size;
    if (type == 4) {
      strokesize = 3;
    }
  }

  void run() {
    display();
    update();
  }


  //El display va a depender de que tipo de particula es, como es el de especial se usa un entero para elegir cual es la que se muestra.
  void display() {

    float ellipsitasize = size/6; // El tamaño que deben tener las esferas que estan dentro de la clase de oscilacion y dentro de la clase de velocidad.

    /*Prefiero utilizar la estructura type cada vez que tengo que elegir entre opciones enteras,
     viste que normalmente los modos o las cosas ya preprogramadas siempre se definen
     como un valor que no puede ser mas que 1 o 2  o 3 (digamos un entero puro y que no es el resultado de una cuenta)
     ,bueno, para estos momentos prefiero utilizar swicth*/
    switch(type) {
    case 0: 
      basicdisplay();
      break;
    case 1:
      basicdisplay();
      colorShape = color(anima, map(pos.x, 0, width, 0, 255), map(pos.y, 0, height, 255, 0));
      break;
      //Particle Color Particle
    case 2:
      basicdisplay();
      // float elipsitasize = size /2;
      Pcolor = color(anima, map(pos.x, 0, width, 0, 255), map(pos.y, 0, height, 255, 0));
      fill(Pcolor);
      ellipse(pos.x, pos.y, size /2, size /2);
      break;

    case 3:
      //Oscilation Particle
      basicdisplay();
      int cantcir = 5;
      for (int  j=0; j<cantcir; j++) {
        //ellipse(pos.x, pos.y, 100, 100);
        fill(colorshape2);
        fill(255);
        ellipse(map(j, 0, cantcir, pos.x-size/2+ellipsitasize, pos.x+size/2), pos.y + (size/cantcir) * sin(anima+map(j, 0, cantcir, 0, TWO_PI)), ellipsitasize, ellipsitasize);
      }
      break;
    case 4:
      //Stroke Particle
      basicdisplay();
      break;
    case 5:
      //Speed Particle
      basicdisplay();
      fill(colorshape2);
      ellipse(pos.x, pos.y+anima-size/2, ellipsitasize, ellipsitasize);
      break;
    case 6:
      //Position Particle o spawn radius particle, la que define donde se van a spawnear
      strokeWeight(strokesize);
      noFill();
      strokeWeight(3);
      stroke(0);
      for (int x=0; x<4; x++) {       
        // fill(255);
        ellipse(pos.x, pos.y, map(x, 0, 4, 0, size), map(x, 0, 4, 0, size));
      }      
      break;
    case 7:
      //Size Particle
      basicdisplay();
      break;
    case 8:
      //Random Particle   
      basicdisplay();

      strokeWeight(2);
      line(pos.x -size/2, pos.y, pos.x+size/2, pos.y );
      line(pos.x, pos.y -size/2, pos.x, pos.y +size/2);
      //ellipse(pos.x, pos.y, random(maxsize*0.8, maxsize), random(maxsize*0.8, maxsize));
      break;
    }
  }

  //Muestra lo basico de la particula
  private void basicdisplay() {
    pushMatrix();
    translate(pos.x, pos.y);
    design();                 
    popMatrix();
  }
  
  //Esta maneja todo el diseño estetico de la particula
  private void design() {

    colorMode(HSB);
    fill(colorShape);
    stroke(colorStroke);
    strokeWeight(strokesize);
    ellipse(0, 0, size, size);
  }

  void update() {
    angle.add(Aspeed); //Sumarle la velocidad angular al angulo
    pos.x += amp.x * sin(angle.x); //oscilación en x de la particula
    pos.y += amp.y * cos(angle.y);//oscilación en y de la particula
    speed.limit(topspeed); //Limitar la velocidad para que no se vaya a las re chapas
    pos.add(speed); //Summarle la velocidad
    animate(); //Animar las particulas especiales

    //Para manejar si se puede agarrar. Si hay una agarrada, las demas no son agarrables. Algoritmo para agarrar
    if (agarrable) {
      if (ismouseover() && mousePressed) {
        agarrada = true;
      }
      if (!mousePressed) {
        agarrada = false;
      }
      if (agarrada) {
        followmouse();
      }
    }
  }

  //Aca creo una función que sea animate, solamente para correr la animación que refiere a la animación que afectan al display de la particula y NO al movimiento de ella.
  void animate() {
    /*Prefiero utilizar la estructura switch cada vez que tengo que elegir entre opciones enteras,
     viste que normalmente los modos o las cosas ya preprogramadas siempre se definen
     como un valor que no puede ser mas que 1 o 2  o 3 (digamos un entero puro y que no es el resultado de una cuenta)
     ,bueno, para estos momentos prefiero utilizar swicth*/
    switch(type) {
      //El case 0 no se incluye ya que es el por defecto del case 0.
    case 1:
      //Background color
      //1 = 2;
      //Background color Particule define el color del fondo.
      anima++;
      if (anima > 255) {
        anima = 0;
      }
      break;
    case 2:
      //Particle Color
      //Define el color de particula
      anima++;
      if (anima > 255) {
        anima = 0;
      }
      break;
    case 3:
      anima+=0.05;
      //OscilationParticle
      //aca la animación directamente depende del tamaño, así que no hace falta usar la variable anima.
      break;
    case 4:
      //Stroke Particle
      anima++;
      if (anima > 255) {
        anima = 0;
      }
      colorStroke = color(anima, saturation(colorshape2), brightness(colorshape2));
      break;
    case 5:
      //Speed Particle
      anima++;
      if (anima > size) {
        anima =  0;
      }
      break;
    case 6:
      //Position Particle
      if (animatedir) {
        size+=1;
      } else {
        size-=1;
      }
      if (size <= 0 ) {
        size = 0;
        animatedir = !animatedir;
      }
      if (size >= maxsize) {
        size = maxsize;
        animatedir = !animatedir;
      } 
      break;
    case 7:
      //Size Particle
      if (animatedir ) {
        size+=1;
      } else {
        size-=1;
      }
      if (size <= 0) {
        size = 0;
        animatedir = !animatedir;
      }
      if (size >= maxsize) {
        size = maxsize;
        animatedir = !animatedir;
      }
      break;
    case 8:
        //Aca iria la de la posición pero no tiene animación así que no prob
      break;
    }
  }
  //Función para determinar cuando se borra o cuando no
  boolean isDead() {
    if (pos.x < 0 || pos.x > width  || pos.y > height || pos.y < 0) {
      return true;
    } else {
      return false;
    }
  }
}