# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :iot_consumer, :ecto_repos, [IotConsumer.EventStoreRepo,EventStore.EventStoreRepo]

config :eventstore, column_data_type: "jsonb"
config :eventstore, EventStore.Storage,
  serializer: EventStore.JsonbSerializer,
  types: EventStore.PostgresTypes

config :iot_consumer, EventStore.EventStoreRepo,
  adapter: Ecto.Adapters.Postgres,
  database: "eventstore",
  username: System.get_env("DATA_DB_USER"),
  password: System.get_env("DATA_DB_PASS"),
  hostname: System.get_env("DATA_DB_HOST")

config :iot_consumer, IotConsumer.EventStoreRepo,
  adapter: Ecto.Adapters.Postgres,
  database: "temperatures",
  username: System.get_env("DATA_DB_USER"),
  password: System.get_env("DATA_DB_PASS"),
  hostname: System.get_env("DATA_DB_HOST")

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :slack, api_token: System.get_env("SLACK_API_TOKEN")

import_config "#{Mix.env}.exs"
