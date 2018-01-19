defmodule WebServer.TemperatureRouter do
  import Plug.Conn
  use Plug.Router

  plug WebServer.SuperSimpleAuth
  plug :match
  plug :dispatch

  get "/temperatures" do
    conn
    |> fetch_query_params()
    |> WebServer.TemperatureReadings.all()
  end

  get "/temperatures/latest" do
    conn
    |> fetch_query_params()
    |> WebServer.TemperatureReadings.latest()
  end
end

