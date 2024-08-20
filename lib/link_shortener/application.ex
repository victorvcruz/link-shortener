defmodule LinkShortener.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LinkShortenerWeb.Telemetry,
      LinkShortener.Repo,
      {DNSCluster, query: Application.get_env(:link_shortener, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LinkShortener.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LinkShortener.Finch},
      # Start a worker by calling: LinkShortener.Worker.start_link(arg)
      # {LinkShortener.Worker, arg},
      # Start to serve requests, typically the last entry
      LinkShortenerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LinkShortener.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LinkShortenerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
