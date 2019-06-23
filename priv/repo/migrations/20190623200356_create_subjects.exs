defmodule Reserva.Repo.Migrations.CreateSubjects do
  use Ecto.Migration

  def change do
    create table(:subjects) do
      add :name, :string
      add :code, :string

      timestamps()
    end

    create unique_index(:subjects, [:code])
  end
end
