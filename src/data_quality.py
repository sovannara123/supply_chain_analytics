import os
import sys
import pandas as pd
import psycopg2
from dotenv import load_dotenv

def get_connection():
    load_dotenv()
    try:
        conn = psycopg2.connect(
            host=os.environ.get("DB_HOST", "localhost"),
            port=os.environ.get("DB_PORT", "5432"),
            dbname=os.environ.get("DB_NAME", "supply_chain"),
            user=os.environ.get("DB_USER", "analyst_user"),
            password=os.environ.get("DB_PASSWORD", "analyst_user")
        )
        return conn
    except Exception as e:
        print(f"Error connecting to database: {e}")
        sys.exit(1)

def run_tests():
    print("=" * 50)
    print("Supply Chain Data Quality Checks")
    print("=" * 50)
    
    conn = get_connection()
    tests_passed = 0
    tests_failed = 0
    
    queries = {
        "Data Availability": "SELECT COUNT(*) FROM datacosupplychaindataset",
        "No Negative Benefit": "SELECT COUNT(*) FROM datacosupplychaindataset WHERE benefit_per_order < 0",
        "No Zero or Negative Sales": "SELECT COUNT(*) FROM datacosupplychaindataset WHERE sales <= 0",
        "No Negative Order Quantity": "SELECT COUNT(*) FROM datacosupplychaindataset WHERE order_item_quantity <= 0",
        "Shipped Before Ordered (Temporal Check)": "SELECT COUNT(*) FROM datacosupplychaindataset WHERE shipping_date < order_date",
        "Future Orders": "SELECT COUNT(*) FROM datacosupplychaindataset WHERE order_date > CURRENT_DATE"
    }
    
    try:
        # Check data availability
        df_count = pd.read_sql_query(queries["Data Availability"], conn)
        total_rows = df_count.iloc[0, 0]
        if total_rows > 0:
            print(f"[PASS] Data Availability: Found {total_rows} rows.")
            tests_passed += 1
        else:
            print(f"[FAIL] Data Availability: Table is empty or does not exist.")
            tests_failed += 1
            
        # Run anomaly checks
        for test_name, query in list(queries.items())[1:]:
            df = pd.read_sql_query(query, conn)
            count = df.iloc[0, 0]
            
            if count == 0:
                print(f"[PASS] {test_name}: 0 anomalies found.")
                tests_passed += 1
            else:
                print(f"[FAIL] {test_name}: Found {count} anomalies!")
                tests_failed += 1
                
        # Run duplicate check
        dup_query = """
            SELECT (COUNT(*) - COUNT(DISTINCT (order_id::TEXT || '|' || order_item_id::TEXT || '|' || product_card_id::TEXT))) 
            FROM datacosupplychaindataset
        """
        df_dup = pd.read_sql_query(dup_query, conn)
        dup_count = df_dup.iloc[0, 0]
        if dup_count == 0:
            print(f"[PASS] Duplicate Check: 0 duplicates found.")
            tests_passed += 1
        else:
            print(f"[FAIL] Duplicate Check: Found {dup_count} duplicate records.")
            tests_failed += 1
            
    except Exception as e:
        print(f"Error running queries: {e}")
        tests_failed += 1
    finally:
        conn.close()

    print("-" * 50)
    print(f"Summary: {tests_passed} Passed, {tests_failed} Failed.")
    print("=" * 50)
    
    if tests_failed > 0:
        sys.exit(1)
        
if __name__ == "__main__":
    run_tests()
