defmodule Reserva.Reservation.MacroReservation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reserva.Reservation.MicroReservation
  alias Reserva.{Room, Trimester, Subject, User}

  schema "macro_reservations" do
    field :approved, :boolean, default: false

    has_many :inner_reservations, MicroReservation, foreign_key: :reservation_id

    belongs_to :room, Room
    belongs_to :trimester, Trimester
    belongs_to :subject, Subject
    belongs_to :reserver, User, foreign_key: :reserver_id
    belongs_to :approver, User, foreign_key: :approver_id

    timestamps()
  end

  @doc false
  def changeset(macro_reservation, attrs) do
    macro_reservation
    |> cast(attrs, [:approved])
    |> validate_required([:approved])
  end
end
