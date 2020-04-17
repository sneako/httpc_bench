Task.start(fn ->
  HttpcBench.run_server()
  Process.sleep(:infinity)
end)
