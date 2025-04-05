import pandas as pd
from dash import Dash, html, dcc
import plotly.express as px
from dash.dependencies import Input, Output

##lecture du fichier csv contenant les donnees du cac40 qui nous interessent
def read_data():
    return pd.read_csv("../bash_scraper/cac40.csv", names=["timestamp", "value"])

##creation de notre fig avec plotly express
df = read_data()
fig = px.line(df, x="timestamp", y="value", title="Évolution de l'indice CAC 40")

app = Dash(__name__)
app.layout = html.Div([
    html.H1("notre suivi en temps réel de l'indice CAC 40"),
    dcc.Graph(id="graph-cac40", figure=fig),
    dcc.Interval(
        id="interval-update",
        interval=5*60*1000,  # Maj ttess les 5 minutes en millisecondes
        n_intervals=0  # Initialisation
    )
])


@app.callback(
    Output("graph-cac40", "figure"),
    Input("interval-update", "n_intervals")
)
def update_graph(n):
    df = read_data()  # relire les données à chaque intervalle
    fig = px.line(df, x="timestamp", y="value", title="Évolution du CAC 40")
    return fig

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=8050)

