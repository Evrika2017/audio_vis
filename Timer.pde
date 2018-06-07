class Timer {


int savedTime;
int totalTime = 50000;//total time of gameplay before enemies appears/
int  passedTime  = 0;
int seconds;


void makeTimer() {
  savedTime = millis();//time in milliseconds.

 
}

void showTimer() {
  // Calculate how much time has passed
     passedTime = millis() + savedTime;
  
  

}
}//end of class

