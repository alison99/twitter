<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%

	String first_name = request.getParameter("first_name"); //suck in html ; store in java var
	String last_name = request.getParameter("last_name");
	String email = request.getParameter("email");
	String pass = request.getParameter("password");
	String username = request.getParameter("username");
	String p_key = "";
	int status = 0;
	int status1 = 0;

//	out.println("email is: " + email);
//MAKE SURE TO FOLLOW YOURSELF = TO SEE YOUR OWN TWEETS IN ADDITION TO THOSE YOU ARE FOLLOWING


	String query = "select user_id from user_t where username= '" + username + "' or email= '" + email + "';"; //put in dynamic query here
	 
	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/achen";   //location and name of database
        String userid = "achen";
        String password = "dalton123";
        conn = DriverManager.getConnection(url, userid, password);
        java.sql.Statement stmt = conn.createStatement();      //connect to database
        java.sql.Statement stmt1 = conn.createStatement();      //connect to database
        
    java.sql.ResultSet rs = stmt.executeQuery(query);
    
	if(rs.next())
	{
		response.sendRedirect("twitter-signin.jsp?error= User exists! Please sign in.");
	}
	else 
	{
		java.sql.PreparedStatement ps = conn.prepareStatement("insert into user_t (username, pass, first_name, last_name, email) values (?,?,?,?,?)");
				
		ps.setString(1,username);
		ps.setString(2,pass);
		ps.setString(3,first_name);
		ps.setString(4,last_name);
		ps.setString(5,email);
		
        status = ps.executeUpdate();
 
    } 

	if(status > 0) {
	
		String select = "select user_id from user_t where username= '" + username + "'" + " and pass= '" + pass  + "';";
		java.sql.ResultSet rs1 = stmt1.executeQuery(select);
		if(rs1.next())
		{
			p_key = rs1.getString("user_id");
			session.setAttribute("p_key", p_key);
		}	
		
		java.sql.PreparedStatement ps1 = conn.prepareStatement("insert into follow_t (following_id, followers_id) values (?,?)");
       
        ps1.setString(1, p_key);
        ps1.setString(2, p_key);
        
        status1 = ps1.executeUpdate();
		
		response.sendRedirect("twitter-home.jsp");
	
	}
	
%>




