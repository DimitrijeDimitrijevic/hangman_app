import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hangman_app, HangmanAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "h0o5eDcdhjCECJ1TBHlRBNKEq2DG8jj45sYNTqyqFh4hWsuT3ts7Y83gQ5aoH4mf",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
