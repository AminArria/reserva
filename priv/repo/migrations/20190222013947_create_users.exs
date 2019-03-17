defmodule Reserva.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :usbid, :string

      timestamps()
    end

  end
end
