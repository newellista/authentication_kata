defmodule AuthenticationKataWeb.SessionController do
  use AuthenticationKataWeb, :controller

  alias AuthenticationWebKata.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Auth.login_with_username_and_password(conn, email, password, repo: AuthenticationKata.Repo) do
      {:ok, conn} ->
        conn
          |> put_flash(:info, "Welcome back")
          |> redirect(to: page_path(conn, :index))
        {:error, _reason, conn} ->
          conn
            |> put_flash(conn, "Invalid Username/Password")
            |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
