defmodule HttpcBench.Client.H2Mojito do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  def get do
    request = %Mojito.Request{
      method: :get,
      url: Config.h2_url(),
      headers: Config.h2_headers(),
      opts: [timeout: Config.timeout(), transport_opts: [verify: :verify_none]]
    }

    request(request)
  end

  def post do
    request = %Mojito.Request{
      method: :post,
      url: Config.h2_url(),
      headers: Config.h2_post_headers(),
      body: Config.post_body(),
      opts: [timeout: Config.timeout(), transport_opts: [verify: :verify_none]]
    }

    request(request)
  end

  defp request(req) do
    try do
      case Mojito.request(req) do
        {:ok, _} -> :ok
        {:error, e} -> {:error, e}
      end
    catch
      _, e ->
        {:error, e}
    end
  end

  def start(1, _pool_count) do
    {:error, "skipping pool size 1"}
  end

  def start(pool_size, pool_count) do
    pool_opts = [
      size: pool_size,
      max_overflow: 0,
      pools: pool_count
    ]

    Application.put_env(:mojito, :pool_opts, pool_opts)

    {:ok, _} = :application.ensure_all_started(:mojito)
    :ok
  end

  def stop do
    :ok = :application.stop(:mojito)
  end
end
