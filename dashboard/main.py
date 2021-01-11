import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
import plotly.express as px
from dash.dependencies import Input, Output

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

kacper = pd.read_csv("../kacper.csv")
kacperCount = pd.read_csv("../kacperCount.csv")
jakub = pd.read_csv("../jakub.csv")
jakubCount = pd.read_csv("../jakubCount.csv")
jan = pd.read_csv("../jan.csv")
janCount = pd.read_csv("../janCount.csv")

DOMAINS = {"Stackoverflow": "stackoverflow.com",
           "Wikipedia": "wikipedia.org",
           "GitHub": "github.com",
           "Politechnika Warszawska": "pw.edu.pl",
           "Youtube": "youtube.com",
           "Google": "google.com",
           "Facebook": "facebook.com",
           "Instagram": "instagram.com"}


def to_dashformat(mapa: dict):
    out = []
    for key in mapa:
        out.append({"label": key, "value": mapa[key]})
    return out


def make_totalplot(selected_domains: [str]):
    total_df = None
    px.line(total_df)


def make_perplot():
    pass


app.layout = html.Div([
    dcc.Markdown(children="# TWD projekt 3 dashboard"),

    dcc.Markdown(children="## Total usage over time"),
    dcc.Graph(
        id="TotalLineplot",
        figure=px.histogram(kacper, x="domain")  # todo: wygenerować lineplot
    ),
    html.Label("Choose which sites to sum"),
    dcc.Dropdown(
        options=to_dashformat(DOMAINS),
        multi=True,
        value=[i for i in DOMAINS.values()]
    ),

    dcc.Markdown(children="## Per weekday/hour usage"),
    html.Div([
        html.Div([
            html.Label("Choose person"),
            dcc.RadioItems(
                id="user-select",
                options=[
                    {"label": "Jakub", "value": "user1"},
                    {"label": "Jan", "value": "user2"},
                    {"label": "Kacper", "value": "user3"}
                ]
            ),
            html.Label("test tttttttttttt ttttttttttt tttttttttttt")  # todo: this shit dont work
        ], style={"width": "16rem", "height": "100rem"}),
        html.Br(),
        dcc.Graph(
            id="PerDayBarplot",
            figure=px.histogram(kacper, x="domain")  # todo: wygenerować plot
        )
    ], style={"columnCount": 2}),

    # zostawiam ten bałagan na razie
    html.Label('Domeny'),
    dcc.Checklist(
        id="domain-select",
        options=to_dashformat(DOMAINS),
        value=["stackoverflow.com", "wikipedia.org", "github.com"]
    ),
    dcc.Graph(
        id="histogram",
        figure=px.histogram(kacper, x="domain")
    )
])


@app.callback(
    Output("histogram", "figure"),
    Input('domain-select', 'value')
)
def update_figure(selected):
    df_filter = kacper[kacper["domain"].isin(selected)]
    return px.histogram(df_filter, x="domain")


if __name__ == '__main__':
    app.run_server(debug=True)
