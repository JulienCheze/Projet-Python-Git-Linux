import pandas as pd
from dash import Dash, html, dcc, dash_table
import plotly.express as px
from dash.dependencies import Input, Output

def read_data():
    df = pd.read_csv("../bash_scraper/btc.csv", names=["timestamp", "value"])
    df = df.dropna(subset=["timestamp", "value"])
    df["timestamp"] = pd.to_datetime(df["timestamp"], errors="coerce") + pd.Timedelta(hours=2)
    df = df.dropna(subset=["timestamp"])
    df["value"] = pd.to_numeric(df["value"], errors="coerce")
    df = df.dropna(subset=["value"])
    return df


def read_summary():
    return pd.read_csv("../bash_scraper/daily_summary.csv")

app = Dash(__name__)

app.layout = html.Div([
    html.H1("Dashboard Bitcoin - Prix en temps réel"),

    html.H2("📈 Évolution du prix du BTC"),
    dcc.Graph(id="graph-btc"),

    html.H2("📊 Volatilité journalière"),
    dcc.Graph(id="graph-volatility"),

    html.H2("📋 Résumé quotidien"),
    html.Div(id="summary-table"),

    dcc.Interval(
        id="interval-update",
        interval=5*60*1000,  # 5 minutes
        n_intervals=0
    )
])

@app.callback(
    Output("graph-btc", "figure"),
    Output("graph-volatility", "figure"),
    Output("summary-table", "children"),
    Input("interval-update", "n_intervals")
)
def update(n):
    df = read_data()
    df_summary = read_summary()

    fig_btc = px.line(df, x="timestamp", y="value", title="Évolution du BTC")
    fig_volatility = px.bar(df_summary, x="date", y="volatility", title="Volatilité journalière")

    table = dash_table.DataTable(
        columns=[{"name": i, "id": i} for i in df_summary.columns],
        data=df_summary.to_dict('records'),
        style_table={'overflowX': 'auto'},
        style_cell={'textAlign': 'center'}
    )

    return fig_btc, fig_volatility, table

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=8050)

