import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
import plotly.express as px
from dash.dependencies import Input, Output


external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

user1 = pd.read_csv("../kacper.csv")
user2 = None
user3 = None

DOMAINS = {"Stackoverflow": "stackoverflow.com",
           "Wikipedia": "wikipedia.org",
           "GitHub": "github.com",
           "Politechnika Warszawska": "pw.edu.pl",
           "Youtube": "youtube.com",
           "Google": "google.com",
           "Facebook": "facebook.com",
           "Instagram": "instagram.com"}


def to_dashformat(map: dict):
    out = []
    for key in map:
        out.append({"label": key, "value": map[key]})
    return out


app.layout = html.Div([
    dcc.Markdown(children="# TWD projekt 3 dashboard"),
    html.Label("Siema"),
    dcc.RadioItems(
        id="user-select",
        options=[
            {"label": "Jakub", "value": "user1"},
            {"label": "Jan", "value": "user2"},
            {"label": "Kacper", "value": "user3"}
        ]
    ),
    html.Label('Domeny'),
    dcc.Checklist(
        id="domain-select",
        options=to_dashformat(DOMAINS),
        value=["stackoverflow.com", "wikipedia.org", "github.com"]
    ),
    dcc.Graph(
        id="histogram",
        figure=px.histogram(user1, x="domain")
    ),
    dcc.Markdown(id="text",
    children="""
    test test test
    
    test 
    # test
    ## test
    ### test
    ```
    test
    ```
    """),
])


@app.callback(
    Output("histogram", "figure"),
    Input('domain-select', 'value')
)
def update_figure(selected):
    df_filter = user1[user1["domain"].isin(selected)]
    return px.histogram(df_filter, x="domain")


if __name__ == '__main__':
    app.run_server(debug=True)
