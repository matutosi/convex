import pandas as pd
import openpyxl # Need to read xlsx

import read_settings

def read_wb_pivot(wb):
    sheets = wb.sheetnames
    df_input = read_data_pivot(wb, sheets)
    setting = read_setting_pivot(wb, sheets)
    return df_input, setting

def read_data_pivot(wb, sheets):
    data_sheet = "data"
    if data_sheet in sheets:
        ws = wb[data_sheet]
    else:
        setting_sheet = "setting_for_pivotea"
        sheets = [sheet for sheet in sheets if sheet != setting_sheet]
        ws = wb[sheets[0]]
    data = ws.values
    columns = next(data)[0:]
    df = pd.DataFrame(data, columns=columns)
    return df

def read_setting_pivot(wb, sheets):
    setting_sheet = "setting_for_pivotea"
    if setting_sheet in sheets:
        colnames = ["position", "item"]
        position, item = read_settings.read_settings(wb, sheet=setting_sheet, colnames=colnames)
        df_setting = pd.concat([position, item], axis=1)
        setting = df_to_setting(df_setting)
    else:
        setting = None
    return setting

def pivot_xlsx(uploaded_file):
    out_xlsx = uploaded_file.name.replace(".xlsx", "_pivoted.xlsx")
    wb = openpyxl.load_workbook(uploaded_file)
    df_input, setting = read_wb_pivot(wb)    
    return df_input, setting
    # wb.save(out_xlsx)
    # return out_xlsx

def df_to_setting(df):
    """
    Converts a DataFrame into a dictionary of settings.

    Args:
        df (pd.DataFrame): A DataFrame with at least two columns:
            - 'pos': The position or category to group by.
            - 'item': The items to aggregate into lists.

    Returns:
        dict: A dictionary where keys are unique values from the 'pos' column,
              and values are lists of corresponding 'item' values.
    """
    setting = df.groupby("position")["item"].apply(list)
    return setting.to_dict()
