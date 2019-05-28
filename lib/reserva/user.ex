defmodule Reserva.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reserva.{Repo, User}

  schema "users" do
    field :usbid, :string
    field :type, :string
    field :name, :string
    field :email, :string
    field :phone_number, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:usbid, :type, :name, :email, :phone_number])
    |> validate_required([:usbid, :type, :name, :email])
    |> validate_inclusion(:type, ["admin", "member", "faculty", "student"])
    |> validate_format(:email, ~r/@/)
    |> validate_format(:phone_number, ~r/^\d+/)
  end

  def create_user(attrs) do
    changeset(%User{}, attrs)
    |> Repo.insert()
  end

  def update_user(user, attrs) do
    changeset(user, attrs)
    |> Repo.update()
  end

  def get_user(id) do
    Repo.get(User, id)
  end
end
