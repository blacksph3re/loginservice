defmodule LoginserviceWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import LoginserviceWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint LoginserviceWeb.Endpoint

      def map_inclusion(map_to_check, should_be_in_there) when is_map(should_be_in_there) do
        should_be_in_there
        |> Map.keys
        |> Enum.all?(fn(key) -> Map.has_key?(map_to_check, key) && Map.get(map_to_check, key) == Map.get(should_be_in_there, key) end)
      end

      def map_inclusion(map_to_check, should_be_in_there) when is_list(should_be_in_there) do
        should_be_in_there
        |> Enum.all?(fn(key) -> Map.has_key?(map_to_check, key) end)
      end

      def map_inclusion(map_to_check, should_be_in_there) do
        Map.has_key?(map_to_check, should_be_in_there)
      end
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Loginservice.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Loginservice.Repo, {:shared, self()})
    end
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end
