defmodule Reserva.Repo.Migrations.CreateMacroReservations do
  use Ecto.Migration

  def change do
    create table(:macro_reservations) do
      add :approved, :boolean, default: false, null: false
      add :room, references(:rooms, on_delete: :nothing), null: false
      add :trimester, references(:trimesters, on_delete: :nothing), null: false
      add :subject, references(:subjects, on_delete: :nothing), null: false
      add :reserver, references(:users, on_delete: :nothing), null: false
      add :approver, references(:users, on_delete: :nothing), null: true

      timestamps()
    end

  end
end
