defmodule HttpcBench.Client.MachineGun do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  def get do
    case MachineGun.get(Config.url(), Config.headers()) do
      {:ok, _} -> :ok
      error -> error
    end
  end

  def start(pool_size, pool_count) do
    cond do
      pool_size == 1 ->
        {:error, "skipping pool size 1"}

      pool_count > 1 ->
        {:error, "multiple pools not supported"}

      :else ->
        Application.put_env(:machine_gun, :default, %{
          pool_size: pool_size,
          pool_max_overflow: 0,
          request_timeout: Config.timeout(),
        })

        {:ok, _} = :application.ensure_all_started(:machine_gun)

        :ok
    end
  end

  def stop do
    :ok = :application.stop(:machine_gun)
  end
end
