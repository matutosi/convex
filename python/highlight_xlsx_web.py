import os
import streamlit as st
import highlight_xlsx

keywords = st.text_input("Input keyword(s) to be highlighted", value=" ", placeholder="separate by ; (e.g., keyword1;keyword2)")
color = st.color_picker("Select a color", "#FFFF00")
exact = st.checkbox("Exact match")

uploaded_file = st.file_uploader("Upload excel a file", type="xlsx")

if uploaded_file is not None:
    path_highlighted = highlight_xlsx.highlight_xlsx(uploaded_file, keywords, color, exact=exact)
    st.download_button('DOWNLOAD HIGHLIGHTED FILE', open(path_highlighted, 'br'), path_highlighted)
