//Aquí se colocan todas las clases que se utilizan en mas de una escena. Por eso preferi ponerlas en una sola pestañas

//Mucho del codigo que esta aqui no se utiliza especificamente en todas las escenas, y será borrado y optimizado en la entrega final.

//Está clase sera utilizada tanto por las particulas de la escena 1 como por los nodos de la escena 2
class EllipseAgarrable {
  PVector pos; //posición
  float size; //Tamaño de la figura
  boolean agarrable ; // Si se puede agarrar
  boolean agarrada; //Si efectivamente esta agarrada
  EllipseAgarrable(float _x, float _y, float _size) {
    size = _size;
    pos = new PVector(_x, _y);
  }

  //setera la posición de la esfera igual que la del mouse
  void followmouse() {
    pos.x = mouseX;
    pos.y = mouseY;
  }

  //Leer si esta adentro del mouse
  boolean ismouseover() {
    float disX = pos.x - mouseX;
    float disY = pos.y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < size/2 ) {
      return true;
    } else {
      return false;
    }
  }
}
//Modulo para cambiar a distintas escenas.
class Scenechanger {
  float w, h;
  boolean isactive; //paquesemuestre o no se muestre
  Scenechanger() {
    w=120; //Ancho del cambiador
    h=30; //Alto del cambiador
    isactive = true; //Si se muestra o no se muestra
  }
  void display() {
    if (isactive) {
      //bueno esto es todo lo  necesario para que aparezca, es necesario comentarlo?
      rectMode(CORNERS);
      noStroke();
      fill(colores[1]);
      rect(0, 0, w, h);
      colorMode(RGB);
      for (int x=0; x<3; x++) {
        if (overCircle((x+1)*(w/5)+10, h/2, h/2)) {
          fill(#AA6C39); 
          if (mousePressed) {
            click.trigger();
            activescene = x+1;
          }
        } else if (x+1 == activescene) {
          fill(#8A2E60);
        } else {
          fill(#679B99);
        }
        ellipse((x+1)*(w/5)+10, h/2, h/2, h/2);
      }
      rectMode(CENTER);
    }
  }
  boolean overCircle(float x, float y, float diameter) {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } else {
      return false;
    }
  }
}

class Pause {
  //El objeto Pause nunca se usa solo, siempre se usa heredado
  boolean isactive; //Si esta o no pausado
  String titulo; // El titulo
  Pause(String _titulo) {
    isactive = true; //Arranca siempre pausado
    titulo = _titulo;
  }
  
  //Esto es como una pplantilla de pausa digamos
  void run() {
    strokeWeight(1);
    rectMode(CENTER);
    fill(colores[0], 200);
    rect(width/2, height/2, width, height);
    fill(colores[3]);
    textAlign(CENTER, CENTER);
    textSize(22);
    text(titulo, width/2, height * 1/10);
    textSize(14);
    
    
    //BOTON ese que dice pasar de escena
    float posbutonX = width/2; //posición en x boton
    float posbutonY = height * 7/10; //posición en y boton
    float butonw = 200; //ancho boton
    float butonh = 40; //alto boton
    if (overRect(posbutonX, posbutonY, butonw, butonh)) {
      fill(colores[1]);
      if (mousePressed) {
        click.trigger();
        isactive = false;
      }
    } else {
      fill(colores[2]);
    }
    rect(posbutonX, posbutonY, butonw, butonh);
    fill(colores[3]);
    text("Continuar...", posbutonX, posbutonY);
    textAlign(LEFT);
    text("Z,X,C: Seleccionar escenarios \nM: Mostrar/Ocultar cambiador de escenas\nP Pausa", width * 1 /4, height * 8/10);
  }
}
//Función que detecta si el mouse esta en el area de un rectangulo (siempre con el rectmode en center claro);
boolean overRect(float x, float y, float _w, float _h) {
  if (mouseX > x - _w/2 && mouseX < x + _w/2 && mouseY > y - _h /2 && mouseY < y + _h/2) {
    return true;
  } else {
    return false;
  }
}