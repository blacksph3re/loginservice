defmodule Loginservice.AuthTest do
  use Loginservice.DataCase

  alias Loginservice.Auth

  describe "users" do
    alias Loginservice.Auth.User

    @valid_attrs %{email: "some@email.com", name: "some name", password: "some password", active: true, superadmin: false}
    @update_attrs %{email: "someupdated@email.com", name: "some updated name", password: "some updated password", active: true, superadmin: false}
    @invalid_attrs %{email: nil, name: nil, password: nil}
    @invalid_token "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJBbGFzdGFpciIsImV4cCI6MTUyMjg0NzMyMCwiaWF0IjoxNTIwNDI4MTIwLCJpc3MiOiJBbGFzdGFpciIsImp0aSI6IjI4ZDM3YTIyLTExMzEtNGFjNy04YTlmLWQ2YzU0YTEyZjM1OCIsIm5hbWUiOiJzb21lIG5hbWUiLCJuYmYiOjE1MjA0MjgxMTksInN1YiI6IjcyIiwidHlwIjoiYWNjZXNzIn0.CN5aB844O2_LgYF7Z4lmBOsurjSSBtCmHd2MisahmZkYPSP2AinlcRcCCMpw-wPs_frBi4nwzB-_0CCuNvtHqg"

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      Repo.get!(User, user.id)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() |> Enum.any?(fn(x) -> x == user end)
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.name == "some name"
      assert Loginservice.Auth.authenticate_user(user.name, "some password")
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "create_user/1 with invalid email returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@valid_attrs |> Map.put(:email, "invalid format email"))
    end

    test "create_user/1 with too short password returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@valid_attrs |> Map.put(:password, "1234"))
    end

    test "create_user/1 with duplicate email returns error" do
      assert {:ok, %User{}} = Auth.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@update_attrs |> Map.put(:email, @valid_attrs.email))
    end

    test "create_user/1 with duplicate username returns error" do
      assert {:ok, %User{}} = Auth.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@update_attrs |> Map.put(:name, @valid_attrs.name))
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Auth.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "someupdated@email.com"
      assert user.name == "some updated name"
      assert Loginservice.Auth.authenticate_user(user.name, "some updated password")
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end

    test "login user successfully" do
      user_fixture()
      assert Loginservice.Auth.login_user("some name", "some password")
    end

    test "refute bad credentials" do
      user_fixture()
      assert {:error, _msg} = Loginservice.Auth.login_user("some name", "some invalid password")
      assert {:error, _msg} = Loginservice.Auth.login_user("some invalid name", "some password")
    end

    test "login provides user with working access and refresh tokens" do
      user_fixture()
      assert {:ok, _user, access, refresh} = Loginservice.Auth.login_user("some name", "some password")
      assert {:ok, _user, _claims} = Loginservice.Auth.check_access_token(access)
      assert {:ok, _user, _claims} = Loginservice.Auth.check_refresh_token(refresh)
    end

    @tag only: true
    test "logout with access token provided invalidates that access token" do
      user_fixture()
      assert {:ok, _user, _access, refresh} = Loginservice.Auth.login_user("some name", "some password")
      assert {:ok, _user, refresh_db} = Loginservice.Auth.check_refresh_token(refresh)
      assert {:ok, _token} = Loginservice.Auth.logout_token(refresh_db.id)
      assert {:error, _msg} = Loginservice.Auth.check_refresh_token(refresh)
    end

    test "logout from all devices removes all access tokens" do
      user = user_fixture()
      assert {:ok, _user, _access, refresh} = Loginservice.Auth.login_user("some name", "some password")
      assert {:ok, _user, _refresh_db} = Loginservice.Auth.check_refresh_token(refresh)
      Loginservice.Auth.logout_user(user)
      assert {:error, _msg} = Loginservice.Auth.check_refresh_token(refresh)
    end

    test "check_access_token/1 refuses invalid tokens" do
      assert {:error, _msg} = Loginservice.Auth.check_access_token(@invalid_token)
    end

    test "check_refresh_token/1 refuses invalid tokens" do
      assert {:error, _msg} = Loginservice.Auth.check_access_token(@invalid_token)
      user_fixture()
      assert {:ok, _user, access, refresh} = Loginservice.Auth.login_user("some name", "some password")
      assert {:ok, _user, _claims} = Loginservice.Auth.check_access_token(access)
      assert {:ok, _user, _claims} = Loginservice.Auth.check_refresh_token(refresh)
      Repo.get_by(Loginservice.Auth.RefreshToken, token: refresh) |> Repo.delete!
      assert {:error, _msg} = Loginservice.Auth.check_refresh_token(refresh)
    end

    test "check_refresh_token/1 and check_access_token/1 both only accept their type of token" do
      user_fixture()
      assert {:ok, _user, access, refresh} = Loginservice.Auth.login_user("some name", "some password")
      assert {:ok, _user, _claims} = Loginservice.Auth.check_access_token(access)
      assert {:ok, _user, _claims} = Loginservice.Auth.check_refresh_token(refresh)

      assert {:error, _msg} = Loginservice.Auth.check_refresh_token(access)
      assert {:error, _msg} = Loginservice.Auth.check_access_token(refresh)
    end

    test "inactive user is rejected login" do
      user_fixture(%{active: false})
      assert {:error, _msg} = Loginservice.Auth.login_user("some name", "some password")
    end

  end
end