defmodule HttpcBench.Client.Mojito do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  def get do
    request = %Mojito.Request{
      method: :get,
      url: Config.url(),
      headers: Config.headers(),
      opts: [timeout: Config.timeout()],
    }

    case Mojito.request(request) do
      {:ok, _} -> :ok
      {:error, e} -> {:error, e}
    end
  end

  def post do
    request = %Mojito.Request{
      method: :post,
      url: Config.url(),
      headers: Config.post_headers(),
      body: Config.post_body(),
      opts: [timeout: Config.timeout()],
    }

    case Mojito.request(request) do
      {:ok, _} -> :ok
      {:error, e} -> {:error, e}
    end
  end

  def start(1, _pool_count) do
    {:error, "skipping pool size 1"}
  end

  def start(pool_size, pool_count) do
    pool_opts = [
      size: pool_size,
      max_overflow: 0,
      pools: pool_count,
    ]

    Application.put_env(:mojito, :pool_opts, pool_opts)

    {:ok, _} = :application.ensure_all_started(:mojito)
    :ok
  end

  def stop do
    :ok = :application.stop(:mojito)
  end
end
