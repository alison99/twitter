<%@page language="java" %>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="com.mysql.jdbc.*" %>

<%
     
      try {

         java.sql.Connection con = null;
         String url = "";

		 String p1 = request.getParameter("handle"); //right side html, left java
		 String p2 = request.getParameter("password");

//	 out.println("debug: " + p1);


	 String query = "select user_id from user_t where username= '" + p1 + "'" + " and pass= '" + p2  + "';"; //put in dynamic query here
		
	 //open sql:
         Class.forName("com.mysql.jdbc.Driver").newInstance();
         url = "jdbc:mysql://localhost:3306/achen";
         con = DriverManager.getConnection(url, "achen", "dalton123");
         java.sql.Statement stmt = con.createStatement();
         
	 //executes the query:
	 java.sql.ResultSet rs = stmt.executeQuery(query);

	 String p_key = ""; 

	 //loop through result set until there is no more data

		if(rs.next())
		{
		p_key = rs.getString("user_id");
		session.setAttribute("p_key", p_key);
		response.sendRedirect("twitter-home.jsp");
		}
		else {
		response.sendRedirect("twitter-signin.jsp?error= User not found!");
		}
		
				//go to twitter home with key

	//	out.println("the key is: " + p_key);

      } catch (Exception e) {
         out.println(e);
      }
%>


