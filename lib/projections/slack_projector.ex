defmodule Projections.SlackProjector do
  use Commanded.Projections.Ecto,
    name: "slack_projection",
    repo: IotConsumer.EventStoreRepo

  import Ecto.Query
  alias IotConsumer.EventStoreRepo, as: Repo

  project %ErrorAlerted{source: room, message: message} do
    %{status: status} =
      Projection.Error
      |> where(room: ^room)
      |> Repo.one()

    send_message("Alerting on room #{inspect(room)}: #{inspect message}")

    multi
  end

  project %ErrorResolved{source: room} do
    %{status: status} =
      Projection.Error
      |> where(room: ^room)
      |> Repo.one()

    if status == "alerted" do
      send_message("All good in room #{inspect(room)}")
    end

    multi
  end

  defp send_message(message) do
    Slack.Rtm.start(System.get_env("SLACK_API_TOKEN"))
    Slack.Web.Chat.post_message("general", message, %{username: "Hal"})
  end
end
