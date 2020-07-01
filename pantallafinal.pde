//Clase para la pantalla final

class Pantallafinal {

  Pantallafinal() {
  }
  
  //Función para mostrar
  void display() {
    
    /*Y bueno esto es medio repetitivo a lo otro, pero para la prox le meto mas funciones y clases. 
    lo que estaría bueno saber programar es tipo lo eventos, así como los keypressed,mousepressed, y demas pero para botones, me ahorraria una bocha de codigo.
    Por que lo jodido de eso es crear una clase que tenga botones y leer si los botones estan o no apretados y demas, pasa que como cada boton hace una cosa distinta entonces como que es medio complicado
    aunque podría, pero ahora para este como que ya fue.
    */
    background(0);
    strokeWeight(1);
    rectMode(CENTER);
    fill(colores[0], 200);
    rect(width/2, height/2, width, height);
    fill(colores[3]);
    textAlign(CENTER);
    textSize(22);
    text("PANTALLA FINAL", width/2, height * 1/10+20);
    textSize(14);
    text("Bueno, hasta acá llega la aventura.\n En realidad esta placa de pantalla final esta porque tiene que estar, \n así que voy a cumplir cada item.\n Espero que te haya gustado la movida\n y si te gusto, bueno, podes buscarme en facebook o la que pinte.", width/2, height * 2/5);
    
    float posbutonX = width/2;
    float posbutonY = height * 7/10;
    float butonw = 200;
    float butonh = 40;
    if (overRect(posbutonX, posbutonY, butonw, butonh)) {
      fill(colores[1]);
      if (mousePressed) {
        click.trigger();
        activescene = 0;
      }
    } else {
      fill(colores[2]);
    }
    rect(posbutonX, posbutonY, butonw, butonh);
    fill(colores[3]);
    text("Volver a la pantalla inicial", posbutonX, posbutonY);

  }
  boolean overRect(float x, float y, float _w, float _h) {
    if (mouseX > x - _w/2 && mouseX < x + _w/2 && mouseY > y - _h /2 && mouseY < y + _h/2) {
      return true;
    } else {
      return false;
    }
  }
}