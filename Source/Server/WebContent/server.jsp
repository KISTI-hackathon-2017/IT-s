<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>

<%! String KEY = "=YT%2FvelLrJ7J3EdnrA%2Fsz9%2FEp6n5upP3yf%2BWILAbzd1NG7fKRCIpAiVj9OLsGOFV39JL43DTnkCf%2B5d3A6WiQfw%3D%3D";
   //String KEY = "=tPyPqzllwnK1WCv2Ha2OCziPYGzm%2FSU4M9apmnhsErcB4oPIbQeBTiNIgnkbTvNUKBXADBoKoSswVYcI56KFxw%3D%3D";
   
   String flag[] = {"null", "null"}; //버스가 출발했는지 여부
   String message_send = null; //전송할 데이터 담을 변수

   int ans = 0;
%>

<%
   //main함수
   
   //String message = request.getParameter("data"); //데이터 수신
   //System.out.println(message);
   
   //out.println(send); //클라이언트에게 데이터전송
   
   String clientIP  = request.getRemoteAddr();
   System.out.println("접속한 IP:\t" + clientIP);
   
   if(clientIP.compareTo("192.168.0.5") == 0) //첫번째 아두이노 IP설정
   		message_send = request(); //ㅁㅔ시지 요청
      
   //System.out.println("현재시간은 " + s_time);
   
   out.println(message_send); //전송
	
   System.out.println("보낸 데이터: " + message_send);
%>

