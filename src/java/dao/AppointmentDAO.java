package dao;


import model.Appointment;
import java.util.*;
import java.sql.*;
/**
 *
 * @author ASUS TUF
 */
public class AppointmentDAO {
    
    public static Connection getConnection(){
        Connection con = null;
        try{
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pkudb", "root", "");
        } catch (Exception e) {
            System.out.println(e);
        }
        return con;
    }
    
    

    
    public static List<Appointment> viewAppointment(){
        List<Appointment> list = new ArrayList<Appointment>();
        
        try{
            Connection con = AppointmentDAO.getConnection();
            PreparedStatement ps = con.prepareStatement("select * from appointment");
            ResultSet resultSet = ps.executeQuery();
            while(resultSet.next()){
                Appointment appointment = new Appointment();
                appointment.setAppointmentID(resultSet.getString("appointmentID"));
                appointment.setDate(resultSet.getDate("date"));
                appointment.setTime(resultSet.getTime("time"));
                appointment.setRoomNo(resultSet.getInt("roomNo"));
                appointment.setDoctorID(resultSet.getString("doctorID"));
                appointment.setPatientID(resultSet.getString("patientID"));
                appointment.setReceptionistID(resultSet.getString("receptionistID"));
                list.add(appointment);
            }
            con.close();
        } catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }
    
    
    public static int addAppointment(Appointment a) {
        int status = 0;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO appointment (appointmentID, date, time, roomNo, doctorID, patientID, receptionistID) VALUES (?, ?, ?, ?, ?, ?, ?)");
            ps.setString(1, a.getAppointmentID());
            ps.setDate(2, a.getDate());
            ps.setTime(3, a.getTime());
            ps.setInt(4, a.getRoomNo());
            ps.setString(5, a.getDoctorID());
            ps.setString(6, a.getPatientID());
            ps.setString(7, a.getReceptionistID());

            status = ps.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
    
    public static Appointment getAppointmentById(String id) {
    Appointment appt = null;
    try (Connection con = getConnection()) {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM appointment WHERE appointmentID = ?");
        ps.setString(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            appt = new Appointment(
                rs.getString("appointmentID"),
                rs.getDate("date"),
                rs.getTime("time"),
                rs.getInt("roomNo"),
                rs.getString("doctorID"),
                rs.getString("patientID"),
                rs.getString("receptionistID")
            );
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return appt;
}

public static int updateAppointment(Appointment appt) {
    int status = 0;
    try (Connection con = getConnection()) {
        PreparedStatement ps = con.prepareStatement(
            "UPDATE appointment SET date=?, time=?, roomNo=?, doctorID=?, patientID=?, receptionistID=? WHERE appointmentID=?"
        );
        ps.setDate(1, appt.getDate());
        ps.setTime(2, appt.getTime());
        ps.setInt(3, appt.getRoomNo());
        ps.setString(4, appt.getDoctorID());
        ps.setString(5, appt.getPatientID());
        ps.setString(6, appt.getReceptionistID());
        ps.setString(7, appt.getAppointmentID());

        status = ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return status;
}

public static int deleteAppointment(String id) {
    int status = 0;
    try (Connection con = getConnection()) {
        PreparedStatement ps = con.prepareStatement("DELETE FROM appointment WHERE appointmentID = ?");
        ps.setString(1, id);
        status = ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return status;
}

public static int getPendingAppointmentsCount() {
        int count = 0;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT COUNT(*) FROM appointment WHERE date >= CURDATE() AND status = 'pending'");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    
    public static int getCompletedAppointmentsTodayCount() {
        int count = 0;
        try {
            Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT COUNT(*) FROM appointment WHERE date = CURDATE() AND status = 'completed'");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    
    public static List<Appointment> getPendingAppointments() {
    List<Appointment> list = new ArrayList<>();
    try {
        Connection con = getConnection();
        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM appointment WHERE date >= CURDATE() AND status = 'pending'");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Appointment appointment = new Appointment();
            appointment.setAppointmentID(rs.getString("appointmentID"));
            appointment.setDate(rs.getDate("date"));
            appointment.setTime(rs.getTime("time"));
            appointment.setRoomNo(rs.getInt("roomNo"));
            appointment.setDoctorID(rs.getString("doctorID"));
            appointment.setPatientID(rs.getString("patientID"));
            appointment.setReceptionistID(rs.getString("receptionistID"));
            list.add(appointment);
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

public static List<Appointment> getAppointmentsWithDetails(String statusFilter) {
    List<Appointment> list = new ArrayList<>();
    try {
        Connection con = getConnection();
        String sql = "SELECT a.*, p.name as patientName, u.name as doctorName " +
                     "FROM appointment a " +
                     "JOIN patient p ON a.patientID = p.patientID " +
                     "JOIN users u ON a.doctorID = u.userID ";
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql += "WHERE a.status = ?";
        }
        
        PreparedStatement ps = con.prepareStatement(sql);
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            ps.setString(1, statusFilter);
        }
        
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Appointment appointment = new Appointment();
            appointment.setAppointmentID(rs.getString("appointmentID"));
            appointment.setDate(rs.getDate("date"));
            appointment.setTime(rs.getTime("time"));
            appointment.setRoomNo(rs.getInt("roomNo"));
            appointment.setDoctorID(rs.getString("doctorID"));
            appointment.setPatientID(rs.getString("patientID"));
            appointment.setReceptionistID(rs.getString("receptionistID"));
            
            // Set additional fields if they exist in your Appointment class
            // appointment.setPatientName(rs.getString("patientName"));
            // appointment.setDoctorName(rs.getString("doctorName"));
            
            list.add(appointment);
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

public static List<Appointment> getCompletedAppointmentsToday() {
    List<Appointment> list = new ArrayList<>();
    try {
        Connection con = getConnection();
        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM appointment WHERE date = CURDATE() AND status = 'completed'");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Appointment appointment = new Appointment();
            appointment.setAppointmentID(rs.getString("appointmentID"));
            appointment.setDate(rs.getDate("date"));
            appointment.setTime(rs.getTime("time"));
            appointment.setRoomNo(rs.getInt("roomNo"));
            appointment.setDoctorID(rs.getString("doctorID"));
            appointment.setPatientID(rs.getString("patientID"));
            appointment.setReceptionistID(rs.getString("receptionistID"));
            list.add(appointment);
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}




}