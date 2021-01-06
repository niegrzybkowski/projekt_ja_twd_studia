import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
import plotly.express as px

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

user1 = pd.read_csv("../kacper.csv")

app.layout = html.Div([
    dcc.Markdown(children="# TWD projekt 3 dashboard"),
    html.Label("Siema"),
    dcc.RadioItems(options=[
        {"label": "Jakub", "value": "user1"},
        {"label": "Jan", "value": "user2"},
        {"label": "Kacper", "value": "user3"}
    ]),
    dcc.Graph(
        id="main",
        figure=px.histogram(user1, x="domain")
    )

])

if __name__ == '__main__':
    app.run_server(debug=True)
