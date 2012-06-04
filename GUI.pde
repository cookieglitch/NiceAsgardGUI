/**
 * The Nice Asgard Project - GUI
 * 
 * Uses code from TI Home Automation GUI example.
 *
 * @author John Tiernan
 * @version 4 June 2012
 */
// import UDP library
import hypermedia.net.*;

color currentcolor;

RectButton rect1, rect2;
RectButton[][] buttons = new RectButton[4][5];

boolean locked = false;

PFont font;

/*
String[] label = new String[20];
label[0] = "CLOSE0";
label[1] = "OPEN0";
label[2] = "FILM0";
label[3] = "DAY0";
label[4] = "NIGHT0";

label[5] = "CLOSE1";
label[6] = "OPEN1";
label[7] = "FILM1";
label[8] = "DAY1";
label[9] = "NIGHT1";

label[10] = "CLOSE2";
label[11] = "OPEN2";
label[12] = "FILM2";
label[13] = "DAY2";
label[14] = "NIGHT2";

label[15] = "CLOSE3";
label[16] = "OPEN3";
label[17] = "FILM3";
label[18] = "DAY3";
label[19] = "NIGHT3";
*/

String label_temp = "OPEN0";

/*
* UDP multicast address and port definitions
*/
UDP udp, udpTx;  // define the UDP object
String MyIpAddress = ""; //Leave blank if using multicast
String MULTICAST_IP       = "224.0.0.1";	// the remote IP address (multicast)
int LIGHT_PORT = 0xC738;
int THERMOSTAT_PORT_TX = 0xC739;
int THERMOSTAT_PORT_RX = 0xC73A;

