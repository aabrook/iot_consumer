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

  get "/rooms" do
    conn
    |> WebServer.TemperatureReadings.rooms()
  end
end

