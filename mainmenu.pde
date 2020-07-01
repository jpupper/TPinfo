
//Clase para el menu principal
class Mainmenu {

  PImage [] imgs = new PImage[3]; //Array de las imagenes de cada escena
  Mainmenu() {
    //Cargar las imagenes de las escenas
    for (int x=0; x<imgs.length; x++) {
      String location = str(x+1)+".jpg";
      imgs[x] = loadImage(location);
    }
  }
  //La función display es la función para mostrar siempre las cosas eh
  void display() {
    background(colores[0]);
    textAlign(CENTER, CENTER);
    textSize(60);
    strokeWeight(3);
    stroke(0);

    fill(colores[1]);
    //strokeWeight(2);

    //TITULO :
    float sep = 130;
    //Este es para la formita esa re loca re copada que tiene
    beginShape();
    vertex(0, 0);
    vertex(width /2-sep, height * 1.6/9);
    vertex(width /2+sep, height * 1.6/9);
    vertex(width, 0);
    endShape(CLOSE);    
    fill(colores[3]);
    text("GUIPPER", width /2, height * 0.5/9);
    
    textSize(16);
    text("La union entre la imagen y la interfaz", width /2, height * 1.2/9);  

    textAlign(LEFT);
    textSize(18);
    
    //SINOPSIS:
    text("Guipper pretende explorar los limites\nentre la imagen y la interfaz,\n3 escenas que se posicionan\nen el limite entre ambas.", 30, height * 2/9+50);
    float offsety = 70;
    float posydatos = height * 4/9 + offsety;
    float posytriangle = height * 5.5/9 + offsety;
    //DATOS DEL ALUMNO:
    float sep2 = 40;
    float sep3 = 110;
    fill(colores[1]);
    beginShape();

    vertex(0, posytriangle-sep3);
    vertex(width *1.7/3, posytriangle-sep2);
    vertex(width *1.7/3, posytriangle+sep2);
    vertex(0, posytriangle +sep3);
    endShape(CLOSE);  

    fill(colores[3]);
    textSize(22);

    text("\nUNA \nAlumno: Julián Puppo\nMateria: Informatica Aplicada I\nCatedrá: Calcagno\nAño: 2017 ", 30, posydatos);

    imageMode(CENTER);
    for (int x=0; x<imgs.length; x++) {

      float posx = width * 5.5/7 ;
      float posy =  map(x, 0, 2, height * 2.7/9, height * 6.6/9);

      strokeWeight(3);
      stroke(0);
      //Botoncito de las escenas
      if (overRect(posx, posy, imgs[x].width, imgs[x].height)) {
        stroke(0);
        fill(colores[2]);
        if (mousePressed ) {
          click.trigger();
          activescene = x+1;
        }
      } else {
        fill(colores[1]);
       // stroke(255, 0, 0);
      }
      rectMode(CENTER);
      rect(posx, posy, imgs[x].width * 1.3, imgs[x].height * 1.3);
      image(imgs[x], posx, posy);

      fill(255);
      textAlign(CENTER, CENTER);
      text("Escena "+str(x+1), posx, posy+60);
    }
  }
}