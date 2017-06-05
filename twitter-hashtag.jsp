<%@page language="java" %>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="com.mysql.jdbc.*" %>

<%
     try {
     
         java.sql.Connection con = null;
         String p_key = (String) session.getAttribute("p_key");
         if(p_key == null)
         	response.sendRedirect("twitter-signin.jsp");
         String h_key = request.getParameter("h_key");
         String username = "";
         String fullname = "";
         String total = "";
         String followers = "";
         String following = "";
   	     String text = "";
   	     String tweetusername = "";
   	     String tweetfullname = "";
   	     String hash_id = "";
   	     String hashtag = "";
         
         //consider: select DISTINCT username, etc
         
         String query1 = "select username, first_name, last_name from user_t where user_id = '" + p_key + "';";
         //query1 gets pkey, username/handle, first and last name
         String query2 = "select count(tweet_t.`words`) as total from user_t join tweet_t on user_t.`user_id`=tweet_t.`user_id` where user_t.`user_id`='" + p_key + "';";
         //query2 gets total tweets
         String query3 = "select count(follow_t.`followers_id`) as followers from user_t join follow_t on user_t.`user_id`=follow_t.`following_id` where user_t.`user_id`= '" + p_key + "';";
         //query3 gets total followers
         String query4 = "select count(follow_t.`following_id`) as following from user_t join follow_t on user_t.`user_id`=follow_t.`followers_id` where user_t.`user_id`= '" + p_key + "';";
         //query4 gets total you are following
       	 String query5 = "select words, username, first_name, last_name from user_t, tweet_t, hash_t, hash_tweet_rel where user_t.user_id = tweet_t.user_id and tweet_t.tweet_id = hash_tweet_rel.`tweet_id`and hash_tweet_rel.hash_id = hash_t.hash_id and hash_t.`hash_id`='" + h_key + "' order by tweet_t.tweet_id desc;";
         //query5 gets stuff   
         String query7 = "select hashtag from hash_t where hash_id='" + h_key + "';";    
         
	 //open sql:
         Class.forName("com.mysql.jdbc.Driver").newInstance();
         String url = "jdbc:mysql://localhost:3306/achen";
         con = DriverManager.getConnection(url, "achen", "dalton123");
         java.sql.Statement stmt1 = con.createStatement();
         java.sql.Statement stmt2 = con.createStatement();
         java.sql.Statement stmt3 = con.createStatement();
         java.sql.Statement stmt4 = con.createStatement();
         java.sql.Statement stmt5 = con.createStatement();
         java.sql.Statement stmt7 = con.createStatement();

         
	 //executes the query:
	 java.sql.ResultSet rs1 = stmt1.executeQuery(query1);
	
		if(rs1.next())
		{
			username = rs1.getString("username");
			fullname = rs1.getString("first_name") + " " + rs1.getString("last_name");		
		}	
	
	java.sql.ResultSet rs2 = stmt2.executeQuery(query2);
	
		if(rs2.next())
		{
			total = rs2.getString("total");
		}	

	java.sql.ResultSet rs3 = stmt3.executeQuery(query3);
	
		if(rs3.next())
		{
			followers = Integer.toString(Integer.parseInt(rs3.getString("followers"))-1);
		}	
	
	java.sql.ResultSet rs4 = stmt4.executeQuery(query4);
	
		if(rs4.next())
		{
			following = Integer.toString(Integer.parseInt(rs4.getString("following"))-1);
		}		 
	 
	 java.sql.ResultSet rs5 = stmt5.executeQuery(query5);	

	 java.sql.ResultSet rs7 = stmt7.executeQuery(query7);
	
		if(rs7.next())
		{
	 		hashtag = rs7.getString("hashtag");
		}		 
	 
	 
    
%>



<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <meta name="description" content="">
    <meta name="author" content="">
    <style type="text/css">
    	body {
    		padding-top: 60px;
    		padding-bottom: 40px;
    	}
    	.sidebar-nav {
    		padding: 9px 0;
    	}
    </style>    
    <link rel="stylesheet" href="css/gordy_bootstrap.min.css">
</head>
<body class="user-style-theme1">
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container">
                <i class="nav-home"></i> <a href="twitter-home.jsp?key=<%=p_key%>" class="brand">Alison's Twitter</a>
				<div class="nav-collapse collapse">
                    <p class="navbar-text pull-right"><a href="twitter-logout.jsp" class="navbar-link">Log out</a>
					</p>
					<ul class="nav">
						<li class="active"><a href="twitter-home.jsp?key=<%=p_key%>">Home</a></li>
						<li><a href="queries.html">Test Queries</a></li>
						<li><a href="twitter-signin.jsp?key=<%=p_key%>">Sign in</a></li>
					</ul>
				</div><!--/ .nav-collapse -->
			</div>
		</div>
	</div>

    <div class="container wrap">
        <div class="row">

            <!-- left column -->
            <div class="span4" id="secondary">
                <div class="module mini-profile">
                    <div class="content">
                        <div class="account-group">
                            <a href="twitter-home.jsp?key=<%=p_key%>">
                                <img class="avatar size32" src="images/obama.png" alt="Gordy">
                                <b class="fullname"><%=fullname%></b>
                                <small class="metadata">View my homepage</small>
                            </a>
                        </div>
                    </div>
                    <div class="js-mini-profile-stats-container">
                        <ul class="stats">
                            <li><a href="twitter-total.jsp?key=<%=p_key%>"><strong><%=total%></strong>Tweets</a></li>
                            <li><a href="twitter-following.jsp?key=<%=p_key%>"><strong><%=following%></strong>Following</a></li>
                            <li><a href="twitter-follower.jsp?key=<%=p_key%>"><strong><%=followers%></strong>Followers</a></li>
                        </ul>
                    </div>
                    <form action="insert_tweet.jsp" method="get">
                        <textarea name="tweet" class="tweet-box" placeholder="Compose new Tweet..." id="tweet-box-mini-home-profile"></textarea>
                    <input type="submit" value="Tweet it!">
                  <input type="hidden" name="p_key" value="<%=p_key%>">                
                    </form>
                </div>

                <div class="module other-side-content">
                    <div class="content"
                        <p>Dancing Seagulls</p>
                    </div>
                </div>
            </div>
			
            <!-- right column -->
            <div class="span8 content-main">
                <div class="module">
                    <div class="content-header">
                        <div class="header-inner">
                            <h2 class="js-timeline-title">Tweets with <%=hashtag%></h2>
                        </div>
                    </div>

                    <!-- new tweets alert -->
                    <div class="stream-item hidden">
                        <div class="new-tweets-bar js-new-tweets-bar well">
                            2 new Tweets
                        </div>
                    </div>

                    <!-- all tweets -->
                    <div class="stream home-stream">

				<%
				while(rs5.next())
				{
				   	String output = "";
					text = rs5.getString("words");
					String tokens[] = text.split(" ");
    				for(int i=0; i<tokens.length; i++) 
        				{
       					if(tokens[i].startsWith("#")) 
    					{
       					String query6 = "select hash_id from hash_t where hashtag ='" + tokens[i] + "'";
						java.sql.Statement stmt6 = con.createStatement();
						java.sql.ResultSet rs6 = stmt6.executeQuery(query6);
							if(rs6.next()) {
								hash_id = rs6.getString("hash_id");
								output = output + " <a href=twitter-hashtag.jsp?key=" + p_key + "&h_key=" + hash_id + ">" + tokens[i] + "</a>";						
								}
							}
							else
							{
							output = output + " " + tokens[i];
							}
						}
					tweetusername = rs5.getString("username");
					tweetfullname = rs5.getString("first_name") + " " + rs5.getString("last_name");
							 
				%>
                        <!-- start tweet -->
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="content">
                                    <div class="stream-item-header">
                                        <small class="time">
                                            <a href="#" class="tweet-timestamp" title="10:15am - 16 Nov 12">
                                                <span class="_timestamp">6m</span>
                                            </a>
                                        </small>
                                        <a class="account-group">
                                            <img class="avatar" src="images/obama.png" alt="Barak Obama">
                                            <strong class="fullname"><%=tweetfullname%></strong>
                                            <span>&rlm;</span>
                                            <span class="username">
                                                <s>@</s>
                                                <b><%=tweetusername%></b>
                                            </span>
                                        </a>
                                    </div>
                                    <p class="js-tweet-text">
                                        <%=output%>
                                        <a href="http://t.co/xOqdhPgH" class="twitter-timeline-link" target="_blank" title="http://OFA.BO/xRSG9n" dir="ltr">
                                            <span class="invisible">http://</span>
                                          <!--  <span class="js-display-url">OFA.BO/xRSG9n</span> -->
                                            <span class="invisible"></span>
                                            <span class="tco-ellipsis">
                                                <span class="invisible">&nbsp;</span>
                                            </span>
                                        </a>
                                    </p>
                                </div>
                            </a>
                                <div class="expanded-content js-tweet-details-dropdown"></div>
                            </div>
                        </div><!-- end tweet -->
                        
                        
                        <%
                        }
                        %>
                        
                        
                        
                    </div>
                    <div class="stream-footer"></div>
                    <div class="hidden-replies-container"></div>
                    <div class="stream-autoplay-marker"></div>
                </div>
                </div>
               
            </div>
        </div>
    </div>
     <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
     <script type="text/javascript" src="js/main-ck.js"></script>
  </body>
</html>

<%
  } catch (Exception e) {
         out.println(e);
      }

%>