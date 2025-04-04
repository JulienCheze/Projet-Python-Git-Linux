import pandas as pd
from dash import Dash, html
import plotly.express as px

#lecture du fichier csv contenant les donnees du cac40 qui nous interessent
df = pd.read_csv("../bash_scraper/cac40.csv", names=["timestamp", "value"])

#creation de notre fig avec plotly express
fig = px.line(df, x="timestamp", y="value", title="Évolution de l'indice CAC 40")


app = Dash(__name__)
app.layout = html.Div([
    html.H1("Notre suivi en temps réel de l'indice CAC 40"),
dcg.Graph(id="graph-cac40",figure=fig)
])
if __name__ == "__main__":
    app.run_server(debug=True)
