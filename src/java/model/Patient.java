package model;

public class Patient {
    private String patientID;
    private String name;
    private String address;
    private String gender;
    private int age;
    private String bloodType;
    private float weight;
    private float height;
        private String userId;

    
    public Patient() {}
    
    public Patient(String patientID, String name, String address, String gender, int age,
                  String bloodType, float weight, float height) {
        this.patientID = patientID;
        this.name = name;
        this.address = address;
        this.gender = gender;
        this.age = age;
        this.bloodType = bloodType;
        this.weight = weight;
        this.height = height;
    }
    
    // Getters and Setters
    public String getPatientID() { return patientID; }
    public void setPatientID(String patientID) { this.patientID = patientID; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    public String getBloodType() { return bloodType; }
    public void setBloodType(String bloodType) { this.bloodType = bloodType; }
    public float getWeight() { return weight; }
    public void setWeight(float weight) { this.weight = weight; }
    public float getHeight() { return height; }
    public void setHeight(float height) { this.height = height; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    
    public String getStatus() {
        return patientID.length() > 9 ? "Non-student" : "Student";
    }
}