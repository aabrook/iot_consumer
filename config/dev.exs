use Mix.Config

config :eventstore, EventStore.Storage,
  serializer: EventStore.JsonSerializer,
  username: System.get_env("DATA_DB_USER") || "postgres",
  password: System.get_env("DATA_DB_PASS") || "password",
  database: "eventstore",
  hostname: System.get_env("DATA_DB_HOST") || "localhost",
  pool_size: 10,
  pool_overflow: 5
