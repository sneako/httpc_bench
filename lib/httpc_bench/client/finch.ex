defmodule HttpcBench.Client.Finch do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  require Logger

  @get Finch.build(:get, Config.url(), Config.headers())
  @post Finch.build(:post, Config.url(), Config.post_headers(), Config.post_body())

  def get do
    try do
      with {:ok, _} <- Finch.request(@get, MyFinch, receive_timeout: Config.timeout()) do
        :ok
      end
    catch
      _, _ ->
        {:error, :pool_timeout}
    end
  end

  def post do
    try do
      with {:ok, _} <- Finch.request(@post, MyFinch, receive_timeout: Config.timeout()) do
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
        name: MyFinch,
        pools: %{Config.url() => [size: pool_size, count: pool_count]}
      )

    :ok
  end

  def stop do
    Supervisor.stop(MyFinch.Supervisor)

    :ok
  end
end
