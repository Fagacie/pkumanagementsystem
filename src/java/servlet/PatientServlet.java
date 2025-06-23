package servlet;

import dao.PatientDAO;
import model.Patient;
import model.Treatment;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class PatientServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("details".equalsIgnoreCase(action)) {
            String patientID = request.getParameter("id");
            Patient patient = PatientDAO.getPatientById(patientID);

            // Add this to fetch treatment history
            List<Treatment> treatments = dao.treatmentDAO.getTreatmentHistory(patientID);
            request.setAttribute("treatments", treatments);

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("patientDetails.jsp").forward(request, response);
        } 
        else if ("edit".equalsIgnoreCase(action)) {
            String id = request.getParameter("id");
            Patient patient = PatientDAO.getPatientById(id);
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("editPatient.jsp").forward(request, response);
        } 
        else {
            List<Patient> patientList = PatientDAO.getAllPatients();
            request.setAttribute("patientList", patientList);
            request.getRequestDispatcher("searchPatient.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("edit".equalsIgnoreCase(action)) {
            String patientID = request.getParameter("patientID");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            int age = Integer.parseInt(request.getParameter("age"));
            String bloodType = request.getParameter("bloodType");
            float weight = Float.parseFloat(request.getParameter("weight"));
            float height = Float.parseFloat(request.getParameter("height"));
            String userId = request.getParameter("userId");
            
            Patient patient = new Patient(patientID, name, address, gender, age, 
                                        bloodType, weight, height);
            patient.setUserId(userId);
            
            int result = PatientDAO.updatePatient(patient);
            if (result > 0) {
                response.sendRedirect("PatientServlet");
            } else {
                request.setAttribute("error", "Failed to update patient");
                request.setAttribute("patient", patient);
                request.getRequestDispatcher("editPatient.jsp").forward(request, response);
            }
        } 
        else if ("add".equalsIgnoreCase(action)) {
            String patientID = request.getParameter("patientID");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            int age = Integer.parseInt(request.getParameter("age"));
            String bloodType = request.getParameter("bloodType");
            float weight = Float.parseFloat(request.getParameter("weight"));
            float height = Float.parseFloat(request.getParameter("height"));
            String userId = request.getParameter("userId");
            
            Patient patient = new Patient(patientID, name, address, gender, age, 
                                        bloodType, weight, height);
            patient.setUserId(userId);
            
            int result = PatientDAO.addPatient(patient);
            if (result > 0) {
                response.sendRedirect("PatientServlet");
            } else {
                request.setAttribute("error", "Failed to add patient");
                request.getRequestDispatcher("addPatient.jsp").forward(request, response);
            }
        }
    }
}