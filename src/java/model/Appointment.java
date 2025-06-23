package model;

import java.sql.Date;
import java.sql.Time;

public class Appointment {
    private String appointmentID;
    private Date date;
    private Time time;
    private int roomNo;
    private String doctorID;
    private String patientID;
    private String receptionistID;
    
    // Constructors
    public Appointment() {}
    
    public Appointment(String appointmentID, Date date, Time time, int roomNo, 
                      String doctorID, String patientID, String receptionistID) {
        this.appointmentID = appointmentID;
        this.date = date;
        this.time = time;
        this.roomNo = roomNo;
        this.doctorID = doctorID;
        this.patientID = patientID;
        this.receptionistID = receptionistID;
    }
    
    // Getters and Setters
    public String getAppointmentID() {
        return appointmentID;
        
    }

    public void setAppointmentID(String appointmentID) {
        this.appointmentID = appointmentID;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Time getTime() {
        return time;
    }

    public void setTime(Time time) {
        this.time = time;
    }

    public int getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(int roomNo) {
        this.roomNo = roomNo;
    }

    public String getDoctorID() {
        return doctorID;
    }

    public void setDoctorID(String doctorID) {
        this.doctorID = doctorID;
    }

    public String getPatientID() {
        return patientID;
    }

    public void setPatientID(String patientID) {
        this.patientID = patientID;
    }

    public String getReceptionistID() {
        return receptionistID;
    }

    public void setReceptionistID(String receptionistID) {
        this.receptionistID = receptionistID;
    }
}