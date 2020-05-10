defmodule Mix.Tasks.RunServer do
  use Mix.Task

  def run(_argv) do
    Mix.Task.run("app.start")
    IO.puts("Running server on port #{HttpcBench.Config.port()}.")
    HttpcBench.run_server()
  end
end
