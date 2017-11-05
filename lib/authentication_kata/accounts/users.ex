defmodule AuthenticationKata.Accounts.Users do
  use Ecto.Schema
  import Ecto
  import Ecto.Changeset
  import Ecto.Query

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

  @doc false
  def save_changeset(%Users{} = users, attrs) do
    users
      |> cast(attrs, [:firstname, :lastname, :email, :password, :password_confirmation])
      |> validate_required([:firstname, :lastname, :email, :password, :password_confirmation])
      |> unique_constraint(:email)
      |> validate_format(:email, ~r/@/)
      |> validate_length(:password, min: 8)
      |> validate_passwords
      |> generate_password_hash
  end

  @doc false
  def update_changeset(%Users{} = users, attrs) do
    attrs |> IO.inspect
    users
      |> cast(attrs, [:firstname, :lastname, :email, :password, :password_confirmation])
      |> validate_required([:firstname, :lastname, :email])
      |> unique_constraint(:email)
      |> validate_format(:email, ~r/@/)
      |> validate_length(:password, min: 8)
      |> validate_passwords
      |> generate_password_hash
  end

  @doc false
  def update_no_password_changeset(%Users{} = users, attrs) do
    users
      |> cast(attrs, [:firstname, :lastname, :email])
      |> validate_required([:firstname, :lastname, :email])
      |> unique_constraint(:email)
      |> validate_format(:email, ~r/@/)
  end

  defp generate_password_hash(changeset) do
    password = get_change(changeset, :password)

    password_hash = Comeonin.Argon2.hashpwsalt(password)

    changeset |> put_change(:password_hash, password_hash)
  end

  defp validate_passwords(changeset) do
    password = get_change(changeset, :password)
    password_confirmation = get_change(changeset, :password_confirmation)

    if password == password_confirmation do
      changeset
    else
      changeset
        |> add_error(:password_confirmation, "Passwords don't match")
    end
  end
end
