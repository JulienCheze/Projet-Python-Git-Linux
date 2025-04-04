from dash import Dash, html
app = Dash(__name__)
app.layout = html.Div([
    html.H1("Notre suivi en temps réel de l'indice CAC 40")
])
if __name__ == "__main__":
    app.run_server(debug=True)
