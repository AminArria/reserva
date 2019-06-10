defmodule ReservaWeb.RoomController do
  use ReservaWeb, :controller
  alias Reserva.Room

  plug ReservaWeb.Plugs.Authorization when action in [:new, :create]

  def index(conn, _) do
    rooms_active = Room.get_all_active
    rooms_inactive = Room.get_all_inactive
    render conn, :index, rooms_active: rooms_active, rooms_inactive: rooms_inactive
  end

  def new(conn, _params) do
    room = Room.changeset(%Room{})
    render conn, :new, room: room
  end

  def create(conn, %{"room" => room_params}) do
    case Room.create_room(room_params) do
      {:ok, _} ->
        redirect conn, to: Routes.room_path(conn, :index)
      {:error, changeset} ->
        render conn, :new, room: changeset
    end
  end

  def edit(conn, %{"id" => id}) do
    room =
      Room.get_room(id)
      |> Room.changeset(%{})

    render conn, :edit, room: room, id: id
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Room.get_room(id)
    parsed_room_params = parse_params(conn.assigns.current_user, room_params)
    case Room.update_room(room, parsed_room_params) do
      {:ok, room} ->
        room_changeset = Room.changeset(room, %{})
        put_flash(conn, :info, "Actualizada exitosamente")
        |> render(:edit, room: room_changeset, id: id)
      {:error, changeset} ->
        put_flash(conn, :error, "Error actualizando")
        |> render(:edit, room: changeset, id: id)
    end
  end

  defp parse_params(current_user, room_params) do
    if is_admin?(current_user) do
      room_params
    else
      Map.delete(room_params, "active")
    end
  end
end
