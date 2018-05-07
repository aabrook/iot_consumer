defmodule WebServer.Router do
  import Plug.Conn
  use Plug.Router

  plug CORSPlug
  plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Poison

  plug Plug.Logger
  plug Plug.Static, at: "/", from: "thermo-client/build"
  plug :match
  plug :dispatch

  forward("/api", to: Absinthe.Plug,
          init_opts: [schema: Api.Schema])
  forward("/graphiql", to: Absinthe.Plug.GraphiQL,
          init_opts: [schema: Api.Schema])

  forward "/temperatures", to: WebServer.TemperatureRouter

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, %{error: "Not found"} |> Poison.encode!())
  end

end
