defmodule IotConsumer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :iot_consumer,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :cowboy, :plug, :eventstore],
      mod: {IotConsumer, []},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:commanded, "~> 0.16"},
      {:commanded_ecto_projections, "~> 0.6"},
      {:commanded_eventstore_adapter, "~> 0.4"},
      {:cors_plug, "~> 1.5"},
      {:cowboy, "~> 1.0"},
      {:ecto, "~> 2.2"},
      {:eventstore, "~> 0.14"},
      {:gen_mqtt, "~> 0.4.0"},
      {:plug, "~> 1.4"},
      {:poison, "~> 3.1"},
      {:uuid, "~> 1.1"},
    ]
  end
end