void setup()
{
  size(900, 600);
  smooth();
  
  colorMode(RGB);
  
  // The font must be located in the sketch's 
  // "data" directory to load successfully
  font = loadFont("AdobeHebrew-Bold-48.vlw");
  textFont(font, 24);
  textAlign(LEFT, TOP);

  color baseColor = color(102);
  currentcolor = baseColor;

  // Define and create circle button
  color buttoncolor = color(204);
  color highlight = color(#FF0000);

  //BUTTON 1
  // Define and create rectangle button
  buttoncolor = color(102);
  highlight = color(51); 
  //rect1 = new RectButton(90, 10, 50, buttoncolor, highlight);

  // Define and create rectangle button
  buttoncolor = color(102);
  highlight = color(51); 
  //rect2 = new RectButton(90, 70, 50, buttoncolor, highlight);
  
  
  
  int ypos = 50;
  int topOffset = ypos;
  int xpos = 130;
  for(int i = 0; i < 4; i++)  
  {
    for(int j = 0; j < 5; j++)
    {
      buttons[i][j] = new RectButton(xpos, ypos, 50, buttoncolor, highlight);
      ypos = ypos + 90;
    }
    ypos = topOffset;
    xpos = xpos + 220;
  }
  
  // create a new datagram connection on port THERMOSTAT_PORT
  // and wait for incomming messages  
  udp = new UDP( this, THERMOSTAT_PORT_RX, MULTICAST_IP);  
  udp.log( true ); 		// <-- printout the connection activity  
  udp.listen( true );  
  
  // If the user didn't configure an IP address then just use the 
  // mutlicast address.  the UDP stack will then choose the default
  // network adapter.
  if(MyIpAddress.length() == 0)
  {
    MyIpAddress = MULTICAST_IP;
  }
  println("add:"+ MyIpAddress);
  udpTx = new UDP( this, LIGHT_PORT, MyIpAddress); 
  println(udp.isJoined());
  println(udp.isMulticast());
}

void draw()
{
  //background(currentcolor);
  background(#000000);
  stroke(255);
  update(mouseX, mouseY);
  //rect1.display();
  //rect2.display();
  for(int i = 0; i < 4; i++)  
  {
    for(int j = 0; j < 5; j++)
    {
      buttons[i][j].display();
    }
  }
  
  drawText();
}

void update(int x, int y)
{
  if(locked == false) {
    //rect1.update();
    //rect2.update();
    for(int i = 0; i < 4; i++)  
    {
      for(int j = 0; j < 5; j++)
      {
        buttons[i][j].update();
      }
    } 
  } 
  else {
    locked = false;
  }

  if(mousePressed) {
    /*
    if(rect1.pressed()) {
      currentcolor = rect1.basecolor;
    } 
    else if(rect2.pressed()) {
      currentcolor = rect2.basecolor;
    }
    */
    int j, i;
    for(i = 0; i < 4; i++)  
    {
      
      for(j = 0; j < 5; j++)
      {
        if(buttons[i][j].pressed())
        {
         //currentcolor = rect2.basecolor;
         buttonHandle(i, j);
         i = 5;
         j = 6;
        }
      }
    } 
    
  }
  
}


class Button
{
  int x, y;
  int size;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;   

  void update() 
  {
    if(over()) {
      currentcolor = highlightcolor;
    } 
    else {
      currentcolor = basecolor;
    }
  }

  boolean pressed() 
  {
    if(over) {
      locked = true;
      return true;
    } 
    else {
      locked = false;
      return false;
    }    
  }

  boolean over() 
  { 
    return true; 
  }

  boolean overRect(int x, int y, int width, int height) 
  {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }

  boolean overCircle(int x, int y, int diameter) 
  {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } 
    else {
      return false;
    }
  }

}


class RectButton extends Button
{
  RectButton(int ix, int iy, int isize, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overRect(x, y, size, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    fill(currentcolor);
    rect(x, y, size, size);
    
  }
}

/**
 * Button handler
 *
 * @param x column ID
 * @param y column ID
 * @return none
 */
 
 //TODO Fix bug? Called too many times for one press
 void buttonHandle(int x, int y)
 {
   println("Pressed: " + x + " and " + y);
   
   byte[] buffer = new byte[7];
   // Start
   buffer[0] = 'S';
   buffer[1] = '1';
   
   /**
    * Packet structure
    *
    * buffer[0] - Unrelated
    * buffer[1] - Unrelated
    * buffer[2] - int state = stateBuffer[2];
    * buffer[3] - Light lev variable (Unused)
    * buffer[4] - int roomID = stateBuffer[4];
    * buffer[5] - Unrelated
    * buffer[6] - Unrelated
    */
   
   //Work out which option it was
   if(x == 0)
   {
     //Room ID
     buffer[4] = 0;
     
     
     if(y == 0)
     {
       buffer[2] = CLOSE0;
     }
     else if(y == 1)
     {
       buffer[2] = OPEN0;
     }
     else if(y == 2)
     {
       buffer[2] = FILM0;
     }
     else if(y == 3)
     {
       buffer[2] = DAY0;
     }
     else if(y == 4)
     {
       buffer[2] = NIGHT0;
     }
     else
     {
       println("Button error!");
     }     
   }
   else if(x == 1)
   {
     //Room ID
     buffer[4] = 1;
     
     if(y == 0)
     {
       buffer[2] = CLOSE1;
     }
     else if(y == 1)
     {
       buffer[2] = OPEN1;
     }
     else if(y == 2)
     {
       buffer[2] = FILM1;
     }
     else if(y == 3)
     {
       buffer[2] = DAY1;
     }
     else if(y == 4)
     {
       buffer[2] = NIGHT1;
     }
     else
     {
       println("Button error!");
     }
     
   }
   else if(x == 2)
   {
     //Room ID
     buffer[4] = 2;
     
     if(y == 0)
     {
       buffer[2] = CLOSE2;
     }
     else if(y == 1)
     {
       buffer[2] = OPEN2;
     }
     else if(y == 2)
     {
       buffer[2] = FILM2;
     }
     else if(y == 3)
     {
       buffer[2] = DAY2;
     }
     else if(y == 4)
     {
       buffer[2] = NIGHT2;
     }
     else
     {
       println("Button error!");
     }
   }
   else if(x == 3)
   {
     //Room ID
     buffer[4] = 3;
     
     if(y == 0)
     {
       buffer[2] = 99;
     }
     else if(y == 1)
     {
       buffer[2] = 99;
     }
     else if(y == 2)
     {
       buffer[2] = 99;
     }
     else if(y == 3)
     {
       buffer[2] = 99;
     }
     else if(y == 4)
     {
       buffer[2] = 99;
     }
     else
     {
       println("Button error!");
     }
   }
   else
   {
    //What the funk?! 
     println("Button error!");
   }
   // END
   buffer[5] = 'S';
   buffer[6] = '2';
  
   String message = new String(buffer);  
   int port        = LIGHT_PORT;         // the destination port
     
   udpTx.send( message, MULTICAST_IP, port );
   println(buffer);
 }
 
 void drawText()
 {
   
  //Add labels
  color textC = color(#FFFFFF);
  fill(textC);
  //text(label_temp, 700, 400);
  //println("text!");
  //text("more text", 10, 10);
  
  //Logo/Branding
  text("The Nice Asgard Project", 600, 500);
  text("John Tiernan, element14, Texas Instruments", 400, 550);
  
  PImage TIlogo;
  String TI_LINK = "http://www.ti.com"; 
  TIlogo = loadImage("images/TI_Logo.jpg");
  image(TIlogo, 10, 500);
  
  //Room 0
  text("Room 0", 40, 10);
  text("CLOSE - 0", 10, 70);
  text("OPEN - 0", 10, 160);
  text("FILM - 0", 10, 250);
  text("DAY - 0", 10, 340);
  text("NIGHT - 0", 10, 430);
  
  //Room 1
  text("Room 1", 260, 10);
  text("CLOSE - 1", 230, 70);
  text("OPEN - 1", 230, 160);
  text("FILM - 1", 230, 250);
  text("DAY - 1", 230, 340);
  text("NIGHT - 1", 230, 430);
  
  //Room 2
  text("Room 2", 480, 10);
  text("CLOSE - 2", 450, 70);
  text("OPEN - 2", 450, 160);
  text("FILM - 2", 450, 250);
  text("DAY - 2", 450, 340);
  text("NIGHT - 2", 450, 430);
  
  //Room 3
  text("Room 3", 700, 10);
  text("CLOSE - 3", 670, 70);
  text("OPEN - 3", 670, 160);
  text("FILM - 3", 670, 250);
  text("DAY - 3", 670, 340);
  text("NIGHT - 3", 670, 430);
  fill(#000000);
 }
