defmodule Mix.Tasks.RunClients do
  use Mix.Task

  def run(argv) do
    Mix.Task.run("app.start")

    argv
    |> argv_to_opts
    |> HttpcBench.run_clients()
  end

  defp argv_to_opts(argv) do
    case argv do
      ["html" | _] -> [output: :html]
      ["text" | _] -> [output: :text]
      ["csv" | _] -> [output: :csv]
      _ -> []
    end
  end
end
