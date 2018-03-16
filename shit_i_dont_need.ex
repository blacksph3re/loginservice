  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  
  @doc """
  Returns the list of examples.

  ## Examples

      iex> list_examples()
      [%Example{}, ...]

  """
  def list_examples do
    Repo.all(Example)
  end

  @doc """
  Gets a single example.

  Raises `Ecto.NoResultsError` if the Example does not exist.

  ## Examples

      iex> get_example!(123)
      %Example{}

      iex> get_example!(456)
      ** (Ecto.NoResultsError)

  """
  def get_example!(id), do: Repo.get!(Example, id)

  @doc """
  Creates a example.

  ## Examples

      iex> create_example(%{field: value})
      {:ok, %Example{}}

      iex> create_example(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_example(attrs \\ %{}) do
    %Example{}
    |> Example.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a example.

  ## Examples

      iex> update_example(example, %{field: new_value})
      {:ok, %Example{}}

      iex> update_example(example, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_example(%Example{} = example, attrs) do
    example
    |> Example.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Example.

  ## Examples

      iex> delete_example(example)
      {:ok, %Example{}}

      iex> delete_example(example)
      {:error, %Ecto.Changeset{}}

  """
  def delete_example(%Example{} = example) do
    Repo.delete(example)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking example changes.

  ## Examples

      iex> change_example(example)
      %Ecto.Changeset{source: %Example{}}

  """
  def change_example(%Example{} = example) do
    Example.changeset(example, %{})
  end