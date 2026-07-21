### BrightLearn Data Engineering Exam – Mpho Matebesi

This repository contains the Data Engineering capstone exam project for BrightLearn, a South African retail chain. The project addresses the challenge of transactional data stored in flat CSV files with quality issues. The goal is to design and implement a clean data pipeline and warehouse to support reporting and decision-making.

---

## Repository Structure

### 0.0.0.project_scope
Defines the scope of the project:
- Business problem statement.
- Objectives of the pipeline and warehouse.
- Deliverables expected from the capstone.

### 0.0.raw_data
Contains the original CSV datasets provided by BrightLearn:
- Transactional sales data.
- Customer and product information.
- Raw files with missing values, duplicates, and inconsistencies.

### 0.1.data_architectural_plan
Outlines the architecture of the solution:
- High-level pipeline design (Extract, Transform, Load).
- Data flow diagrams.
- Technology stack selection (SQL Server, SSIS, GitHub for version control).

### 0.2.data_modeling
Includes data warehouse modeling artifacts:
- Star schema design for reporting.
- Entity-relationship diagrams.
- Table definitions and relationships.

### 0.3.data_quality_report
Documents the assessment of raw data quality:
- Completeness, accuracy, and consistency checks.
- Identification of duplicates and anomalies.
- Recommendations for cleaning and transformation.

### 1.0.scripts_sql
1.1.create_databases
1.2.exploratory_data_analysis
1.3.dim_tables
1.4.fact_table
1.5.stored_procedures
SQL scripts used in the project:
- Table creation scripts.
- Data cleaning queries.
- Schema definitions for the warehouse.

### 2.0.business_queries
Contains SQL queries for business reporting answering questions BQ-01 up to BQ-08:
- Sales performance analysis.
- Customer segmentation.
- Inventory and product trends.

### 3.0.ssis_pipeline/Bright Mart Pipeline
SSIS (SQL Server Integration Services) pipeline implementation:
- ETL packages for extracting raw CSV data.
- Transformation logic for cleaning and standardizing.
- Loading processes into the warehouse schema.

### 4.0.presentation
Final presentation materials:
- PowerPoint slides summarizing the project.
- Visuals of architecture, pipeline, and warehouse schema.
- Key findings and business insights.

### LICENSE and README.md
- **LICENSE** – Licensing information for the repository.
- **README.md** – This file, providing an overview of the project.

---

## 🛠️ Skills & Tools

![SQL](https://img.shields.io/badge/SQL-336791?logo=postgresql&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?logo=microsoftsqlserver&logoColor=white)
![SSIS](https://img.shields.io/badge/SSIS-CC2927?logo=microsoftsqlserver&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-217346?logo=microsoftexcel&logoColor=white)

---

## ⚙️ Dependencies and Environment Setup

### Software Requirements
- **SQL Server Management Studio (SSMS)**  
- **SQL Server Data Tools (SSDT)** with SSIS extension  
- **Microsoft Visual Studio** (for SSIS pipeline development)  
- **Git** (for version control)  

### Installation Steps
1. Install SQL Server and SSMS.  
2. Install Visual Studio with SSDT and SSIS extensions.  
3. Clone the repository:
   ```bash
   git clone https://github.com/Mpho0502/brightlearn-de-exam-mpho-matebesi.git
   ```bash
   git clone https://github.com/Mpho0502/brightlearn-de-exam-mpho-matebesi.git
