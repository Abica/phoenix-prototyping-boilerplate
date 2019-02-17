# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :xxxx_xxxx,
  ecto_repos: [XxxxXxxx.Repo]

# Configures the endpoint
config :xxxx_xxxx, XxxxXxxxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s/T5w5GBm05339mlOF6i/UUyFI7yr1K7frhjGLjZmO6p8go7MpG91TYQZqstycYt",
  render_errors: [view: XxxxXxxxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: XxxxXxxx.PubSub, adapter: Phoenix.PubSub.PG2]

#config :drab, XxxxXxxxWeb.Endpoint, otp_app: :xxxx_xxxx
#config :drab, XxxxXxxxWeb.Endpoint, js_socket_constructor: "window.__socket"

config :phoenix, :template_engines,
#  drab: Drab.Live.Engine,
  texas:  Texas.TemplateEngine,
  tex:  Texas.TemplateEngine
config :texas, pubsub: XxxxXxxxWeb.Endpoint
config :texas, router: XxxxXxxxWeb.Router


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: XxxxXxxx.Coherence.User,
  repo: XxxxXxxx.Repo,
  module: XxxxXxxx,
  web_module: XxxxXxxxWeb,
  router: XxxxXxxxWeb.Router,
  password_hashing_alg: Comeonin.Bcrypt,
  messages_backend: XxxxXxxxWeb.Coherence.Messages,
  registration_permitted_attributes: [
    "email",
    "name",
    "password",
    "current_password",
    "password_confirmation"
  ],
  invitation_permitted_attributes: ["name", "email"],
  password_reset_permitted_attributes: [
    "reset_password_token",
    "password",
    "password_confirmation"
  ],
  session_permitted_attributes: ["remember", "email", "password"],
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [
    :authenticatable,
    :recoverable,
    :lockable,
    :trackable,
    :unlockable_with_token,
    :registerable
  ]

config :coherence, XxxxXxxxWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"

# %% End Coherence Configuration %%
