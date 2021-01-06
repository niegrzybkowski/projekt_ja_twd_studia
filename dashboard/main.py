import dash
import dash_core_components as dcc
import dash_html_components as html

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)


app.layout = html.Div([
    dcc.Markdown(children="# TWD projekt 3 dashboard"),
    html.Label("Siema"),
    dcc.RadioItems(options=[
        {"label": "No siema", "value": "nsiema"},
        {"label": "Elo", "value": "elo"},
        {"label": "Witam", "value": "w"}
    ])

])

if __name__ == '__main__':
    app.run_server(debug=True)
