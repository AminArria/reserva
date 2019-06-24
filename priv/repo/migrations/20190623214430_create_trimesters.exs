defmodule Reserva.Repo.Migrations.CreateTrimesters do
  use Ecto.Migration

  def change do
    create table(:trimesters) do
      add :name, :string
      add :weeks, :integer, default: 12
      add :start_hour, :integer, default: 2
      add :end_hour, :integer, default: 12
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime

      timestamps()
    end

  end
end
