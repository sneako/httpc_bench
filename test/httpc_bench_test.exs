defmodule HttpcBenchTest do
  use ExUnit.Case
  doctest HttpcBench

  @tag timeout: 500_000
  test "runs a brief suite of benchmarks" do
    {:ok, _pid} = HttpcBench.run_server()
    HttpcBench.run_clients()
  end
end
