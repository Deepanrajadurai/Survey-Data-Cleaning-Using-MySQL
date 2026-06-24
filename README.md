# Customer Survey Data Cleaning Using MySQL

## 📌 Project Overview

This project demonstrates a complete SQL data cleaning workflow using **MySQL**. A raw customer survey dataset imported from a CSV file is cleaned, standardized, and transformed into an analysis-ready dataset.

The project covers common data cleaning tasks frequently performed by Data Analysts, including handling missing values, standardizing inconsistent data, formatting dates, removing duplicates, and preparing the dataset for business analysis.

---

## 🎯 Objectives

* Import raw survey data from a CSV file
* Create a separate working table for cleaning
* Validate data quality
* Remove unwanted spaces
* Standardize categorical values
* Convert inconsistent date formats
* Split address into separate columns
* Handle missing contact information
* Detect and remove duplicate records
* Remove unnecessary columns
* Produce a clean dataset ready for analysis

---

## 🛠️ Tools & Technologies

* MySQL 8.0+
* SQL
* MySQL Workbench
* CSV Dataset

---

---

## 📋 Data Cleaning Process

### 1. Data Validation

* Verified successful CSV import
* Counted total records
* Previewed the dataset

---

### 2. Created a Working Table

Created a duplicate table (`survey_clean`) to preserve the original raw data.

---

### 3. Removed Extra Spaces

Used the `TRIM()` function to remove leading and trailing spaces from text columns.

---

### 4. Standardized Service Feedback

Cleaned inconsistent values such as:

| Before            | After     |
| ----------------- | --------- |
| GOOD              | Good      |
| Excellent Service | Excellent |
| average           | Average   |
| Poor Experience   | Poor      |

Great values were replaced with **Excellent**.

---

### 5. Standardized Date Formats

Converted multiple date formats into a consistent **YYYY-MM-DD** format and changed the column data type to `DATE`.

---

### 6. Split Address Column

Separated the address into three individual columns:

* Street
* City
* State

---

### 7. Created Preferred Contact Column

Used:

```sql
COALESCE(NULLIF(email,''), NULLIF(phone,''), 'UNKNOWN')
```

to determine the preferred contact method.

---

### 8. Removed Duplicate Records

* Added an Auto Increment Primary Key
* Used the `ROW_NUMBER()` window function
* Deleted duplicate customer records while retaining the first occurrence

---

### 9. Removed Unnecessary Columns

Dropped:

* Email
* Phone
* Address

after creating transformed columns.

---

## 📈 SQL Concepts Used

* CREATE TABLE
* ALTER TABLE
* UPDATE
* DELETE
* CASE
* COALESCE
* NULLIF
* TRIM
* DATE_FORMAT
* STR_TO_DATE
* SUBSTRING_INDEX
* ROW_NUMBER()
* Common Table Expressions (CTEs)
* Window Functions
* Aggregate Functions
* DISTINCT
* AUTO_INCREMENT
* PRIMARY KEY

---

## 📊 Before Cleaning

* Duplicate customer records
* Inconsistent service feedback values
* Multiple date formats
* Extra spaces in text fields
* Combined address column
* Missing contact information
* Unnecessary columns

---

## ✅ After Cleaning

* Duplicate records removed
* Consistent feedback values
* Standardized date format
* Trimmed text values
* Structured address columns
* Preferred contact column created
* Clean, analysis-ready dataset

---

## 🚀 Key Learning Outcomes

Through this project, I gained hands-on experience with:

* SQL data cleaning techniques
* Data quality assessment
* String manipulation
* Date transformation
* Window functions
* Common Table Expressions (CTEs)
* Duplicate detection
* Database design improvements
* Data preparation for analytics

---

## 💡 Future Improvements

* Add stored procedures for automation
* Create reusable SQL scripts
* Build a Power BI dashboard using the cleaned dataset
* Perform exploratory data analysis (EDA)
* Add customer satisfaction KPIs

---

## 👨‍💻 Author

**Deepan R**

Aspiring Data Analyst

### Skills

* SQL
* Python
* Power BI
* Excel
* Data Cleaning
* Data Visualization
* Exploratory Data Analysis (EDA)

---

⭐ If you found this project useful, consider giving it a star on GitHub.
