<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%

	String tweet = request.getParameter("tweet");
 	String p_key = (String) session.getAttribute("p_key");
	int status = 0;
	int status2 = 0;
	String tweet_id = "";
	String hash_id = "";

//out.println("email is: " + email);
	 
		java.sql.Connection con = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/achen";   //location and name of database
        String userid = "achen";
        String password = "dalton123";
        con = DriverManager.getConnection(url, userid, password);
        
        //insert tweet
		java.sql.PreparedStatement ps = con.prepareStatement("insert into tweet_t (user_id, words) values (?,?);");
		
		ps.setString(1,p_key);
		ps.setString(2,tweet);
		
        status = ps.executeUpdate();
        
        //get tweet_id
        java.sql.Statement stmt1 = con.createStatement();
        	
        	String query1 = "select max(tweet_id) from tweet_t where user_id="+p_key;
        	java.sql.ResultSet rs1 = stmt1.executeQuery(query1);
        	if(rs1.next())
        	{
        		tweet_id=rs1.getString(1);
        	}
        	
        //split tweet and check if there is a hashtag
        String tokens[] = tweet.split(" ");
        
        for(int i=0; i<tokens.length; i++) 
        {
        	if(tokens[i].startsWith("#")) 
        	{
        	java.sql.Statement stmt2 = con.createStatement();
        	
        	String query2 = "select hash_id from hash_t where hashtag ='" + tokens[i] + "'";
        	java.sql.ResultSet rs2 = stmt2.executeQuery(query2);
			
			if(!rs2.next()) 
			{
			//insert new hashtag
			java.sql.PreparedStatement ps1 = con.prepareStatement("insert into hash_t (hashtag) values (?)");
			ps1.setString(1, tokens[i]);
			ps1.executeUpdate();

			//get hash_id
			java.sql.Statement stmt3 = con.createStatement();
        	
        	String query3 = "select hash_id from hash_t where hashtag ='" + tokens[i] + "'";
        	out.println(query3);
        	java.sql.ResultSet rs3 = stmt3.executeQuery(query3);
        	
        		if(rs3.next())
        		{
        		hash_id=rs3.getString("hash_id");
        		out.println(hash_id);
        		}
        	}
        	else 
        	{
        		hash_id=rs2.getString("hash_id");
        	}
			
			//insert into hash_tweet_rel

			java.sql.PreparedStatement ps2 = con.prepareStatement("insert into hash_tweet_rel (tweet_id, hash_id) values (?,?);");

			ps2.setString(1, tweet_id);
			ps2.setString(2, hash_id);
		
      		ps2.executeUpdate();

       		}
       		
        }
        

	if(status > 0) {
		
		response.sendRedirect("twitter-home.jsp");
	
	}
	
%>




