defmodule AuthenticationKata.AccountsTest do
  use AuthenticationKata.DataCase

  alias AuthenticationKata.Accounts

  describe "users" do
    alias AuthenticationKata.Accounts.Users

    @valid_attrs %{email: "some email", firstname: "some firstname", lastname: "some lastname", password_hash: "some password_hash"}
    @update_attrs %{email: "some updated email", firstname: "some updated firstname", lastname: "some updated lastname", password_hash: "some updated password_hash"}
    @invalid_attrs %{email: nil, firstname: nil, lastname: nil, password_hash: nil}

    def users_fixture(attrs \\ %{}) do
      {:ok, users} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_users()

      users
    end

    test "list_users/0 returns all users" do
      users = users_fixture()
      assert Accounts.list_users() == [users]
    end

    test "get_users!/1 returns the users with given id" do
      users = users_fixture()
      assert Accounts.get_users!(users.id) == users
    end

    test "create_users/1 with valid data creates a users" do
      assert {:ok, %Users{} = users} = Accounts.create_users(@valid_attrs)
      assert users.email == "some email"
      assert users.firstname == "some firstname"
      assert users.lastname == "some lastname"
      assert users.password_hash == "some password_hash"
    end

    test "create_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_users(@invalid_attrs)
    end

    test "update_users/2 with valid data updates the users" do
      users = users_fixture()
      assert {:ok, users} = Accounts.update_users(users, @update_attrs)
      assert %Users{} = users
      assert users.email == "some updated email"
      assert users.firstname == "some updated firstname"
      assert users.lastname == "some updated lastname"
      assert users.password_hash == "some updated password_hash"
    end

    test "update_users/2 with invalid data returns error changeset" do
      users = users_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_users(users, @invalid_attrs)
      assert users == Accounts.get_users!(users.id)
    end

    test "delete_users/1 deletes the users" do
      users = users_fixture()
      assert {:ok, %Users{}} = Accounts.delete_users(users)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_users!(users.id) end
    end

    test "change_users/1 returns a users changeset" do
      users = users_fixture()
      assert %Ecto.Changeset{} = Accounts.change_users(users)
    end
  end
end
