defmodule Reserva.Subject do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reserva.{Repo, Subject}

  schema "subjects" do
    field :code, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(subject, attrs \\ %{}) do
    subject
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
    |> validate_format(:code, ~r/([A-Z]{2}-[0-9]{4}|[A-Z]{3}-[0-9]{3})/)
    |> unique_constraint(:code)
  end

  def create_subject(attrs) do
    changeset(%Subject{}, attrs)
    |> Repo.insert()
  end

  def update_subject(subject, attrs) do
    changeset(subject, attrs)
    |> Repo.update()
  end

  def get_all do
    Repo.all(Subject)
  end

  def get(id) do
    Repo.get(Subject, id)
  end
end
