defmodule HttpcBench do
  @moduledoc """
  Documentation for HttpcBench.
  """

  alias HttpcBench.Config

  def run_server do
    HttpcBench.Server.start([], [])
  end

  def run_clients(opts \\ []) do
    IO.inspect(Application.get_all_env(:httpc_bench), label: :config)
    print_header(opts)
    print_results(opts)
    print_footer(opts)
  end

  defp print_results(opts) do
    for concurrency <- Config.concurrencies(),
        pool_size <- Config.pool_sizes(),
        pool_count <- Config.pool_counts(),
        client <- Config.clients() do
      result(client, concurrency, pool_size, pool_count)
      |> print_result(opts)
    end
  end

  defp result(client, concurrency, pool_size, pool_count) do
    client_name = client |> to_string |> String.replace_leading("Elixir.HttpcBench.Client.", "")
    name = name(client_name, concurrency, pool_size, pool_count)
    test_function = Application.get_env(:httpc_bench, :test_function)
    counter = :counters.new(100, [:atomics])

    telemetry_handler = fn e, _, _, _ ->
      count_finch_event(counter, e)
    end

    :telemetry.attach_many(
      "httpc_bench",
      [
        [:finch, :queue, :start],
        [:finch, :connect, :start],
        [:finch, :reused_connection],
        [:finch, :failed_checkout]
      ],
      telemetry_handler,
      nil
    )

    case client.start(pool_size, pool_count) do
      {:error, err} ->
        :telemetry.detach("httpc_bench")

        %{
          client: client_name,
          name: name,
          concurrency: concurrency,
          pool_size: pool_size,
          pool_count: pool_count,
          results: [],
          qps: 0,
          errors: 0,
          message: err
        }

      :ok ->
        fun = fn ->
          :counters.add(counter, 100, 1)
          apply(client, test_function, [])
        end

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

        :telemetry.detach("httpc_bench")
        client.stop()

        %{
          client: client_name,
          name: name,
          concurrency: concurrency,
          pool_size: pool_size,
          pool_count: pool_count,
          recorded_iterations: :counters.get(counter, 100),
          results: results,
          qps: qps,
          errors: errors,
          total_processes: pool_count * pool_size,
          queue_start: get_finch_event_count(counter, [:finch, :queue, :start]),
          failed_checkouts: get_finch_event_count(counter, [:finch, :failed_checkout]),
          reused_connection: get_finch_event_count(counter, [:finch, :reused_connection]),
          connect_start: get_finch_event_count(counter, [:finch, :connect, :start])
        }
    end
  end

  defp count_finch_event(counter, event) do
    i = finch_event_id(event)
    :counters.add(counter, i, 1)
  end

  defp get_finch_event_count(counter, event) do
    i = finch_event_id(event)
    :counters.get(counter, i)
  end

  defp finch_event_id([:finch, :reused_connection]), do: 1
  defp finch_event_id([:finch, :connect, :start]), do: 2
  defp finch_event_id([:finch, :reconnect]), do: 3
  defp finch_event_id([:finch, :failed_checkout]), do: 4
  defp finch_event_id([:finch, :queue, :start]), do: 5

  defp print_header(opts) do
    case output_format(opts) do
      :text ->
        :io.format(
          "Running benchmark...~n~n" <>
            "Client     PoolCount  PoolSize  Concurrency  Requests/s  Error %~n"
        )

      :html ->
        ~S"""
        <table>
        <thead><tr><th>Client</th><th>Pool Count</th><th>Pool Size</th><th>Concurrency</th><th>Req/sec</th><th>Error %</th></tr></thead>
        <tfoot><tr><th>Client</th><th>Pool Count</th><th>Pool Size</th><th>Concurrency</th><th>Req/sec</th><th>Error %</th></tr></tfoot>
        """
        |> String.trim()
        |> IO.puts()

      :csv ->
        "Client,Pool Count,Pool Size,Concurrency,Recorded Iterations, Req/sec,Error %, Total Processes, Connect Start, Queue Start, Reused Connections, Failed Checkouts"
        |> IO.puts()
    end
  end

  ## Don't print skipped runs
  defp print_result(%{message: _}, _opts), do: :ok

  defp print_result(result, opts) do
    fields = [
      result.client,
      result.pool_count,
      result.pool_size,
      result.concurrency,
      result.recorded_iterations,
      trunc(result.qps),
      round(result.errors * 10) / 10.0,
      result.total_processes,
      result.connect_start,
      result.queue_start,
      result.reused_connection,
      result.failed_checkouts
    ]

    case output_format(opts) do
      :text ->
        :io.format("~-10s ~9B ~9B ~12B ~11B ~8.1f~n", fields)

      :html ->
        "<tr><td>#{Enum.join(fields, "</td><td>")}</td></tr>" |> IO.puts()

      :csv ->
        fields |> Enum.join(",") |> IO.puts()
    end
  end

  defp print_footer(opts) do
    case output_format(opts) do
      :html -> "</table>" |> IO.puts()
      _ -> :nothing_to_do
    end
  end

  defp name(client, concurrency, pool_size, pool_count) do
    "#{client}_conc#{concurrency}_size#{pool_size}_count#{pool_count}"
    |> String.to_atom()
  end

  def output_format(opts) do
    opts[:output] || Application.get_env(:httpc_bench, :output, :text)
  end
end
