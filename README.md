# Power-Bi-Project

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
   - Execute `blinkit_city_insights_query.txt` in your local SQL client.
   - Export the output as `blinkit_city_insights_output.csv`.

3. **Submit**
   - Upload both `.txt` and `.csv` files through this [submission form](https://docs.google.com/forms/d/e/1FAIpQLSevF_nBbFT7MtXdncjNSoSk9iFKOXdu3zzUcYxmPwEAUIsoXw/viewform?usp=dialog).

---

## 📌 Notes

- The logic for `est_qty_sold` is derived and heuristic-based, as there is no exact sales record available.
- All assumptions have been clearly commented in the SQL script.

---
