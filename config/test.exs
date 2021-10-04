import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fuel_calc, FuelCalcWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "FKXgYu72zGvWPigVjhFo6OibYByKc5Zb3vjD17KUgnhuJ6auD8JZ3VDtQoEuNt7x",
  server: false

# In test we don't send emails.
config :fuel_calc, FuelCalc.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
