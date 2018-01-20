defmodule WebServer.TemperatureRouter do
  import Plug.Conn
  use Plug.Router

  plug CORSPlug
  plug WebServer.SuperSimpleAuth
  plug :match
  plug :dispatch

  get "/" do
    conn
    |> fetch_query_params()
    |> WebServer.TemperatureReadings.all()
  end

  get "/latest" do
    conn
    |> fetch_query_params()
    |> WebServer.TemperatureReadings.latest()
  end
end

