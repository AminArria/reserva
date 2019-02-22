defmodule ReservaWeb.UserController do
  use ReservaWeb, :controller
  alias Reserva.User

  def new(conn, _params) do
    usbid = get_session(conn, :cas_user)
    user = User.changeset(%User{}, %{usbid: usbid})
    render conn, "new.html", user: user
  end

  def create(conn, %{"user" => user_params}) do
    case User.create_user(user_params) do
      {:ok, _} ->
        redirect conn, to: Routes.page_path(conn, :index)
      {:error, changeset} ->
        render conn, "new.html", user: changeset
    end
  end
end
