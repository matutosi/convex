import os
import streamlit as st
import highlight_xlsx

uploaded_file = st.file_uploader("Upload excel a file", type="xlsx", accept_multiple_files=False)

keywords = st.text_input("Input keyword(s) to be highlighted", placeholder="separate by ; (e.g., keyword1;keyword2)")
exact = st.checkbox("Exact match")

color = st.color_picker("Select a color", "#FFFF00")

if uploaded_file is not None:
    path_highlighted = highlight_xlsx.highlight_xlsx(uploaded_file, keywords, color, exact=exact)
    st.download_button('DOWNLOAD HIGHLIGHTED FILE', open(path_highlighted, 'br'), path_highlighted)
