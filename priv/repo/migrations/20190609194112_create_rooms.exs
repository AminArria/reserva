defmodule Reserva.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :computers_amount, :integer, default: 0
      add :available_computers_amount, :integer, default: 0
      add :unavailable_computers_amount, :integer, default: 0
      add :has_videobeam, :boolean, default: false, null: false
      add :active, :boolean, default: true, null: false
      add :location, :string

      timestamps()
    end

  end
end
