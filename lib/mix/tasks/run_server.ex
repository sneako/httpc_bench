defmodule Mix.Tasks.RunServer do
  use Mix.Task

  def run(_argv) do
    Application.ensure_all_started(:ranch)
    IO.puts("Running server on port #{HttpcBench.Config.port()}.")
    HttpcBench.run_server()
  end
end
