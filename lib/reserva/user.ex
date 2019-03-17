defmodule Reserva.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reserva.{Repo, User}

  schema "users" do
    field :usbid, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:usbid, :type])
    |> validate_required([:usbid, :type])
    |> validate_inclusion(:type, ["admin", "member", "faculty", "student"])
  end

  def create_user(attrs) do
    changeset(%User{}, attrs)
    |> Repo.insert()
  end
end
