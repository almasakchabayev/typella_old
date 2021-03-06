use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :typi, Typi.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :typi, Typi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "typi_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :typi, :otp, Typi.OTP.InMemory
config :typi, :twilio_api, Typi.ExTwilio.InMemory
config :typi, :future_message, 100