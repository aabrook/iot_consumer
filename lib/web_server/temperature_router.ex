defmodule WebServer.TemperatureRouter do
  import Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch

  get "/temperatures" do
    conn
    |> fetch_query_params()
    |> WebServer.TemperatureReadings.all()
  end
end

