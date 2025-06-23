/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.PaymentDAO;
import model.Payment;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.Random; // Import Random for generating random IDs
// Removed java.util.UUID as we are no longer using UUIDs

import javax.servlet.annotation.WebServlet;

@WebServlet("/payment") // Mapped to singular /payment
public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO;
    private static final Random RANDOM = new Random(); // Static Random instance for ID generation
    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; // Characters for ID

    @Override
    public void init() {
        paymentDAO = new PaymentDAO();
        System.out.println("PaymentServlet initialized. PaymentDAO created.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action is "list"
        }
        System.out.println("PaymentServlet: Handling GET request with action = " + action);

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deletePayment(request, response);
                    break;
                case "list": // Explicitly handling the "list" case
                default: // Fallback for any other/missing action
                    listPayments(request, response);
                    break;
            }
        } catch (SQLException e) {
            System.err.println("PaymentServlet: SQLException during doGet for action " + action + ": " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        } catch (Exception e) {
            System.err.println("PaymentServlet: Unexpected Exception during doGet for action " + action + ": " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String paymentID = request.getParameter("paymentID"); // This will be empty for new payments
        String receptionistID = request.getParameter("receptionistID");
        String patientID = request.getParameter("patientID");
        double amount = Double.parseDouble(request.getParameter("amount"));
        char paymentStatus = request.getParameter("paymentStatus").charAt(0);
        String method = request.getParameter("method");
        Date date = Date.valueOf(request.getParameter("date"));

        Payment payment = new Payment();
        
        // Generate new 5-character paymentID if it's an "add" operation
        if (request.getParameter("formType").equals("add")) {
            // Generate a random 5-character ID
            StringBuilder sb = new StringBuilder(5);
            for (int i = 0; i < 5; i++) {
                sb.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
            }
            paymentID = sb.toString();
            System.out.println("PaymentServlet: Generated new 5-character paymentID for 'add' operation: " + paymentID);
        }
        payment.setPaymentID(paymentID); // Set the generated or existing paymentID
        payment.setReceptionistID(receptionistID);
        payment.setPatientID(patientID);
        payment.setAmount(amount);
        payment.setPaymentStatus(paymentStatus);
        payment.setMethod(method);
        payment.setDate(date);

        try {
            if (request.getParameter("formType").equals("edit")) {
                paymentDAO.updatePayment(payment);
                System.out.println("PaymentServlet: Payment updated - ID: " + paymentID);
                request.getSession().setAttribute("successMessage", "Payment ID " + paymentID + " updated successfully!");
            } else { // This is the "add" operation
                paymentDAO.addPayment(payment);
                System.out.println("PaymentServlet: New payment added - ID: " + paymentID);
                request.getSession().setAttribute("successMessage", "Payment ID " + paymentID + " recorded successfully!");
            }
            response.sendRedirect("payment"); // Redirect to list view using singular /payment
        } catch (SQLException e) {
            System.err.println("PaymentServlet: SQLException during doPost for payment ID " + paymentID + ": " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error saving payment: " + e.getMessage());
            response.sendRedirect("payment-form.jsp");
        } catch (Exception e) {
            System.err.println("PaymentServlet: Unexpected Exception during doPost for action " + paymentID + ": " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect("payment-form.jsp");
        }
    }

    private void listPayments(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        System.out.println("PaymentServlet: listPayments method called.");
        List<Payment> paymentList = null;
        try {
            paymentList = paymentDAO.getAllPayments();
            System.out.println("PaymentServlet: Retrieved " + (paymentList != null ? paymentList.size() : 0) + " payments from DAO.");
        } catch (SQLException e) {
            System.err.println("PaymentServlet: Error getting all payments from DAO: " + e.getMessage());
            throw e;
        }

        request.setAttribute("paymentList", paymentList);
        System.out.println("PaymentServlet: Forwarding to payment-list.jsp");
        request.getRequestDispatcher("payment-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("PaymentServlet: showNewForm method called.");
        request.getRequestDispatcher("payment-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String paymentID = request.getParameter("paymentID");
        System.out.println("PaymentServlet: showEditForm method called for payment ID: " + paymentID);
        Payment existingPayment = paymentDAO.getPaymentById(paymentID);
        if (existingPayment != null) {
            request.setAttribute("payment", existingPayment);
            System.out.println("PaymentServlet: Found payment for edit: " + existingPayment.getPaymentID());
            request.getRequestDispatcher("payment-form.jsp").forward(request, response);
        } else {
            System.out.println("PaymentServlet: Payment not found for edit: " + paymentID);
            request.getSession().setAttribute("errorMessage", "Payment ID " + paymentID + " not found for editing.");
            response.sendRedirect("payment"); // Redirect back to list using singular /payment
        }
    }

    private void deletePayment(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String paymentID = request.getParameter("paymentID");
        System.out.println("PaymentServlet: deletePayment method called for payment ID: " + paymentID);
        try {
            paymentDAO.deletePayment(paymentID);
            System.out.println("PaymentServlet: Payment deleted - ID: " + paymentID);
            request.getSession().setAttribute("successMessage", "Payment ID " + paymentID + " deleted successfully!");
        } catch (SQLException e) {
            System.err.println("PaymentServlet: Error deleting payment ID " + paymentID + ": " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error deleting payment ID " + paymentID + ": " + e.getMessage());
        }
        response.sendRedirect("payment"); // Redirect to list view after delete attempt using singular /payment
    }
}