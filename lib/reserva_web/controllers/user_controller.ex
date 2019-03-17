defmodule ReservaWeb.UserController do
  use ReservaWeb, :controller
  alias Reserva.User

  def login(conn, _params) do
    redirect conn, to: Routes.page_path(conn, :index)
  end

  def new(conn, _params) do
    usbid = get_session(conn, :cas_user)
    user = User.changeset(%User{}, %{usbid: usbid})
    render conn, "new.html", user: user
  end

  def create(conn, %{"user" => user_params = %{"usbid" => usbid}}) do
    user_params_type = %{user_params | "type" => get_type(usbid)}
    case User.create_user(user_params_type) do
      {:ok, _} ->
        redirect conn, to: Routes.page_path(conn, :index)
      {:error, changeset} ->
        render conn, "new.html", user: changeset
    end
  end

  defp get_type(usbid) do
    case String.match?(usbid, ~r/\d{2}-\d{5}/) do
      true ->
        "student"
      false ->
        "faculty"
    end
  end
end
