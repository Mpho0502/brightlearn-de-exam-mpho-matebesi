# BrightLearn Data Engineering Exam – Mpho Matebesi

This repository contains the **Data Engineering Capstone Exam Project** for BrightLearn, a South African retail chain.  
The project addresses the challenge of **transactional data stored in flat CSV files with quality issues**.  
The goal is to design and implement a **clean data pipeline and warehouse** to support reporting and decision-making.

---

## 📂 Repository Structure

### 0.0.0.project_scope
- Defines the scope of the project:
  - Business problem statement.
  - Objectives of the pipeline and warehouse.
  - Deliverables expected from the capstone.

### 0.0.raw_data
- Contains the original CSV datasets provided by BrightLearn:
  - Transactional sales data.
  - Customer and product information.
  - Raw files with missing values, duplicates, and inconsistencies.

### 0.1.data_architectural_plan
- Outlines the architecture of the solution:
  - High-level pipeline design (Extract, Transform, Load).
  - Data flow diagrams.
  - Technology stack selection (SQL Server, SSIS, GitHub for version control).

### 0.2.data_modeling
- Includes data warehouse modeling artifacts:
  - Star schema design for reporting.
  - Entity-relationship diagrams.
  - Table definitions and relationships.

#### 📐 Star Schema Diagram

![BrightMart Star Schema](attachments/2j8YjVgmLpmTgZyiaoht6.jpeg)

---

#### 🗂️ Raw Data Snapshots

**Customer & Transaction Data**

![BrightLearn Raw Data – Transactions](attachments/qgmjV9zhUH4PPKZXfapbt.png)

---

**Product & Inventory Data**

![BrightLearn Raw Data – Products](attachments/ak5MrnFj64pAVioDKTKfs.png)

---

**Dimension & Fact Table Breakdown**

![BrightLearn Raw Data – Dimensions & Fact](attachments/HdVwggnyVioqBwi5mJF4y.png)

---

## 📜 SQL Scripts Execution Order

Scripts are located in **1.0.scripts_sql** and should be executed in the following order:

1. **1.1.create_databases** – Create databases and schemas.  
2. **1.2.exploratory_data_analysis** – Explore raw data and identify issues.  
3. **1.3.dim_tables** – Create dimension tables in the staging then into the datawarehouse once cleaned.  
4. **1.4.fact_table** – Create fact tables for transactional data.  
5. **1.5.stored_procedures** – Implement stored procedures for automation and reporting.

---

## 📊 Business Queries

Located in **2.0.business_queries**, answering questions **BQ-01 to BQ-08**:
- Sales performance analysis.
- Customer segmentation.
- Inventory and product trends.

---

## 🔄 SSIS Pipeline – Bright Mart Pipeline

Located in **3.0.ssis_pipeline**:
- ETL packages for extracting raw CSV data.
- Transformation logic for cleaning and standardizing.
- Loading processes into the warehouse schema.

#### ✅ Successful Pipeline Execution

![Bright Mart SSIS Pipeline Execution](attachments/WHcXvLWmRormDbiXWvtau.png)

---

## 🎤 Presentation

Located in **4.0.presentation**:
- PowerPoint slides summarizing the project.
- Visuals of architecture, pipeline, and warehouse schema.
- Key findings and business insights.

---

## 📐 Data Pipeline Architecture

![BrightLearn Data Pipeline Architecture](https://copilot.microsoft.com/th/id/BCO.bba6b659-cbf6-4f32-9b06-595811ebed2f.png)

---

## 🧠 Skills Showcase

| **Skill** | **Description** | **Proficiency** |
|------------|-----------------|-----------------|
| **[SQL](ca://s?q=Learn_more_about_SQL)** | Querying, cleaning, and transforming data for analysis and reporting. | ⭐⭐⭐⭐ |
| **[SQL Server](ca://s?q=Explore_SQL_Server_features)** | Database design, schema creation, and stored procedure development. | ⭐⭐⭐⭐ |
| **[SSIS](ca://s?q=Understand_SSIS_ETL_processes)** | Building ETL pipelines for data extraction, transformation, and loading. | ⭐⭐⭐⭐ |
| **[Data Modeling](ca://s?q=Explain_star_schema_modeling)** | Designing star schemas and entity relationships for data warehouses. | ⭐⭐⭐ |
| **[Power BI](ca://s?q=Power_BI_dashboard_design)** | Creating dashboards and visual reports for business insights. | ⭐⭐⭐ |
| **[GitHub](ca://s?q=Best_practices_for_GitHub_version_control)** | Version control and project collaboration. | ⭐⭐⭐⭐ |

---

## 🏅 Tech Stack Badges

![SQL](https://img.shields.io/badge/SQL-Structured%20Query%20Language-blue?style=for-the-badge&logo=database)
![SQL Server](https://img.shields.io/badge/SQL%20Server-Microsoft%20Database-red?style=for-the-badge&logo=microsoftsqlserver)
![SSIS](https://img.shields.io/badge/SSIS-Integration%20Services-orange?style=for-the-badge&logo=microsoft)
![Power BI](https://img.shields.io/badge/Power%20BI-Business%20Intelligence-yellow?style=for-the-badge&logo=powerbi)
![Excel](https://img.shields.io/badge/Excel-Data%20Analysis-green?style=for-the-badge&logo=microsoftexcel)
![GitHub](https://img.shields.io/badge/GitHub-Version%20Control-black?style=for-the-badge&logo=github)
![Visual Studio](https://img.shields.io/badge/Visual%20Studio-Development%20Environment-purple?style=for-the-badge&logo=visualstudio)

---

## 💼 Professional Highlights
- Designed and implemented a **complete ETL pipeline** using SSIS and SQL Server.
- Built a **data warehouse** optimized for BrightLearn’s retail analytics.
- Delivered **business intelligence reports** that support strategic decisions.
- Documented every stage with clear, human-written explanations and visuals.

---

## ⚙️ Dependencies and Environment Setup

### Software Requirements
- SQL Server Management Studio (SSMS)  
- SQL Server Data Tools (SSDT) with SSIS extension  
- Microsoft Visual Studio (for SSIS pipeline development)  
- Git (for version control)  

### Installation Steps
1. Install SQL Server and SSMS.  
2. Install Visual Studio with SSDT and SSIS extensions.  
3. Clone the repository:

```bash
git clone https://github.com/Mpho0502/brightlearn-de-exam-mpho-matebesi.git
