defmodule Loginservice.RegistrationTest do
  use Loginservice.DataCase

  alias Loginservice.Registration

  describe "campaigns" do
    alias Loginservice.Registration.Campaign

    @field_attrs %{title: "Interests", key: "interests", description: "Which interests do you have", type: "string"}
    @valid_attrs %{active: true, callback_url: "some callback_url", name: "some name", url: "some_url", fields: [@field_attrs], description_short: "short description"}
    @update_attrs %{active: true, callback_url: "some updated callback_url", name: "some updated name", url: "some_updated_url", description_short: "some updated description"}
    @invalid_attrs %{active: nil, callback_url: nil, name: nil, url: nil}

    def campaign_fixture(attrs \\ %{}) do
      {:ok, campaign} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Registration.create_campaign()

      campaign
    end

    test "list_campaigns/0 returns all campaigns" do
      campaign = campaign_fixture()
      assert Registration.list_campaigns() |> Enum.any?(fn(x) -> x == campaign end)
    end

    test "get_campaign!/1 returns the campaign with given id" do
      campaign = campaign_fixture()
      assert Registration.get_campaign!(campaign.id) == campaign
    end

    test "get_campaign_by_url/1 returns the campaign with the given url" do
      campaign = campaign_fixture()
      assert Registration.get_campaign_by_url!(campaign.url) == campaign
    end

    test "get_campaign_by_url/1 does not return inactive campaigns" do
      campaign = campaign_fixture(%{active: false})
      assert_raise Ecto.NoResultsError, fn -> Registration.get_campaign_by_url!(campaign.url) end
    end

    test "create_campaign/1 with valid data creates a campaign" do
      assert {:ok, %Campaign{} = campaign} = Registration.create_campaign(@valid_attrs)
      assert campaign.active == true
      assert campaign.callback_url == "some callback_url"
      assert campaign.name == "some name"
      assert campaign.url == "some_url"
    end

    test "create_campaign/1 with invalid url returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Registration.create_campaign(@valid_attrs |> Map.put(:url, "some invalid url"))
    end

    test "create_campaign/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Registration.create_campaign(@invalid_attrs)
    end

    test "create_campaign/1 with duplicate url returns an error" do
      assert {:ok, %Campaign{}} = Registration.create_campaign(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Registration.create_campaign(@update_attrs |> Map.put(:url, @valid_attrs.url))
    end
 
    test "update_campaign/2 with valid data updates the campaign" do
      campaign = campaign_fixture()
      assert {:ok, campaign} = Registration.update_campaign(campaign, @update_attrs)
      assert %Campaign{} = campaign
      assert campaign.active == true
      assert campaign.callback_url == "some updated callback_url"
      assert campaign.name == "some updated name"
      assert campaign.url == "some_updated_url"
    end

    test "update_campaign/2 with invalid data returns error changeset" do
      campaign = campaign_fixture()
      assert {:error, %Ecto.Changeset{}} = Registration.update_campaign(campaign, @invalid_attrs)
      assert campaign == Registration.get_campaign!(campaign.id)
    end

    test "delete_campaign/1 deletes the campaign" do
      campaign = campaign_fixture()
      assert {:ok, %Campaign{}} = Registration.delete_campaign(campaign)
      assert_raise Ecto.NoResultsError, fn -> Registration.get_campaign!(campaign.id) end
    end

    test "change_campaign/1 returns a campaign changeset" do
      campaign = campaign_fixture()
      assert %Ecto.Changeset{} = Registration.change_campaign(campaign)
    end
  end
end
