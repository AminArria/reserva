defmodule Reserva.Repo do
  use Ecto.Repo,
    otp_app: :reserva,
    adapter: Ecto.Adapters.Postgres
end
