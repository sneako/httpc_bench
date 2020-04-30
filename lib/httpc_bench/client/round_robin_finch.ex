defmodule HttpcBench.Client.RoundRobinFinch do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  require Logger

  def get do
    try do
      with {:ok, _} <-
             Finch.request(RoundRobinFinch, :get, Config.url(), Config.headers(), nil,
               receive_timeout: Config.timeout()
             ) do
        :ok
      end
    catch
      _, _ ->
        {:error, :pool_timeout}
    end
  end

  def post do
    try do
      with {:ok, _} <-
             Finch.request(
               RoundRobinFinch,
               :post,
               Config.url(),
               Config.post_headers(),
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
        name: RoundRobinFinch,
        pools: %{Config.url() => [size: pool_size, count: pool_count, strategy: :round_robin]}
      )

    :ok
  end

  def stop do
    Supervisor.stop(RoundRobinFinch.Supervisor)

    :ok
  end
end
