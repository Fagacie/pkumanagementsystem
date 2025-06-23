/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;
/**
 *
 * @author ACER
 */


public class Payment {
    private String paymentID;
    private String receptionistID;
    private String patientID;
    private double amount;
    private char paymentStatus;
    private String method;
    private Date date;

    public String getPaymentID() { return paymentID; }
    public void setPaymentID(String paymentID) { this.paymentID = paymentID; }

    public String getReceptionistID() { return receptionistID; }
    public void setReceptionistID(String receptionistID) { this.receptionistID = receptionistID; }

    public String getPatientID() { return patientID; }
    public void setPatientID(String patientID) { this.patientID = patientID; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public char getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(char paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getMethod() { return method; }
    public void setMethod(String method) { this.method = method; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
}
