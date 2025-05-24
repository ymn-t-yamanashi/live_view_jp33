defmodule LiveViewJp33.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveViewJp33Web.Telemetry,
      {DNSCluster, query: Application.get_env(:live_view_jp33, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveViewJp33.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveViewJp33.Finch},
      # Start a worker by calling: LiveViewJp33.Worker.start_link(arg)
      # {LiveViewJp33.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveViewJp33Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveViewJp33.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveViewJp33Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
