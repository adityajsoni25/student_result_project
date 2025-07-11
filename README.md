# student_result_project
A MySQL-based student result management system


# 🎓 Student Result Project

This project is a **MySQL-based student result management system** that handles students, subjects, marks, users, and roles using a normalized relational database. It's ideal for academic institutions or as a database learning project.

---

## 🚀 How to Run

1. Open MySQL command line or Workbench
   
2. Run:

   ```bash
   mysql -u root -p < student_result_project.sql
   
3.Enter your MySQL password when prompted

   ✅ The database, tables, users, data, views, procedures, and triggers will be created.

## 👤 User Credentials

| Username  | Password  | Role    |
|-----------|-----------|---------|
| admin1    | admin123  | admin   |
| faculty1  | fac123    | faculty |
     

🧠 Features
1. Normalized schema with foreign keys
2. Role-based access using MySQL roles
3. Audit logging of marks changes via triggers
4. View for simplified result reporting
5. Stored procedure to handle insert/update
6. Sample data for students, marks, and users




