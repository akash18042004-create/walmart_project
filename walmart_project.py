import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df=pd.read_csv("C:/Users/akash/Downloads/NEW FILES/walmart_data.csv")
print(df.head())
print(df.shape)
print(df.describe())
print(df.info())

#delete duplicates
print("duplicates:",df.duplicated().sum())
df=df.drop_duplicates()
print("duplicates:",df.duplicated().sum())

#delete null
print("Null values:",df.isnull().sum())
df=df.dropna()
print("Null values:",df.isnull().sum())

#converting unit price str to float
df["unit_price"]=df["unit_price"].str.replace("$"," ").astype(float)
print(df.info())

#column="Total"
df["Total"]=df["unit_price"]*df["quantity"]
print(df.head())

#posgresql connection
from sqlalchemy import create_engine
import pandas as pd



print(df.head())
df.columns=df.columns.str.lower()
print(df.head(10))

engine = create_engine(
    "postgresql+psycopg2://postgres:akash123@localhost:5432/walmart_db"
)    

df.to_sql(
    "walmart_sales",
    engine,
    if_exists="replace",
    index=False
)

print("Export done") 

query = """
SELECT table_name
FROM information_schema.tables
WHERE table_schema='public'
"""

tables = pd.read_sql(query, engine)

print(tables)






































