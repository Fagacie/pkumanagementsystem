package model;
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


import java.util.Date;

public class Treatment {
    private String treatmentId;
    private String symptoms;
    private String illness;
    private String medicineId;
    private Date date;
    
    // Getters and Setters
    public String getTreatmentId() { return treatmentId; }
    public void setTreatmentId(String treatmentId) { this.treatmentId = treatmentId; }
    
    public String getSymptoms() { return symptoms; }
    public void setSymptoms(String symptoms) { this.symptoms = symptoms; }
    
    public String getIllness() { return illness; }
    public void setIllness(String illness) { this.illness = illness; }
    
    public String getMedicineId() { return medicineId; }
    public void setMedicineId(String medicine) { this.medicineId = medicine; }
    
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}
