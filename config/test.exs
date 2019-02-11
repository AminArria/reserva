use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :reserva, ReservaWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :reserva, Reserva.Repo,
  username: "postgres",
  password: "postgres",
  database: "reserva_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
