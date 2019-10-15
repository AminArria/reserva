defmodule Reserva.Reservation.MicroReservation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reserva.Reservation.MacroReservation


  schema "micro_reservations" do
    field :day, :integer
    field :end_block, :integer
    field :start_block, :integer

    belongs_to :reservation, MacroReservation, foreign_key: :reservation_id

    timestamps()
  end

  @doc false
  def changeset(micro_reservation, attrs) do
    micro_reservation
    |> cast(attrs, [:day, :start_block, :end_block])
    |> validate_required([:day, :start_block, :end_block])
  end
end
