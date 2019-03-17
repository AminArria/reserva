defmodule Reserva.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reserva.{Repo, User}

  schema "users" do
    field :usbid, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:usbid])
    |> validate_required([:usbid])
  end

  def create_user(attrs) do
    changeset(%User{}, attrs)
    |> Repo.insert()
  end
end
