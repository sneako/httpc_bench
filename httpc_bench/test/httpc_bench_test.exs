defmodule HttpcBenchTest do
  use ExUnit.Case
  doctest HttpcBench

  test "greets the world" do
    {:ok, pid} = HttpcBench.run_server()
    HttpcBench.run()
    Process.stop(pid)
  end
end
