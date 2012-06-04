/**
 * Buttons. 
 * 
 * Click on one of the shapes to change
 * the background color. This example
 * demonstates a class for buttons.
 */

color currentcolor;

RectButton rect1, rect2;
RectButton[][] buttons = new RectButton[4][5];

boolean locked = false;

PFont font;
// The font must be located in the sketch's 
// "data" directory to load successfully
//font = loadFont("Ziggurat-HTF-Black-32.vlw");
//textFont(font);


/*
* UDP multicast address and port definitions
*/
UDP udp, udpTx;  // define the UDP object
String MyIpAddress;
String MULTICAST_IP       = "224.0.0.1";	// the remote IP address (multicast)
int LIGHT_PORT = 0xC738;
int THERMOSTAT_PORT_TX = 0xC739;
int THERMOSTAT_PORT_RX = 0xC73A;

void setup()
{
  size(900, 600);
  smooth();

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
  
  
  
  int ypos = 10;
  int xpos = 90;
  for(int i = 0; i < 4; i++)  
  {
    for(int j = 0; j < 5; j++)
    {
      buttons[i][j] = new RectButton(xpos, ypos, 50, buttoncolor, highlight);
      ypos = ypos + 60;
      text("Button" + (i*j), 15, 30); 
      fill(0, 102, 153);

    }
    ypos = 10;
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
  background(currentcolor);
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
 void buttonHandle(int x, int y)
 {
   println("Pressed: " + x + " and " + y);
   
   byte[] buffer = new byte[7];
   // Start
   buffer[0] = 'S';
   buffer[1] = '1';
   
   if(x == 0)
   {
     if(y == 0)
     {
       
     }
     else if(y == 1)
     {
       
     }
     else if(y == 2)
     {
       
     }
     else if(y == 3)
     {
       
       
     }
     else if(y == 4)
     {
       
     }
     else
     {
       println("Button error!");
     }
     // Data
     buffer[2] = byte(Dimmer);
     buffer[3] = byte(Dimmer>>8);
     buffer[4] = byte(LightId);
     
     
     
   }
   else if(x == 1)
   {
     if(y == 0)
     {
       
     }
     else if(y == 1)
     {
       
     }
     else if(y == 2)
     {
       
     }
     else if(y == 3)
     {
       
       
     }
     else if(y == 4)
     {
       
     }
     else
     {
       println("Button error!");
     }
     
   }
   else if(x == 2)
   {
     if(y == 0)
     {
       
     }
     else if(y == 1)
     {
       
     }
     else if(y == 2)
     {
       
     }
     else if(y == 3)
     {
       
       
     }
     else if(y == 4)
     {
       
     }
     else
     {
       println("Button error!");
     }
   }
   else if(x == 3)
   {
     if(y == 0)
     {
       
     }
     else if(y == 1)
     {
       
     }
     else if(y == 2)
     {
       
     }
     else if(y == 3)
     {
       
       
     }
     else if(y == 4)
     {
       
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
 }
