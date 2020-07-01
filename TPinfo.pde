/* Trabajo practico Informatica Aplicada I //<>//
 Universidad nacional de las artes 
 Profesor : Esteban Calcagno
 Año de realización :2017
 
 Datos del desarrollador : 
 
 Nombre y apellido : Julián Daniel Puppo.
 Edad : 23.
 Pagina web : facebook\jpupper
 Documento 37.607.547 
 
 Este trabajo practico consiste en una investigación sobre los limites conceptuales de la imagen y la interfaz,
 entre el producto final y su relación con la manera de interactuar y/o crearlo */


//Librería para manejar asuntos de sonido
import ddf.minim.*;
//defino un objeto minim
Minim minim;
//defino un reproductor

AudioSample click; //Sample para objetos mas pequeños

int activescene = 0; /* Variable para manejar en que escena se encuentra .
 
 0 = menu;
 1 = escena 1
 2 = escena 2
 3 = escena 3 */

//Inicialización de objetos de escenas
Scene1 scene1;  //Crear objeto escena 1
Scene2 scene2;  //Crear objeto escena 2
Scene3 scene3;  //Crear objeto escena 3
Pantallafinal pantallafinal; //inicializar la pantalla final;
Scenechanger scenechanger; //Este es el modulito para cambiar de escenas
Mainmenu mainmenu; //Crear objeto menu

PFont fuente; //Fuente que sera global
boolean showframerate; //Este esta para ir checkeando el framerate a medida que se desarrolla

boolean isrecording; //Variable para manejar si esta grabando o no video (Sera borrada en la versión final)

//Array que almacena los colores de la interfaz  : 
color [] colores = {
  #071B1D, //color fondo;
  #236863, //color caja normal;
  #41837E, //color caja mouseover;
  #ffffff, //TEXTO
};

void settings() {
  //Tamaño y elección del render que permite operaciones en 3D
  size(600, 600, P3D);
}

void setup() {
  imageMode(CENTER); //Hago que las imagenes mas las cree a partir del centro.
  colorMode(HSB); //Elijo el color por tono, saturación y brillo
  hint(DISABLE_OPTIMIZED_STROKE); // Esta función corrige una especie de cosa rara que hace el P3D que es que los bordes se dibujan por encima de todo y queda feo. Si corres esta función ese bug se arregla. 

  minim = new Minim(this);
  fuente = createFont("Tahoma-Bold", 48);
   textFont(fuente);
  //Se inicializan los objetos de las escenas , el menu y el modulo
  scenechanger = new Scenechanger();  //Inicializar cambiador de escenas
  scene1 = new Scene1(); //Inicializar escena 1
  scene1.PS.init(); // este init funciona solo para cargar los sonidos que utiliza la escena 1
  scene2 = new Scene2();//Inicializar escena 2
  scene2.init(); //este init funciona solo para cargar los sonidos que utiliza la escena 2
  scene3 = new Scene3();//Inicializar escena 3
  scene3.init(); //inicializar musica escena 3
  mainmenu = new Mainmenu();//Inicializar escena menu
  pantallafinal = new Pantallafinal();//Inicializar escena 1




  click = minim.loadSample("sounds/click.wav"); //Cargar sample para sonido de click
  click.setGain(-20); //bajarle la ganancia al sonido del click
}

void draw() {
    
  //Decide que está corriendo.

  //Elegir distintas
  if (activescene == 0) {
    mainmenu.display();
  }
  if (activescene == 1) {
    scene1.run();
  }
  if (activescene == 2) {
    scene2.run();
  }
  if (activescene == 3) {
   scene3.run();
   // scene3.musica.play();
  } else {
    //scene3.musica.pause();
  }
  if (activescene == 4) {
    pantallafinal.display();
  }

  //para que printee el framerate y poder ir viendolo
  if (showframerate) {
    println("FRAMERATE", frameRate);
  }
  //No tiene sentido mostrar el widget de cambiador de escenas en el menu principal ya que desde ahí ya se pueden cambiar las escenas
  if (activescene != 0 && activescene != 4) {
    scenechanger.display();
  }
}

void keyPressed() {
  //Controles : 

  //Para que printee por consola el framerate, para así poder evaluar como funciona el programa
  if (key == 'f') {
    showframerate = !showframerate;
  }

  //Ir al menu principal
  if (key == '0') {
    activescene = 0;
  }

  //Ir a escena 1
  if (key == 'z') {
    activescene = 1;
  }
  //Ir a escena 2
  if (key == 'x') {
    activescene = 2;
  }
  //Ir a escena 3
  if (key == 'c') {
    println("Escena 3");
    activescene = 3;
  }
  //mostrar/ocultar cambiador de escenas
  if (key == 'm') {
    scenechanger.isactive = !scenechanger.isactive;
  }
  
  //boton de pausa
  if (key == 'p') {
    if (activescene == 1) {
      scene1.pause.isactive = !scene1.pause.isactive;
    } else if (activescene == 2) {
      scene2.pause.isactive = !scene2.pause.isactive;
    } else if (activescene == 3) {
      scene3.pause.isactive = !scene3.pause.isactive;
    }
  }
  //Resetear sistema de particulas de la escena 1
  if (activescene == 1) {
    if (key == 'r') {
      scene1.PS = new ParticleSystem();
    }
  }

  //Todos los siguientes controles son +de la escena 2 , así que pongo que si la escena activa es la 2 pueda correrlo
  if (activescene == 2) {
    
    //Borrar todos los efectos en la escena 2
    if (key == 'r') {
      scene2.clean();
    }
    //Borrar el ultimo efecto puesto
    if (key =='t') {
      scene2.removelast();
    }
    
    //Cambiar efectos activos
    if (key == '1') {
      scene2.activeffect = 1;
    }
    if (key == '2') {
      scene2.activeffect = 2;
    }
    if (key == '3') {
      scene2.activeffect = 3;
    }
    if (key == '4') {
      scene2.activeffect = 4;
    }
    if (key == '5') {
      scene2.activeffect = 5;
    }
  }
}