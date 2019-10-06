defmodule LoadServer.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: LoadServer.Router,
        options: [port: 4000]
      )
    ]

    opts = [
      strategy: :one_for_one,
      name: LoadServer.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
