defmodule Loginservice do
  @moduledoc """
  Loginservice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def random_url() do
    :crypto.strong_rand_bytes(32) |> Base.url_encode64 |> binary_part(0, 32)
  end


  def ecto_date_in_past(offset_seconds) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(-offset_seconds)
  end

  def test_nil(anything) when anything != nil, do: {:ok, anything}
  def test_nil(_anything), do: {:error, nil}
end
