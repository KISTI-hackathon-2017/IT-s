#include "LedControl.h"
#include <LiquidCrystal_I2C.h>
#include <LiquidCrystal.h>
LedControl lc2=LedControl(8,10,9,4); 
LiquidCrystal_I2C lcd2(0x3F,16,2);

#include "Phpoc.h"
#include "SPI.h"

char server_name[] = "192.168.0.6";
int port = 8080;

int bus_num_len=0;
char bus_num2[5]="980 "; //half
char bus_data2[20]="empty";
char stop_data2[20]={0};
char time_ch[5]=" ";

void setup()
{
  Serial.begin(9600);
  lcd2.begin(16,2);
  lcd2.init();
  lcd2.backlight();
  
  
  for(int i=0; i<4; i++){              // 도트 매트릭스 0~3번
    lc2.shutdown(i,false);           // 디스플레이 초기화
    lc2.setIntensity(i,1);             // 도트 매트릭스 밝기 (매트릭스 번호, 밝기) 1~15
    lc2.clearDisplay(i);              // led 를 전체 꺼주는 함수
  }

  while(!Serial);

  Serial.println("Sendin GET request to web server");
  Phpoc.begin(PF_LOG_SPI | PF_LOG_NET);
  SPI.begin();
}

void loop(){
  PhpocClient client;
  String str1;
  int pattern = 7;
  int row, col, i;


  if(client.connect(server_name, port)) //연결시작
    Serial.println("Connected to server"); 
  else
    Serial.println("connection failed");

  client.print("POST /Hackaton/server.jsp");
  client.print("?data=Res,");
  client.println("df");
  client.println(" HTTP/1.1\r\n");
  client.println("Host: 192.168.0.6");
  client.println("Connection:close");
  client.print("\r\n\r\n");
  client.println();
  delay(5000);  
 
  while (client.available())
  {
    char c = client.read();
    Serial.print(c);
    str1.concat(c);
  }

  //str1  = "St  100,  13, 121:free, 70:free, 150,  14, 122:free,  97:free 14:42";
  

  str1.trim();
  Serial.print("str1: ");
  Serial.println(str1);
  
  str1.toCharArray(bus_num2,5,32);
  str1.toCharArray(bus_data2,5,37);
  str1.toCharArray(stop_data2,19,42);
  str1.toCharArray(time_ch,6,62);  
  
  String temp;
  temp=bus_num2;
  temp.trim();
  bus_num_len=temp.length()+1;
  temp.toCharArray(bus_num2,temp.length()+1);
  temp=bus_data2;
  temp.trim();
  temp.toCharArray(bus_data2,temp.length()+1);
  temp=stop_data2;
  temp.trim();
  temp.toCharArray(stop_data2,temp.length()+1);

  lcd2.clear();
  clean2();          // led 전체 꺼주기
  delay(500);

  if(bus_num2[1]!='x'){
    mark_busnum(bus_num2);
    set_lcd(bus_data2,stop_data2);
    delay(5000);
  }
  
}


/*********************************TEXT function**********************************/
void set_lcd(String bus_data, String stop_data) {

  if(bus_data<"15"){
    bus_data="free";
  }else if(bus_data<"25"){
    bus_data="half";
  }else{
    bus_data="full";
  }  

  lcd2.setCursor(0,0);
  lcd2.print("in:");
  lcd2.print(bus_data);
  lcd2.print("    ");
  lcd2.print(time_ch);
  lcd2.setCursor(0,1);
  lcd2.print(stop_data);
  /*for(int i=0;i<stop_data.length();i++){
   lcd1.scrollDisplayLeft();
   delay(500);
  }*/
   
}

/*******************************other function***********************************/
void clean2(){                       // 전체led를 꺼주는 함수
  for(int i = 0; i < 4; i++)
    lc2.clearDisplay(i);// clear screen
}

