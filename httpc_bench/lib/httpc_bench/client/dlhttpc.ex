defmodule HttpcBench.Client.Dlhttpc do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  defp url do
    Config.url()
    |> String.to_charlist()
  end

  defp headers do
    Config.headers()
    |> Enum.map(fn {k, v} -> {String.to_charlist(k), String.to_charlist(v)} end)
  end

  def get do
    try do
      case :dlhttpc.request(url(), :get, headers(), "", Config.timeout(), []) do
        {:ok, _} -> :ok
        error -> error
      end
    catch
      :exit, {:busy, _} -> {:error, "busy"}
    end
  end

  def start(pool_size, pool_count) do
    if pool_count > 1 do
      {:error, "multiple pools not supported"}
    else
      :application.ensure_all_started(:dlhttpc)

      {:ok, _} =
        :dlhttpc.request(url(), :get, headers(), "", Config.timeout(), max_connections: pool_size)

      :ok
    end
  end

  def stop do
    :ok = :application.stop(:dlhttpc)
    :ok = :application.stop(:dispcount)
  end
end
