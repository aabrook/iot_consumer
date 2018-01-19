defmodule EventStore.JsonSerializer do
  @moduledoc """
  A serializer that uses the JSON format.
  """

  @behaviour EventStore.Serializer

  @doc """
  Serialize given term to JSON binary data.
  """
  def serialize(term) do
    Poison.encode!(term)
  end

  @doc """
  serialize given JSON binary data to the expected type.
  """
  def deserialize(binary, config) do
    Poison.decode!(binary)
  end
end
