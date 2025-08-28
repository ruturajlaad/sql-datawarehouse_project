# Data Warehouse & Analytics Project  

Welcome! 🚀  
This project showcases a complete data journey — from building a robust warehouse to uncovering actionable insights.  
Designed as a portfolio project, it reflects real-world best practices in data engineering and analytics.  


## 🏗️ Data Architecture  

The data architecture follows the **Medallion Architecture**:  
<img width="898" height="760" alt="image" src="https://github.com/user-attachments/assets/0b4048a9-8c83-4ba3-adb1-9574316b3b96" />


- **Bronze Layer** → Stores raw data ingested as-is from CSV files into SQL Server.  
- **Silver Layer** → Applies data cleansing, standardization, and normalization to make data analysis-ready.  
- **Gold Layer** → Houses business-ready data modeled into a **star schema** for reporting and analytics.  

---

## 📖 Project Overview  

This project involves:  
- **Data Architecture**: Designing a Modern Data Warehouse with Medallion layers.  
- **ETL Pipelines**: Extracting, transforming, and loading data into SQL Server.  
- **Data Modeling**: Building fact and dimension tables for analytical queries.  
- **Analytics & Reporting**: Writing SQL-based reports and creating dashboards for insights.  

---

## 🎯 Skills Demonstrated  

This repository is an excellent portfolio piece to showcase skills in:  
- SQL Development  
- Data Architecture  
- Data Engineering  
- ETL Pipelines  
- Data Modeling  
- Data Analytics  

---

## 🛠️ Tools & Resources (Free to Use)  

- **Datasets** → Provided CSV files for ERP & CRM data.  
- **Postgres** 
- **GitHub** → Version control & project collaboration.  
- **DrawIO** → For architecture diagrams and data modeling.  
- **Notion** → Project management & documentation templates.  

---

## 🚀 Project Requirements  

**Objective**  
Build a SQL Server Data Warehouse that consolidates sales data to enable reporting and informed decision-making.  

**Specifications**  
- **Data Sources**: ERP & CRM data (CSV files).  
- **Data Quality**: Cleanse and fix inconsistencies before analysis.  
- **Integration**: Merge both sources into a single, user-friendly star schema.  
- **Scope**: Focus only on the latest dataset (no historization).  
- **Documentation**: Provide clear explanation of the data model for stakeholders and analysts.  

---

## 📂 Repository Structure

<img width="909" height="588" alt="image" src="https://github.com/user-attachments/assets/fe2fb9c3-8353-4cf3-8341-3fca22346942" />


# init_database.sql

This script initializes the **Datawarehouse** PostgreSQL database and sets up the required schemas for a **data lakehouse-style architecture**.

## Schemas Created

- **bronze** → Raw ingested data  
- **silver** → Cleaned and processed data  
- **gold** → Curated, analytics-ready data  

## Usage

Run the script usin

## 🛡️ License  

This project is licensed under the **MIT License**. Feel free to use, modify, and share with proper attribution.  

---
