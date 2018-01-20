defmodule WebServer.Router do
  import Plug.Conn
  use Plug.Router

  plug Plug.Static, at: "/", from: "thermo-client/build"
  plug :match
  plug :dispatch

  forward "/temperatures", to: WebServer.TemperatureRouter

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, %{error: "Not found"} |> Poison.encode!())
  end

end
