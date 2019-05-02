defmodule HttpcBench.Config do
  @url Application.get_env(:httpc_bench, :url)

  def url do
    @url
  end

  @host Application.get_env(:httpc_bench, :host)

  def host do
    @host
  end

  @port Application.get_env(:httpc_bench, :port)

  def port do
    @port
  end

  @path Application.get_env(:httpc_bench, :path)

  def path do
    @path
  end

  @pipelining Application.get_env(:httpc_bench, :pipelining)

  def pipelining do
    @pipelining
  end

  @timeout Application.get_env(:httpc_bench, :timeout)

  def timeout do
    @timeout
  end

  @headers Application.get_env(:httpc_bench, :headers)

  def headers do
    @headers
  end
end
