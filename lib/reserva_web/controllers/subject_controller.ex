defmodule ReservaWeb.SubjectController do
  use ReservaWeb, :controller
  alias Reserva.Subject

  def index(conn, _) do
    subjects = Subject.get_all
    render conn, :index, subjects: subjects
  end

  def new(conn, _params) do
    subject = Subject.changeset(%Subject{})
    render conn, :new, subject: subject
  end

  def create(conn, %{"subject" => subject_params}) do
    case Subject.create_subject(subject_params) do
      {:ok, _} ->
        redirect conn, to: Routes.subject_path(conn, :index)
      {:error, changeset} ->
        render conn, :new, subject: changeset
    end
  end

  def edit(conn, %{"id" => id}) do
    subject =
      Subject.get(id)
      |> Subject.changeset(%{})

    render conn, :edit, subject: subject, id: id
  end

  def update(conn, %{"id" => id, "subject" => subject_params}) do
    subject = Subject.get(id)
    case Subject.update_subject(subject, subject_params) do
      {:ok, subject} ->
        subject_changeset = Subject.changeset(subject)
        put_flash(conn, :info, "Actualizada exitosamente")
        |> render(:edit, subject: subject_changeset, id: id)
      {:error, changeset} ->
        put_flash(conn, :error, "Error actualizando")
        |> render(:edit, subject: changeset, id: id)
    end
  end
end
