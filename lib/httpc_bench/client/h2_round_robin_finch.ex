defmodule HttpcBench.Client.H2RoundRobinFinch do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  require Logger

  def get do
    try do
      with {:ok, _} <-
             Finch.request(H2RRFinch, :get, Config.h2_url(), Config.h2_headers(), nil,
               receive_timeout: Config.timeout()
             ) do
        :ok
      else
        error ->
          # IO.inspect(error)
          error
      end
    catch
      _kind, _reason ->
        # IO.inspect(reason)
        {:error, :pool_timeout}
    end
  end

  def post do
    try do
      with {:ok, _} <-
             Finch.request(
               H2RRFinch,
               :post,
               Config.h2_url(),
               Config.h2_post_headers(),
               Config.post_body(),
               receive_timeout: Config.timeout()
             ) do
        :ok
      else
        error ->
          # IO.inspect(error)
          error
      end
    catch
      _, _ ->
        # IO.inspect(a, label: :caught)
        {:error, :pool_timeout}
    end
  end

  def start(pool_size, pool_count) do
    {:ok, _pid} =
      Finch.start_link(
        name: H2RRFinch,
        pools: %{
          Config.h2_url() => [
            size: pool_size,
            count: pool_count,
            protocol: :http2,
            strategy: :round_robin,
            conn_opts: [transport_opts: [verify: :verify_none]]
          ]
        }
      )

    :ok
  end

  def stop do
    Supervisor.stop(H2RRFinch.Supervisor)

    :ok
  end
end
