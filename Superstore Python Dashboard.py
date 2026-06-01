import pandas as pd
import plotly.express as px
import streamlit as st

# Page title
st.set_page_config(page_title="Superstore Dashboard", layout="wide")

st.title("Superstore Sales Dashboard")

# Load dataset
df = pd.read_excel(r"D:\python asmaa project\sample_superstore.xlsx")

# Convert Order Date
df['Order Date'] = pd.to_datetime(df['Order Date'])

# KPIs
total_sales = df['Sales'].sum()
total_profit = df['Profit'].sum()
total_orders = df['Order ID'].nunique()

# KPI Section
col1, col2, col3 = st.columns(3)

col1.metric("Total Sales", f"${total_sales:,.0f}")
col2.metric("Total Profit", f"${total_profit:,.0f}")
col3.metric("Total Orders", total_orders)

st.markdown("---")

# Sales by Category
sales_category = df.groupby('Category')['Sales'].sum().reset_index()

fig1 = px.bar(
    sales_category,
    x='Category',
    y='Sales',
    title='Sales by Category',
    text_auto=True
)

# Profit by Segment
profit_segment = df.groupby('Segment')['Profit'].sum().reset_index()

fig2 = px.pie(
    profit_segment,
    names='Segment',
    values='Profit',
    title='Profit by Segment'
)

# Monthly Sales Trend
monthly_sales = df.groupby(df['Order Date'].dt.to_period('M'))['Sales'].sum().reset_index()

monthly_sales['Order Date'] = monthly_sales['Order Date'].astype(str)

fig3 = px.line(
    monthly_sales,
    x='Order Date',
    y='Sales',
    title='Monthly Sales Trend'
)

# Top Products
top_products = df.groupby('Product Name')['Sales'].sum().sort_values(ascending=False).head(10)

top_products = top_products.reset_index()

fig4 = px.bar(
    top_products,
    x='Sales',
    y='Product Name',
    orientation='h',
    title='Top 10 Products'
)

# Layout
col4, col5 = st.columns(2)

col4.plotly_chart(fig1, use_container_width=True)
col5.plotly_chart(fig2, use_container_width=True)

st.plotly_chart(fig3, use_container_width=True)
st.plotly_chart(fig4, use_container_width=True)