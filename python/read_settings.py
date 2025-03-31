import pandas as pd

def read_settings(wb, sheet, colnames):
    ws = wb[sheet]
    df = pd.DataFrame(ws.values, columns=colnames)
    values = []
    for col in colnames:
        if col in df.columns:
          values.append(df[col])
    return tuple(values)
