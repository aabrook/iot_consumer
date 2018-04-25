# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :iot_consumer, :ecto_repos, [IotConsumer.EventStoreRepo]

config :iot_consumer, IotConsumer.EventStoreRepo,
  adapter: Ecto.Adapters.Postgres,
  database: "eventstore",
  username: System.get_env("DATA_DB_USER"),
  password: System.get_env("DATA_DB_PASS"),
  hostname: System.get_env("DATA_DB_HOST")

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

import_config "#{Mix.env}.exs"
