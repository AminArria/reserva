defmodule Reserva.Trimester do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Reserva.{Repo, Trimester}
  alias Reserva.Reservation.MacroReservation

  schema "trimesters" do
    field :name, :string
    field :weeks, :integer, default: 12
    field :start_hour, :integer, default: 2
    field :end_hour, :integer, default: 12
    field :start_date, :utc_datetime, default: DateTime.utc_now()
    field :end_date, :utc_datetime,default: DateTime.add(DateTime.utc_now(), 12*7*24*60*60)

    has_many :reservations, MacroReservation

    timestamps()
  end

  @doc false
  def changeset(trimester, attrs \\ %{}) do
    trimester
    |> cast(attrs, [:name, :weeks, :start_hour, :end_hour, :start_date, :end_date])
    |> validate_required([:name, :weeks, :start_hour, :end_hour, :start_date, :end_date])
    |> validate_number(:weeks, greater_than: 0)
    |> validate_number(:start_hour, greater_than: 0)
    |> validate_number(:end_hour, greater_than: 0)
    |> validate_end_hour_greater_than_start_hour
    |> validate_end_date_after_start_date
    |> validate_no_overlap
  end

  defp validate_end_hour_greater_than_start_hour(changeset) do
    start_hour = get_field(changeset, :start_hour)
    end_hour = get_field(changeset, :end_hour)
    case end_hour > start_hour do
      true ->
        changeset
      false ->
        msg = "must be greater than #{start_hour}"
        add_error(changeset, :end_hour, msg)
    end
  end

  defp validate_end_date_after_start_date(changeset) do
    start_date = get_field(changeset, :start_date)
    end_date = get_field(changeset, :end_date)
    case DateTime.diff(end_date, start_date) > 0 do
      true ->
        changeset
      false ->
        msg = "must be after #{start_date}"
        add_error(changeset, :end_date, msg)
    end
  end

  defp validate_no_overlap(changeset) do
    id = get_field(changeset, :id)
    start_date = get_field(changeset, :start_date)
    end_date = get_field(changeset, :end_date)
    q = from t in Trimester, where: (t.id != ^id) and
                                    (t.start_date <= ^end_date) and
                                    (t.end_date >= ^start_date)
    overlaps = Repo.all(q)
    case overlaps do
      [] ->
        changeset
      _ ->
        msg = "overlaps with another trimester"
        add_error(changeset, :start_date, msg)
    end
  end

  def create(attrs) do
    changeset(%Trimester{}, attrs)
    |> Repo.insert()
  end

  def update(trimester, attrs) do
    changeset(trimester, attrs)
    |> Repo.update()
  end

  def get_all do
    Repo.all(Trimester)
  end

  def get(id) do
    Repo.get(Trimester, id)
  end
end
