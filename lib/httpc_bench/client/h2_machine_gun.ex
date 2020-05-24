defmodule HttpcBench.Client.H2MachineGun do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  def get do
    case MachineGun.get(Config.h2_url(), Config.h2_headers()) do
      {:ok, _} -> :ok
      error -> error
    end
  end

  def post do
    case MachineGun.post(Config.h2_url(), Config.post_body(), Config.h2_post_headers()) do
      {:ok, _} -> :ok
      error -> error
    end
  end

  def start(_pool_size, pool_count) do
    Application.put_env(:machine_gun, :default, %{
      pool_size: pool_count,
      pool_max_overflow: 0,
      request_timeout: Config.timeout()
    })

    {:ok, _} = :application.ensure_all_started(:machine_gun)

    :ok
  end

  def stop do
    :ok = :application.stop(:machine_gun)
  end
end
