defmodule AuthenticationKata.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuthenticationKata.Accounts.Users


  schema "users" do
    field :email, :string, unique: true
    field :firstname, :string
    field :lastname, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%Users{} = users, attrs) do
    users
    |> cast(attrs, [:firstname, :lastname, :email, :password, :password_confirmation])
    |> validate_required([:firstname, :lastname, :email, :password, :password_confirmation])
    |> unique_constraint(:email)
  end
end
