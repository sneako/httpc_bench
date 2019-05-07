defmodule HttpcBench.Client.Ibrowse do
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
    case :ibrowse.send_req(url(), headers(), :get) do
      {:ok, _, _, _} -> :ok
      other -> other
    end
  end

  def start(pool_count, pool_size) do
    cond do
      pool_size == 1 ->
        {:error, "skipping pool size 1"}

      pool_count > 1 ->
        {:error, "multiple pools not supported"}

      :else ->
        :ok = :application.start(:ibrowse)

        options = [
          max_sessions: pool_size,
          max_pipeline_size: Config.pipelining(),
        ]

        Config.hostname()
        |> String.to_charlist()
        |> :ibrowse.set_dest(Config.port(), options)
    end
  end

  def stop do
    :application.stop(:ibrowse)
  end
end
