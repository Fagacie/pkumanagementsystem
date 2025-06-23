/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.UserDAO;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 * @author ACER
 */




public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
     


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userID = request.getParameter("userID");
        String password = request.getParameter("password");
        
        response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();

        try {
            User user = userDAO.validateLogin(userID, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user); // Set user in session
                
                out.println(user.getRole());

                // Redirect based on role
                switch (user.getRole()) {
                    case "admin":
                        response.sendRedirect("admin-dashboard.jsp");
                        break;
                    case "receptionist":
                        response.sendRedirect("receptionist-dashboard.jsp");
                        break;
                    case "doctor":
                        response.sendRedirect("doctor-dashboard.jsp");
                        break;
                    default:
                        response.sendRedirect("dashboard.jsp");
                        break;
                }
            } else {
                request.setAttribute("error", "Invalid credentials or inactive user!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws 
            ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}