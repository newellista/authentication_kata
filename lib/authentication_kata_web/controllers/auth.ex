defmodule AuthenticationWebKata.Auth do
  import Comeonin.Argon2, only: [checkpw: 2]
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(AuthenticationKata.Accounts.Users, user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
      |> assign(:current_user, user)
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
  end

  def login_with_username_and_password(conn, email, password, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(AuthenticationKata.Accounts.Users, email: email)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        {:error, :not_found, conn}
    end
  end

  def logout(conn), do: configure_session(conn, drop: true)
end