<%!
public String request()
{
   try
   {
      //특정 정류소의 특정노선의 도착예정정보를 조회 (정류소ID와 노선ID,정류소 순번을 통해서)
       //exps1:지수평활 도착예정시간, kals1:기타1 도착예정시간, neus1:기타2 도착예정시간
       //reride_Num1:현재 재차인원
       //101000007: 서울역 정류소ID
       
       //100100549: 100번 버스ID
       //100100029: 150번 버스
       //100100030: 151번 버스ID
       //100100031: 152번 버스ID
       //100100034: 162번 버스ID -> api요청시 제대로 못받아와서 제외함
       //100100185: 1711번 버스ID
       
       //100100076: 500번 버스ID
       //100100077: 501번 버스ID
       //100100410: 502번 버스ID
       //100100079: 504번 버스ID
       //100100081: 506번 버스ID
       //100100447: 7016번 버스ID
       
      String bus_info[][] =  //버스ID, 시간, 버스번호, 인원, 주요정류소1, 주요정류소2, index1, index2, state1, state2
    	  {{"100100549", null, "100", null, null, null, "121", "70", null, null}, 
    	             {"100100029", null, "150", null, null, null, "122", "97", null, null}, 
    	             {"100100030", null, "151", null, null, null, "96", "63", null, null}, 
    	             {"100100031", null, "152", null, null, null, "130", "77", null, null}, 
    	             //{"100100034", null},
    	             {"100100185", null, "1711", null, null, null, "40", "42", null, null}, 
    	             {"100100076", null, "500", null, null, null, "32", "71", null, null}, 
    	             {"100100077", null, "501", null, null, null, "47", "57", null, null}, 
    	             {"100100410", null, "502", null, null, null, "129", "81", null, null}, 
    	             {"100100079", null, "504", null, null, null, "84", "43", null, null}, 
    	             {"100100081", null, "506",null, null, null, "68", "52", null, null}, 
    	             {"100100447", null, "7016",null, null, null, "9", "11", null, null} };
       
       String bus_num[][] = //버스ID, 순서(order)
          {   {"100100549", "75"}, //100
             {"100100029", "88"}, //150
             {"100100030", "59"}, //151
             {"100100031", "99"}, //152
             //{"100100034", "55"}, //162
             {"100100185", "45"}, //1711
             {"100100076", "39"}, //500
             {"100100077", "24"}, //501
             {"100100410", "65"}, //502
             {"100100079", "43"}, //504
             {"100100081", "44"}, //506
             {"100100447", "43"} }; //7016
       
       Calendar time = Calendar.getInstance();
       String string_time;
       
       
       Calendar Time = Calendar.getInstance();
       String s_time = String.format("%2s:%2s", Integer.toString(Time.get(Calendar.HOUR_OF_DAY)), 
    		   Integer.toString(Time.get(Calendar.MINUTE)));
       
       string_time = hour_to_string(time.get(Calendar.HOUR_OF_DAY));
       
       //System.out.println("현재시각: " + string_time);
             
      int i, j;
      String send_data = null;
      String tmp[] = new String[10];
      
       for(i = 0; i < 11; i++) //버스시간 받아옴. 분초떼고 15.4이런 형태로 변환
       {
          parsing_arrivetime(bus_num[i][0], bus_num[i][1], bus_info, i, string_time); //버스도착시간 받음
          data_transform(bus_info, i); //분후 떼고 15.4 이런 형태로 변환
          
       }
       
       //System.out.println("정렬전");
       for(i = 0; i < 11; i++) //버스시간 받아옴
       {
          for(j = 0; j < 4; j++)
             System.out.print(bus_info[i][j] + " ");
          
          System.out.println();
       }
      
       selectsort(bus_info); //정렬
        
       System.out.println("정렬후: ");
       for(i = 0; i < 11; i++) 
       {
          for(j = 0; j < 10; j++)
             System.out.print(bus_info[i][j] + " ");   

          System.out.println();
       }
       
       /*버스가 출발했을 경우, flag값 null로 초기화*/
   	for (i = 0; i < 2; i++)
   	{
   		ans = 0;
   		for (j = 0; j < 11; j++)
   		{
   			if (bus_info[j][1].compareTo("0") == 0)
   			{
   				if (flag[i].compareTo(bus_info[j][2]) == 0)
   					ans = 1;
   			}
   		}

   		if (ans == 0)
   			flag[i] = "null";
   	}

   	for (i = 0; i < 2; i++)
	{
		if (bus_info[i][1].compareTo("0") == 0)
		{
			if (flag[i].compareTo("null") != 0)
			{
				for (j = 0; j < 11; j++)
				{
					if (flag[i].compareTo(bus_info[j][2]) == 0) //flag랑 같은 값이있으면
					{
						if (j == i)
							break;

						else if (i > j)
						{
							tmp[0] = bus_info[i][0]; //버스id
							tmp[1] = bus_info[i][1]; //시간
							tmp[2] = bus_info[i][2]; //버스번호
							tmp[3] = bus_info[i][3]; //인원
							tmp[4] = bus_info[i][4]; //첫번째 주요정류소
							tmp[5] = bus_info[i][5]; //두번째 주요정류소
							tmp[6] = bus_info[i][6]; //두번째 주요정류소
							tmp[7] = bus_info[i][7]; //두번째 주요정류소
							tmp[8] = bus_info[i][8]; //두번째 주요정류소
							tmp[9] = bus_info[i][9]; //두번째 주요정류소

							bus_info[i][0] = bus_info[j][0];
							bus_info[i][1] = bus_info[j][1];
							bus_info[i][2] = bus_info[j][2];
							bus_info[i][3] = bus_info[j][3];
							bus_info[i][4] = bus_info[j][4];
							bus_info[i][5] = bus_info[j][5];
							bus_info[i][6] = bus_info[j][6];
							bus_info[i][7] = bus_info[j][7];
							bus_info[i][8] = bus_info[j][8];
							bus_info[i][9] = bus_info[j][9];

							bus_info[j][0] = tmp[0];
							bus_info[j][1] = tmp[1];
							bus_info[j][2] = tmp[2];
							bus_info[j][3] = tmp[3];
							bus_info[j][4] = tmp[4];
							bus_info[j][5] = tmp[5];
							bus_info[j][6] = tmp[6];
							bus_info[j][7] = tmp[7];
							bus_info[j][8] = tmp[8];
							bus_info[j][9] = tmp[9];

							
							tmp[0] = bus_info[j][2];

							flag[j] = bus_info[j][2];
						}

						else if (i < j)
						{
							tmp[0] = bus_info[i][0]; //버스id
							tmp[1] = bus_info[i][1]; //시간
							tmp[2] = bus_info[i][2]; //버스번호
							tmp[3] = bus_info[i][3]; //인원
							tmp[4] = bus_info[i][4]; //첫번째 주요정류소
							tmp[5] = bus_info[i][5]; //두번째 주요정류소
							tmp[6] = bus_info[i][6]; //두번째 주요정류소
							tmp[7] = bus_info[i][7]; //두번째 주요정류소
							tmp[8] = bus_info[i][8]; //두번째 주요정류소
							tmp[9] = bus_info[i][9]; //두번째 주요정류소

							bus_info[i][0] = bus_info[j][0];
							bus_info[i][1] = bus_info[j][1];
							bus_info[i][2] = bus_info[j][2];
							bus_info[i][3] = bus_info[j][3];
							bus_info[i][4] = bus_info[j][4];
							bus_info[i][5] = bus_info[j][5];
							bus_info[i][6] = bus_info[j][6];
							bus_info[i][7] = bus_info[j][7];
							bus_info[i][8] = bus_info[j][8];
							bus_info[i][9] = bus_info[j][9];

							bus_info[j][0] = tmp[0];
							bus_info[j][1] = tmp[1];
							bus_info[j][2] = tmp[2];
							bus_info[j][3] = tmp[3];
							bus_info[j][4] = tmp[4];
							bus_info[j][5] = tmp[5];
							bus_info[j][6] = tmp[6];
							bus_info[j][7] = tmp[7];
							bus_info[j][8] = tmp[8];
							bus_info[j][9] = tmp[9];

							//tmp[0] = bus_info[j][2];
							//flag[1] = bus_info[j][2];
						}
					}
				}
			}
			else
				flag[i] = bus_info[i][2];
		}
	}

       if(flag[0].compareTo("null") == 0 && flag[1].compareTo("null") == 0)
          return String.format("St xxxx,xxxx,xxxx,xxxx,xxxx,xxxx,xxxx,xxxx");
       
       else if(flag[0].compareTo("null") != 0 && flag[1].compareTo("null") == 0)
       {
    	   System.out.println(String.format("버스번호: %4d, 도착시간: %4d, 재차인원: %4d, 첫번째 주요정류소ID: %4d, 예상상태: %4s, 두번째 주요정류소ID: %4d, 예상상태: %4s",
    			   Integer.parseInt(flag[0]), Integer.parseInt(bus_info[0][1]),  
    			   Integer.parseInt(bus_info[0][3]), Integer.parseInt(bus_info[0][6]), bus_info[0][8],  
    			   Integer.parseInt(bus_info[0][7]), bus_info[0][9]));
    	   
            return String.format("St %4d,%4d,%3d:%4s,xxxx,xxxx,xxxx,xxxx", 
                  Integer.parseInt(flag[0]), Integer.parseInt(bus_info[0][3]),
                  Integer.parseInt(bus_info[0][6]), bus_info[0][8],
                  Integer.parseInt(bus_info[0][7]), bus_info[0][9]) + " " + s_time;
       }
       
       else if(flag[0].compareTo("null") == 0 && flag[1].compareTo("null") != 0)
       {
    	   System.out.println(String.format("버스번호: %4d, 도착시간: %4d, 재차인원: %4d, 첫번째 주요정류소ID: %4d, 예상상태: %4s, 두번째 주요정류소ID: %4d, 예상상태: %4s",
    			   Integer.parseInt(flag[1]), Integer.parseInt(bus_info[1][1]),   
    			   Integer.parseInt(bus_info[1][3]), Integer.parseInt(bus_info[1][6]), bus_info[1][8],  
    			   Integer.parseInt(bus_info[1][7]), bus_info[1][9]));
    	   
          return String.format("St xxxx,xxxx,xxxx,xxxx,%4d,%4d,%4d:%4s,%3d:%4s",
               Integer.parseInt(flag[1]), Integer.parseInt(bus_info[1][3]),
               Integer.parseInt(bus_info[1][6]), bus_info[1][8],
               Integer.parseInt(bus_info[1][7]), bus_info[1][9]) + " " + s_time;   
       }
       
       else if(flag[0].compareTo("null") != 0 && flag[1].compareTo("null") != 0)
       {
    	   System.out.println(String.format("버스번호: %4d, 도착시간: %4d, 재차인원: %4d, 첫번째 주요정류소ID: %4d, 예상상태: %4s, 두번째 주요정류소ID: %4d, 예상상태: %4s",
    			   Integer.parseInt(flag[0]), Integer.parseInt(bus_info[0][1]),   
    			   Integer.parseInt(bus_info[0][3]), Integer.parseInt(bus_info[0][6]), bus_info[0][8],  
    			   Integer.parseInt(bus_info[0][7]), bus_info[0][9]));
    	   
    	   System.out.println(String.format("버스번호: %4d, 도착시간: %4d, 재차인원: %4d, 첫번째 주요정류소ID: %4d, 예상상태: %4s, 두번째 주요정류소ID: %4d, 예상상태: %4s",
    			   Integer.parseInt(flag[1]), Integer.parseInt(bus_info[1][1]),   
    			   Integer.parseInt(bus_info[1][3]), Integer.parseInt(bus_info[1][6]), bus_info[1][8],  
    			   Integer.parseInt(bus_info[1][7]), bus_info[1][9]));
    	   
            return String.format("St %4d,%4d,%4d:%4s,%3d:%4s,%4d,%4d,%4d:%4s,%4d:%4s", 
                  Integer.parseInt(flag[0]), Integer.parseInt(bus_info[0][3]), 
                  Integer.parseInt(bus_info[0][6]), bus_info[0][8],
                  Integer.parseInt(bus_info[0][7]), bus_info[0][9],
                  
                  Integer.parseInt(flag[1]), Integer.parseInt(bus_info[1][3]), 
                  Integer.parseInt(bus_info[1][6]), bus_info[1][8],
                  Integer.parseInt(bus_info[1][7]), bus_info[1][9]) + " " + s_time;
       }
       
       else
          return "flag 출력오류";
   }
   
   catch(Exception e)
   {
      //System.out.println(e.getMessage());
      e.printStackTrace();
   	  return "error founded!";
   }
}
%>

