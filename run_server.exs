Task.start(fn ->
  Application.ensure_all_started(:httpc_bench)
  HttpcBench.run_server()
  IO.puts("Started HTTPC Bench server")
  Process.sleep(:infinity)
end)
