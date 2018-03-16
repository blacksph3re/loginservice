defmodule Loginservice do
  @moduledoc """
  Loginservice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def test_nil(anything) when anything != nil, do: {:ok, anything}
  def test_nil(_anything), do: {:error, nil}
end