<%! 
   public void parsing_arrivetime(String bus_id, String order, String data[][], int idx, String time) throws IOException
   {
	  //System.out.println("request 실행됨");
      String tmp = null;
      String str = null;
      String arrive_time = null;
      
      StringBuilder urlBuilder = new StringBuilder("http://ws.bus.go.kr/api/rest/arrive/getArrInfoByRoute"); /*URL*/
      BufferedReader rd;
      StringBuilder sb = new StringBuilder();
       
      urlBuilder.append("?" + URLEncoder.encode("ServiceKey","UTF-8") + KEY); /*Service Key*/
      urlBuilder.append("&" + URLEncoder.encode("stId","UTF-8") + "=" + URLEncoder.encode("101000007", "UTF-8")); //*서울역정류소 ID*
      urlBuilder.append("&" + URLEncoder.encode("busRouteId","UTF-8") + "=" + URLEncoder.encode(bus_id, "UTF-8")); /*버스ID*/
      urlBuilder.append("&ord=" + order);
       
       URL url = new URL(urlBuilder.toString());
       HttpURLConnection conn = (HttpURLConnection) url.openConnection();
       conn.setRequestMethod("GET");
       conn.setRequestProperty("Content-type", "application/json");
       //System.out.println("Response code: " + conn.getResponseCode());
       
       if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) 
           rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
       else 
           rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
       
       tmp = rd.readLine(); //데이터 받음. api는 한줄로된 데이터라서 한줄만 받아도 됨
       
      StringTokenizer st = new StringTokenizer(tmp, "<,>"); //< >얘네 기준으로 뽑음
       while(st.hasMoreTokens())
       {
          str = st.nextToken();
          
          if(str.compareTo("headerMsg") == 0)
          {
             str = st.nextToken();
             if(str.compareTo("정상적으로 처리되었습니다.") != 0)
             {
                System.out.println("에러내용: " + str);
                break;   
             }
          }
          
          else if(str.compareTo("arrmsg1") == 0) //문자열이 같으면 0리턴. 첫번째 도착예정 버스의 도착예정 시간   
          {
             str = st.nextToken();             
             String s[] = str.split("\\["); //괄호로 인식해서 오류생김 \\붙여서 에러 없앰
             data[idx][1] = s[0];
          }
          
          else if(str.compareTo("nmainStnid1") == 0) //첫번째 주요정류소
          {
             str = st.nextToken();       
             data[idx][4] = str;
          }
          
          else if(str.compareTo("nmain2Stnid1") == 0) //두번째 주요 정류소
          {
             str = st.nextToken();
             data[idx][5] = str;
          }
          
          else if(str.compareTo("reride_Num1") == 0) //첫번째 도착예정 버스의 승차인원
          {
             str = st.nextToken();
             data[idx][3] = str;
             break;
          }
       }
      
       String now_time= time;
       String ride;
       String alight;
       int ride_num=0, alight_num=0;
       
       ride=now_time;
       alight=now_time;
       ride+="_RIDE_NUM";
       alight+="_ALIGHT_NUM";
       
       for(int j=0;j<2;j++)
       {
          StringBuilder urlBuilder1 = new StringBuilder("http://openapi.seoul.go.kr:8088/"); ///*URL
             urlBuilder1.append(URLEncoder.encode("4e70717943636f6c37326a784f7461","UTF-8")); ///*인증키
             urlBuilder1.append("/xml/CardBusTimeNew/"+ URLEncoder.encode(data[idx][6+j], "UTF-8")+"/"+ URLEncoder.encode(data[idx][6+j], "UTF-8"));
             urlBuilder1.append("/201710/" + URLEncoder.encode(data[idx][2], "UTF-8")+"/");
             
             URL url1 = new URL(urlBuilder1.toString());
             HttpURLConnection conn1 = (HttpURLConnection) url1.openConnection();
             conn1.setRequestMethod("GET");
             conn1.setRequestProperty("Content-type", "application/json");
              //System.out.println("Response code: " + conn.getResponseCode());
              
              BufferedReader rd1;
              if(conn1.getResponseCode() >= 200 && conn1.getResponseCode() <= 300) 
                  rd1 = new BufferedReader(new InputStreamReader(conn1.getInputStream()));
              else 
                  rd1 = new BufferedReader(new InputStreamReader(conn1.getErrorStream()));
              
              StringBuilder sb1 = new StringBuilder();
              String line1;
              while ((line1 = rd1.readLine()) != null)
                  sb1.append(line1);
              
              
              tmp=sb1.toString();
              //System.out.println(tmp);
              
              StringTokenizer st1 = new StringTokenizer(tmp, "<,>"); //< >얘네 기준으로 뽑음
              
              while(st1.hasMoreTokens())
              {
                 str = st1.nextToken();
                 
                 if(str.compareTo(ride) == 0)
                 {
                    str = st1.nextToken();
                    ride_num=Integer.valueOf(str);
                 }
                 if(str.compareTo(alight) == 0)
                 {
                    str = st1.nextToken();
                    alight_num=Integer.valueOf(str);
                    break;
                 }
              }
              
              int passenger;
              passenger=ride_num-alight_num;
              
              if(passenger < 0) 
                 data[idx][8+j]="free";
              else if(passenger < 30) 
                 data[idx][8+j]="half";
              else 
                 data[idx][8+j]="full";
    }
      
       rd.close();      //받아오고 끊음
       conn.disconnect();
   }
   
   public void selectsort(String data[][])
   {
      int i, j;
      String temp[][] = new String[1][10];
      
      int least;
       for (i = 0; i < 10; i++)
      {
         least = i;
         for (j = i + 1; j < 11; j++)
            if (Double.parseDouble(data[j][1])<Double.parseDouble(data[least][1]))
               least = j;

         temp[0][0] = data[i][0];
         temp[0][1] = data[i][1];
         temp[0][2] = data[i][2];
         temp[0][3] = data[i][3];
         temp[0][4] = data[i][4];
         temp[0][5] = data[i][5];
         temp[0][6] = data[i][6];
         temp[0][7] = data[i][7];
         temp[0][8] = data[i][8];
         temp[0][9] = data[i][9];
         
         data[i][0] = data[least][0];
         data[i][1] = data[least][1];
         data[i][2] = data[least][2];
         data[i][3] = data[least][3];
         data[i][4] = data[least][4];
         data[i][5] = data[least][5];
         data[i][6] = data[least][6];
         data[i][7] = data[least][7];
         data[i][8] = data[least][8];
         data[i][9] = data[least][9];
         
         data[least][0] = temp[0][0];
         data[least][1] = temp[0][1];
         data[least][2] = temp[0][2];
         data[least][3] = temp[0][3];
         data[least][4] = temp[0][4];
         data[least][5] = temp[0][5];
         data[least][6] = temp[0][6];
         data[least][7] = temp[0][7];
         data[least][8] = temp[0][8];
         data[least][9] = temp[0][9];
      }
   }
   
   public void data_transform(String data[][], int idx)
   {
      String tmp[] = data[idx][1].split("분");
       
      if(data[idx][1].compareTo("곧 도착") == 0)
          data[idx][1] = "0";
       
       else if(tmp[1].compareTo("후") == 0)
       {
          System.out.println("초 변환 예외발생");
          data[idx][1] = tmp[0];   
       }
       
       else
       {
          tmp[0] = data[idx][1].replace("분", ".");
          String tmp2[] = tmp[0].split("초후");
          data[idx][1] = tmp2[0];   
       }
   }
   
   public String hour_to_string(int hour)
   {
      if(hour == 0)
         return "MIDNIGHT";
      else if(hour ==1)
         return "ONE";
      else if(hour ==2)
         return "TWO";
      else if(hour ==3)
         return "THREE";
      else if(hour ==4)
         return "FOUR";
      else if(hour ==5)
         return "FIVE";
      else if(hour ==6)
         return "SIX";
      else if(hour ==7)
         return "SEVEN";
      else if(hour ==8)
         return "EIGHT";
      else if(hour ==9)
         return "NINE";
      else if(hour ==10)
         return "TEN";
      else if(hour ==11)
         return "ELEVEN";
      else if(hour ==12)
         return "TWELVE";
      else if(hour ==13)
         return "THIRTEEN";
      else if(hour ==14)
         return "FOURTEEN";
      else if(hour ==15)
         return "FIFTEEN";
      else if(hour ==16)
         return "SIXTEEN";
      else if(hour ==17)
         return "SEVENTEEN";
      else if(hour ==18)
         return "EIGHTEEN";
      else if(hour ==19)
         return "NINETEEN";
      else if(hour ==20)
         return "TWENTY";
      else if(hour ==21)
         return "TWENTY_ONE";
      else if(hour ==22)
         return "TWENTY_TWO";
      else if(hour ==23)
         return "TWENTY_THREE";
      
      else
         return "time error";
   }
%>