void mark_busnum(char bus_num[]){
  
  for(int i=0;i<bus_num_len;i++){
    if(bus_num[i]=='0'){
      num0(i);
    }else if(bus_num[i]=='1'){
      num1(i);
    }else if(bus_num[i]=='2'){
      num2(i);
    }else if(bus_num[i]=='3'){
      num3(i);
    }else if(bus_num[i]=='4'){
      num4(i);
    }else if(bus_num[i]=='5'){
      num5(i);
    }else if(bus_num[i]=='6'){
      num6(i);
    }else if(bus_num[i]=='7'){
      num7(i);
    }else if(bus_num[i]=='8'){
      num8(i);
    }else if(bus_num[i]=='9'){
      num9(i);
    }else{
      blank(i);
  }
  }
}

void num1(int i){
  lc2.setColumn(i,2,0xff);
  lc2.setColumn(i,3,0xff);  
}
void num2(int i){
  lc2.setRow(i,0,0x7E);
  lc2.setRow(i,1,0x7E);
  lc2.setRow(i,2,0xC);
  lc2.setRow(i,3,0x18);
  lc2.setRow(i,4,0x30);
  lc2.setRow(i,5,0x66);
  lc2.setRow(i,6,0x7C);
  lc2.setRow(i,7,0x38);
}
void num3(int i){
  lc2.setRow(i,0,0x3E);
  lc2.setRow(i,1,0x7E);
  lc2.setRow(i,2,0x60);
  lc2.setRow(i,3,0x3E);
  lc2.setRow(i,4,0x3E);
  lc2.setRow(i,5,0x60);
  lc2.setRow(i,6,0x7E);
  lc2.setRow(i,7,0x3E);
}
void num4(int i){
  lc2.setRow(i,0,0x30);
  lc2.setRow(i,1,0x30);
  lc2.setRow(i,2,0xff);
  lc2.setRow(i,3,0xff);
  lc2.setRow(i,4,0x33);
  lc2.setRow(i,5,0x36);
  lc2.setRow(i,6,0x3c);
  lc2.setRow(i,7,0x38);
}
void num5(int i){
  lc2.setRow(i,0,0x3E);
  lc2.setRow(i,1,0x7E);
  lc2.setRow(i,2,0x60);
  lc2.setRow(i,3,0x7E);
  lc2.setRow(i,4,0x3E);
  lc2.setRow(i,5,0x6);
  lc2.setRow(i,6,0x7E);
  lc2.setRow(i,7,0x7E);
}
void num6(int i){
  lc2.setRow(i,0,0x3C);
  lc2.setRow(i,1,0x7E);
  lc2.setRow(i,2,0x66);
  lc2.setRow(i,3,0x7E);
  lc2.setRow(i,4,0x3E);
  lc2.setRow(i,5,0xC);
  lc2.setRow(i,6,0x18);
  lc2.setRow(i,7,0x30);
}
void num7(int i){
  lc2.setRow(i,0,0x60);
  lc2.setRow(i,1,0x60);
  lc2.setRow(i,2,0x60);
  lc2.setRow(i,3,0x60);
  lc2.setRow(i,4,0x66);
  lc2.setRow(i,5,0x66);
  lc2.setRow(i,6,0x7E);
  lc2.setRow(i,7,0x7E);
}
void num8(int i){
  lc2.setRow(i,0,0x3C);
  lc2.setRow(i,1,0x7E);
  lc2.setRow(i,2,0x66);
  lc2.setRow(i,3,0x7E);
  lc2.setRow(i,4,0x7E);
  lc2.setRow(i,5,0x66);
  lc2.setRow(i,6,0x7E);
  lc2.setRow(i,7,0x3C);
}
void num9(int i){
  lc2.setRow(i,0,0x60);
  lc2.setRow(i,1,0x60);
  lc2.setRow(i,2,0x60);
  lc2.setRow(i,3,0x7C);
  lc2.setRow(i,4,0x7E);
  lc2.setRow(i,5,0x66);
  lc2.setRow(i,6,0x7E);
  lc2.setRow(i,7,0x3C);
}
void num0(int i){
  lc2.setRow(i,0,0x3C);
  lc2.setRow(i,1,0x7E);
  lc2.setRow(i,2,0x66);
  lc2.setRow(i,3,0x66);
  lc2.setRow(i,4,0x66);
  lc2.setRow(i,5,0x66);
  lc2.setRow(i,6,0x7E);
  lc2.setRow(i,7,0x3C);
}
void blank(int i){
  for(int j=0;j<7;j++){
    lc2.setRow(i,i,0);
  }
}

