defmodule XxxxXxxx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # List all child processes to be supervised
    children = [
      supervisor(XxxxXxxx.Repo, []),
      supervisor(XxxxXxxxWeb.Endpoint, []),

      %{id: PersistenceProcess, start: {Agent, :start_link, [fn -> [] end, [name: SomePersistenceLayer]]}},
      %{id: TodoStateProcess, start: {Agent, :start_link, [fn -> :all end, [name: TodoListState]]}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: XxxxXxxx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    XxxxXxxxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
