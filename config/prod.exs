use Mix.Config

config :eventstore, EventStore.Storage,
  serializer: EventStore.JsonSerializer,
  username: System.get_env("DATA_DB_USER"),
  password: System.get_env("DATA_DB_PASS"),
  database: "eventstore",
  hostname: System.get_env("DATA_DB_HOST"),
  pool_size: 10,
  pool_overflow: 5
