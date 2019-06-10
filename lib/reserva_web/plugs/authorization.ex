defmodule ReservaWeb.Plugs.Authorization do
  import Plug.Conn
  alias ReservaWeb.Router.Helpers, as: Routes

  def init(options) do
    options
  end

  def call(conn, _options) do
    case authorized?(Phoenix.Controller.controller_module(conn), Phoenix.Controller.action_name(conn), conn.assigns[:current_user], conn) do
      true ->
        conn
      false ->
        conn
        |> Phoenix.Controller.put_flash(:error, "No tienes permiso para eso")
        |> Phoenix.Controller.redirect(to: Routes.page_path(conn, :index))
        |> halt
    end
  end

  def is_admin?(user) do
    user.type == "admin"
  end

  def is_member?(user) do
    user.type == "member" or is_admin?(user)
  end

  # Authorization logic
  defp authorized?(ReservaWeb.PageController, _, _, _) do
    true
  end

  defp authorized?(ReservaWeb.UserController, action, current_user, %{params: %{"id" => user_id}}) when action in [:edit, :update] do
    cond do
      current_user.id == String.to_integer(user_id) ->
        true
      is_member?(current_user) ->
        true
      true ->
        false
    end
  end
  defp authorized?(ReservaWeb.UserController, action, _, _) when action in [:login, :new, :create] do
    true
  end

  defp authorized?(ReservaWeb.RoomController, action, current_user, _) when action in [:new, :create] do
    is_admin?(current_user)
  end
  defp authorized?(ReservaWeb.RoomController, action, current_user, _) when action in [:edit, :update] do
    is_member?(current_user)
  end
  defp authorized?(ReservaWeb.RoomController, :index, _, _) do
    true
  end
end
