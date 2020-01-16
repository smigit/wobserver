defmodule Wobserver.Web.PhoenixSocket do
  @behaviour Phoenix.Socket.Transport
  @moduledoc """
  Drop-in Phoenix Socket for easier integration in to Phoenix endpoints

  Example:
    ```elixir
    defmodule MyPhoenixServer.Endpoint do
      socket "/wobserver", Wobserver.Web.PhoenixSocket # The path should be the same as the router path

      ...
    end
    ```
  """

  @doc false

  def child_spec(endpoint: _) do
    # We won't spawn any process, so let's return a dummy task
    # Plug.Cowboy.child_spec(scheme: :http, plug: {Wobserver.Web.PhoenixSocket, []}, options: [])
    %{id: Task, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}
  end

  def __transports__ do
    config = [
      cowboy: Wobserver.Web.Client
    ]

    callback_module = Wobserver.Web.PhoenixSocket
    transport_path = :ws
    websocket_socket = {transport_path, {callback_module, config}}
    # Only handling one type, websocket, no longpolling or anything else
    [
      websocket_socket
    ]
  end
end
