use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :authentication_kata, AuthenticationKataWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :authentication_kata, AuthenticationKata.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "authentication_kata_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
