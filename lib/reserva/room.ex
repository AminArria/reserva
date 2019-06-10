defmodule Reserva.Room do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Reserva.{Repo, Room}

  schema "rooms" do
    field :active, :boolean, default: true
    field :available_computers_amount, :integer, default: 0
    field :computers_amount, :integer, default: 0
    field :has_videobeam, :boolean, default: false
    field :location, :string
    field :name, :string
    field :unavailable_computers_amount, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(room, attrs \\ %{}) do
    room
    |> cast(attrs, [:name, :computers_amount, :available_computers_amount, :has_videobeam, :active, :location])
    |> validate_required([:name, :computers_amount, :available_computers_amount, :has_videobeam, :active, :location])
    |> validate_inclusion(:active, [true, false])
    |> validate_inclusion(:has_videobeam, [true, false])
    |> validate_amounts
    |> calc_unavailable_computers_amount
  end

  defp validate_amounts(changeset) do
    total = get_field(changeset, :computers_amount)
    available = get_field(changeset, :available_computers_amount)
    cond do
      total < 0 ->
        msg = "must be greater than or equal to 0"
        add_error(changeset, :computers_amount, msg)
      available > total ->
          msg = "must be less than or equal to #{total}"
          add_error(changeset, :available_computers_amount, msg)
      true ->
        changeset
    end
  end

  defp calc_unavailable_computers_amount(changeset) do
    total = get_field(changeset, :computers_amount)
    available = get_field(changeset, :available_computers_amount)
    unavailable = total - available
    put_change(changeset, :unavailable_computers_amount, unavailable)
  end

  def get_room(id) do
    Repo.get(Room, id)
  end

  def get_all_active do
    q = from r in Room, where: r.active
    Repo.all(q)
  end

  def get_all_inactive do
    q = from r in Room, where: not r.active
    Repo.all(q)
  end

  def create_room(attrs) do
    changeset(%Room{}, attrs)
    |> Repo.insert()
  end

  def update_room(room, attrs) do
    changeset(room, attrs)
    |> Repo.update()
  end
end
