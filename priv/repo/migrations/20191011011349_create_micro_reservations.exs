defmodule Reserva.Repo.Migrations.CreateMicroReservations do
  use Ecto.Migration

  def change do
    create table(:micro_reservations) do
      add :day, :integer, null: false
      add :start_block, :integer, null: false
      add :end_block, :integer, null: false
      add :reservation, references(:macro_reservations, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:micro_reservations, [:reservation])
  end
end
