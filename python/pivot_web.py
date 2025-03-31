import os
import datetime
import pandas as pd

import streamlit as st

import pivot_xlsx
import read_settings
import pivotea.pivot as pivot # pip install git+https://github.com/matutosi/pivoteapy.git

# Set title
st.title("Pivotea")

# col1, col2 = st.columns(2)
tabs = ["data", "pivot"]
tab_data, tab_pivot = st.tabs(tabs)

settings = st.sidebar

with settings:
    # File uploader for input Excel file
    uploaded_file = st.file_uploader("Upload an Excel file", type=["xlsx"])
    if uploaded_file:
        df_input, setting = pivot_xlsx.pivot_xlsx(uploaded_file)
        items = df_input.columns
        if setting is None:
            # Read the uploaded Excel file
            # items = df_input.columns
            rows   = st.multiselect("row(s)"  , items)
            cols   = st.multiselect("col(s)"  , items)
            values = st.multiselect("value(s)", items)
            splits = st.multiselect("split(s)", items)
        else:
            rows   = st.multiselect("row(s)"  , options=items, default=setting["row"]  )
            cols   = st.multiselect("col(s)"  , options=items, default=setting["col"]  )
            values = st.multiselect("value(s)", options=items, default=setting["value"])
            splits = st.multiselect("split(s)", options=items, default=setting["split"])
        # Display the input DataFrame

with tab_data:
    if uploaded_file:
        st.dataframe(df_input)

with tab_pivot:
    if uploaded_file:
        pivoted = pivot(df_input, row = rows, col = cols, value = values, split = splits)
        st.write(pivoted)
