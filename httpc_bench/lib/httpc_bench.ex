defmodule HttpcBench do
  @moduledoc """
  Documentation for HttpcBench.
  """

  alias HttpcBench.Config

  def run_server do
    HttpcBench.Server.start([], [])
  end

  def run_clients do
    :io.format(
      "Running benchmark...~n~n" <>
        "Client     PoolCount  PoolSize  Concurrency  Requests/s  Error %~n"
    )

    results()
  end

  def results do
    for client <- Config.clients(),
        concurrency <- Config.concurrencies(),
        pool_size <- Config.pool_sizes(),
        pool_count <- Config.pool_counts() do
      result(client, concurrency, pool_size, pool_count)
      Process.sleep(100)
    end
  end

  def result(client, concurrency, pool_size, pool_count) do
    client_name = client |> to_string |> String.replace_leading("Elixir.HttpcBench.Client.", "")
    name = name(client_name, concurrency, pool_size, pool_count)

    case client.start(pool_size, pool_count) do
      {:error, err} ->
        %{
          client: client_name,
          name: name,
          concurrency: concurrency,
          pool_size: pool_size,
          pool_count: pool_count,
          results: [],
          qps: 0,
          errors: 0,
          message: err,
        }

      :ok ->
        fun = fn -> client.get() end

        results =
          :timing_hdr.run(
            fun,
            name: name,
            concurrency: concurrency,
            iterations: Config.iterations(),
            output: "output/#{name}" |> String.to_charlist()
          )

        qps = results[:success] / (results[:total_time] / 1_000_000)
        errors = results[:errors] * 100 / results[:iterations]

        client.stop()

        %{
          client: client_name,
          name: name,
          concurrency: concurrency,
          pool_size: pool_size,
          pool_count: pool_count,
          results: results,
          qps: qps,
          errors: errors,
        }
        |> print_result
    end
  end

  defp print_result(result) do
    :io.format(
      "~-10s ~9B ~9B ~12B ~11B ~8.1f~n",
      [
        result.client,
        result.pool_count,
        result.pool_size,
        result.concurrency,
        trunc(result.qps),
        result.errors,
      ]
    )
  end

  defp name(client, concurrency, pool_size, pool_count) do
    "#{client}_conc#{concurrency}_size#{pool_size}_count#{pool_count}"
    |> String.to_atom()
  end

  defp lookup(results, key) do
    case Keyword.get(results, key) do
      {_, value} -> value
      _ -> nil
    end
  end
end
