defmodule ReservaWeb.UserController do
  use ReservaWeb, :controller
  alias Reserva.User

  def login(conn, _params) do
    redirect conn, to: Routes.page_path(conn, :index)
  end

  def new(conn, _params) do
    usbid = get_session(conn, :cas_user)
    email = get_email(usbid)
    user = User.changeset(%User{}, %{usbid: usbid, email: email})
    render conn, "new.html", user: user
  end

  def create(conn, %{"user" => user_params}) do
    usbid = get_session(conn, :cas_user)
    usbid_params = %{"usbid" => usbid, "type" => get_type(usbid)}
    full_user_params = Map.merge(user_params, usbid_params)
    case User.create_user(full_user_params) do
      {:ok, _} ->
        redirect conn, to: Routes.page_path(conn, :index)
      {:error, changeset} ->
        render conn, "new.html", user: changeset
    end
  end

  def edit(conn, %{"id" => id}) do
    user =
      User.get_user(id)
      |> User.changeset(%{})

    render conn, "edit.html", user: user, id: id
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = User.get_user(id)
    parsed_user_params = parse_params(conn.assigns.current_user, user_params)
    case User.update_user(user, parsed_user_params) do
      {:ok, user} ->
        user_changeset = User.changeset(user, %{})
        put_flash(conn, :info, "Update was successfull")
        |> render("edit.html", user: user_changeset, id: id)
      {:error, changeset} ->
        put_flash(conn, :error, "Update failed")
        |> render("edit.html", user: changeset, id: id)
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

  defp get_email(usbid) do
    usbid <> "@usb.ve"
  end

  defp parse_params(current_user, user_params) do
    if is_admin?(current_user) do
      user_params
    else
      Map.delete(user_params, "type")
    end
    |> Map.delete("usbid")
  end
end
