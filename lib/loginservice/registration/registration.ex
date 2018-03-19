defmodule Loginservice.Registration do
  @moduledoc """
  The Registration context.
  """

  import Ecto.Query, warn: false
  alias Loginservice.Repo

  alias Loginservice.Registration.Campaign
  alias Loginservice.Registration.MailConfirmation
  alias Loginservice.Registration.Submission

  @doc """
  Returns the list of campaigns.

  ## Examples

      iex> list_campaigns()
      [%Campaign{}, ...]

  """
  def list_campaigns do
    Repo.all(Campaign)
  end

  @doc """
  Gets a single campaign.

  Raises `Ecto.NoResultsError` if the Campaign does not exist.

  ## Examples

      iex> get_campaign!(123)
      %Campaign{}

      iex> get_campaign!(456)
      ** (Ecto.NoResultsError)

  """
  def get_campaign!(id), do: Repo.get!(Campaign, id)

  # Gets a campaign by url
  def get_campaign_by_url!(campaign_url), do: Repo.get_by!(Campaign, url: campaign_url, active: true)


  @doc """
  Creates a campaign.

  ## Examples

      iex> create_campaign(%{field: value})
      {:ok, %Campaign{}}

      iex> create_campaign(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_campaign(attrs \\ %{}) do
    %Campaign{}
    |> Campaign.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a campaign.

  ## Examples

      iex> update_campaign(campaign, %{field: new_value})
      {:ok, %Campaign{}}

      iex> update_campaign(campaign, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_campaign(%Campaign{} = campaign, attrs) do
    campaign
    |> Campaign.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Campaign.

  ## Examples

      iex> delete_campaign(campaign)
      {:ok, %Campaign{}}

      iex> delete_campaign(campaign)
      {:error, %Ecto.Changeset{}}

  """
  def delete_campaign(%Campaign{} = campaign) do
    Repo.delete(campaign)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking campaign changes.

  ## Examples

      iex> change_campaign(campaign)
      %Ecto.Changeset{source: %Campaign{}}

  """
  def change_campaign(%Campaign{} = campaign) do
    Campaign.changeset(campaign, %{})
  end

  def get_confirmation_by_url!(confirmation_url) do
    Repo.get_by!(MailConfirmation, url: confirmation_url)
    |> Repo.preload([submission: [:campaign, :user]])
  end

  def create_submission(campaign, user, responses) do
    attrs = %{responses: responses,
      user_id: user.id,
      campaign_id: campaign.id
    }

    %Submission{}
    |> Submission.changeset(attrs)
    |> Repo.insert()
  end

  def send_confirmation_mail(user, submission) do
    with {:ok, confirmation} <- create_confirmation_object(submission),
      {:ok} <- dispatch_confirmation_mail(user, confirmation),
    do: {:ok, confirmation}
  end

  defp dispatch_confirmation_mail(user, confirmation) do
    url = Application.get_env(:loginservice, :url_prefix) <> confirmation.url
    case Loginservice.Interfaces.Mail.send_mail(user.email, "Confirm your email address", "To confirm your email, visit " <> url) do
      true -> {:ok}
      false -> {:error, "Could not dispatch mail"}
    end
  end

  defp create_confirmation_object(submission) do
    %MailConfirmation{}
    |> MailConfirmation.changeset(%{submission_id: submission.id})
    |> Repo.insert()
  end

  def confirm_mail(confirmation) do
    confirmation.submission
    |> Submission.changeset(%{mail_confirmed: true})
    |> Repo.update!

    confirmation.submission.user
    |> Loginservice.Auth.User.changeset(%{active: true})
    |> Repo.update!

    confirmation 
    |> Repo.delete!

    {:ok}
  end
end
