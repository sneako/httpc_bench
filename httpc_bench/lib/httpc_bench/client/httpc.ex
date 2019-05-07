defmodule HttpcBench.Client.Httpc do
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
    request = {url(), headers()}

    case :httpc.request(:get, request, [timeout: Config.timeout()], []) do
      {:ok, _} -> :ok
      other -> other
    end
  end

  def start(pool_size, pool_count) do
    cond do
      pool_size == 1 ->
        {:error, "skipping pool size 1"}

      pool_count > 1 ->
        {:error, "multiple pools not supported"}

      :else ->
        :inets.start()

        :httpc.set_options(
          max_keep_alive_length: 1_000_000,
          max_pipeline_length: Config.pipelining(),
          max_sessions: pool_size
        )

        :ok
    end
  end

  def stop do
    :inets.stop()
  end
end
