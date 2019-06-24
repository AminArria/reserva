defmodule ReservaWeb.TrimesterController do
  use ReservaWeb, :controller
  alias Reserva.Trimester

  def index(conn, _) do
    trimesters = Trimester.get_all
    render conn, :index, trimesters: trimesters
  end

  def new(conn, _params) do
    trimester = Trimester.changeset(%Trimester{})
    render conn, :new, trimester: trimester
  end

  def create(conn, %{"trimester" => trimester_params}) do
    formated_trimester_params = format_date_params(trimester_params)
    case Trimester.create(formated_trimester_params) do
      {:ok, _} ->
        redirect conn, to: Routes.trimester_path(conn, :index)
      {:error, changeset} ->
        render conn, :new, trimester: changeset
    end
  end

  def edit(conn, %{"id" => id}) do
    trimester =
      Trimester.get(id)
      |> Trimester.changeset(%{})

    render conn, :edit, trimester: trimester, id: id
  end

  def update(conn, %{"id" => id, "trimester" => trimester_params}) do
    trimester = Trimester.get(id)
    formated_trimester_params = format_date_params(trimester_params)
    case Trimester.update(trimester, formated_trimester_params) do
      {:ok, trimester} ->
        trimester_changeset = Trimester.changeset(trimester)
        put_flash(conn, :info, "Actualizada exitosamente")
        |> render(:edit, trimester: trimester_changeset, id: id)
      {:error, changeset} ->
        put_flash(conn, :error, "Error actualizando")
        |> render(:edit, trimester: changeset, id: id)
    end
  end

  defp format_date_params(%{"start_date" => start_date, "end_date" => end_date} = params) do
    formated_start_date = format_date(start_date)
    formated_end_date = format_date(end_date)
    formated_dates = %{"start_date" => formated_start_date, "end_date" => formated_end_date}
    Map.merge(params, formated_dates)
  end

  defp format_date(%{"day" => day, "month" => month, "year" => year}) do
    day = String.pad_leading(day, 2, "0")
    month = String.pad_leading(month, 2, "0")
    "#{year}-#{month}-#{day}T12:00:00Z"
  end
end
