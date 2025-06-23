/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.UserDAO;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import model.User;

/**
 *
 * @author ACER
 */


@WebServlet("/deleteUser")


public class DeleteUserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userID = request.getParameter("userID");
        if ((userID == null || userID.isEmpty()) && session != null && session.getAttribute("user") != null) {
            userID = ((User) session.getAttribute("user")).getUserID();
        }
        try {
            System.out.println("Attempting deletion for userID: " + userID); // DEBUG
            boolean deleted = false;
            if (userID != null) {
                deleted = userDAO.deleteUser(userID); // Delete from DB
                System.out.println("Delete success? " + deleted); // DEBUG
            }
            if (deleted && session != null) session.invalidate();
            response.sendRedirect("login.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Could not delete user. " + e.getMessage());
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}