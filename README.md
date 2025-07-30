# Power-Bi-Project

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
<!--[PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)-->
![MySQL](https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)
<!--[Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=tableau&logoColor=white) -->
<!--[Canva](https://img.shields.io/badge/Canva-00C4CC?style=for-the-badge&logo=canva&logoColor=white) -->
<!--[Microsoft PowerPoint](https://img.shields.io/badge/Microsoft%20PowerPoint-B7472A?style=for-the-badge&logo=microsoftpowerpoint&logoColor=white)-->
![Microsoft Excel](https://img.shields.io/badge/Microsoft%20Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)
![Google Sheets](https://img.shields.io/badge/Google%20Sheets-34A853?style=for-the-badge&logo=googlesheets&logoColor=white)
![VS Code](https://img.shields.io/badge/VSCode-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white)
<!--[Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white) -->
<!--[Prezi](https://img.shields.io/badge/Prezi-3181FF?style=for-the-badge&logo=prezi&logoColor=white) -->
![Microsoft SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)
![Windows Terminal](https://img.shields.io/badge/Windows%20Terminal-4D4D4D?style=for-the-badge&logo=windows&logoColor=white)

**🎯 Task Objective:** Create the derived table `blinkit_city_insights` using SQL by integrating and analyzing inventory data from Blinkit tables and creating a Power BI dashboard 

---

## 📁 Project Overview

This project involves writing complex SQL queries to process and transform raw product inventory data from Blinkit into actionable insights at the city level. The primary focus is on **estimating the quantity sold (`est_qty_sold`)** by analyzing inventory movement across timestamps. 

---

## 📂 Repository Contents
-
- `blinkit_city_insights_query.txt` — SQL script to generate the final `blinkit_city_insights` table.
- `blinkit_city_insights_output.csv` — Output of the derived table after executing the query on the cleaned data.
- `README.md` — This documentation file.

---

## 🧮 Input Tables

The project uses the following raw data tables:

1. **`all_blinkit_category_scraping_stream`**  
   Contains SKU-level inventory snapshots segmented by timestamp and store.

2. **`blinkit_categories`**  
   Provides mapping between category and subcategory IDs and their names.

3. **`blinkit_city_map`**  
   Maps each store ID to a corresponding city.

---

## 🏗️ Methodology

To estimate `est_qty_sold`, the following logic was used:

### ➤ Inventory Movement-Based Sales Estimation

- For each `(store_id, sku_id)` pair, the inventory difference between **consecutive timestamps** was calculated.

#### Case 1: Inventory Decreases  
- Interpreted as sales activity.
- `est_qty_sold = previous_inventory - current_inventory` (only if positive).

#### Case 2: Inventory Increases  
- Interpreted as restocking.
- Used **rolling average of past sales** from the same SKU at the same store to estimate the likely sales for that interval.

### ➤ Data Filtering
- Stores without a valid city mapping in `blinkit_city_map` were excluded.
- Only valid (non-null) and time-ordered inventory snapshots were used.

---

## 🧰 Tools & Technologies

- **SQLite**
- **CSV** for output export
- **Power Bi**
- **MS EXCEL**

---

## 📝 Instructions to Run

1. **Download & Load Data**
   - Download raw `.csv` files from this
   - Create corresponding tables in your local SQL setup and import the data.

2. **Run the SQL Query**
   - Executed `blinkit_city_insights_query.txt` in your local SQL client.
   - Exported the output as `blinkit_city_insights_output.csv`.



---

## 📌 Notes

- The logic for `est_qty_sold` is derived and heuristic-based, as there is no exact sales record available.
- All assumptions have been clearly commented in the SQL script.

---
