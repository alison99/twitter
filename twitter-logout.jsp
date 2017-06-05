<%
      try {

         java.sql.Connection con = null;
		 String p_key = (String) session.getAttribute("p_key");


		session.setAttribute("p_key", null);
		response.sendRedirect("twitter-home.jsp");

      } catch (Exception e) {
         out.println(e);
      }
%>
