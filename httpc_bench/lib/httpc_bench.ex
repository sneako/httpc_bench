defmodule HttpcBench do
  @moduledoc """
  Documentation for HttpcBench.
  """

  @iterations 20480

  @clients [
    # HttpcBench.Client.Buoy,
    # HttpcBench.Client.Dlhttpc,
    #HttpcBench.Client.Hackney,
    # HttpcBench.Client.Httpc,
    # HttpcBench.Client.Ibrowse,
    # HttpcBench.Client.Gun,
    HttpcBench.Client.Mojito
  ]

  @request_concurrencies [32, 64, 128, 512, 1024, 2048, 4096]

  @pool_sizes [8, 16, 32, 64, 128, 256]

  @pool_counts [1, 2, 4, 8, 16]

  def run_server do
    HttpcBench.Server.start([], [])
  end

  def run do
    results() |> Enum.each(&print_result/1)
  end

  defp print_result(result) do
    IO.inspect(result)
  end

  def results do
    for client <- @clients,
        concurrency <- @request_concurrencies,
        pool_size <- @pool_sizes,
        pool_count <- @pool_counts do
      result(client, concurrency, pool_size, pool_count)
      Process.sleep(100)
    end
  end

  def result(client, concurrency, pool_size, pool_count) do
    client_name = client |> to_string |> String.replace_leading("HttpcBench.Client.", "")
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
            iterations: @iterations,
            output: "output/#{name}" |> String.to_charlist()
          )
          |> IO.inspect()

        qps = results[:success] / (results[:total_time] / 1_000_000)
        errors = results[:errors] / (results[:iterations] * 100)

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
    end
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
