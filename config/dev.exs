use Mix.Config

config :eventstore, EventStore.Storage,
  serializer: EventStore.TermSerializer,
  username: "postgres",
  password: "password",
  database: "eventstore_dev",
  hostname: "localhost",
  pool_size: 10,
  pool_overflow: 5
