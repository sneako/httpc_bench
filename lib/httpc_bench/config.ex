defmodule HttpcBench.Config do
  @iterations Application.get_env(:httpc_bench, :iterations)

  def iterations do
    @iterations
  end

  @concurrencies Application.get_env(:httpc_bench, :concurrencies)

  def concurrencies do
    @concurrencies
  end

  @pool_sizes Application.get_env(:httpc_bench, :pool_sizes)

  def pool_sizes do
    @pool_sizes
  end

  @pool_counts Application.get_env(:httpc_bench, :pool_counts)

  def pool_counts do
    @pool_counts
  end

  @clients Application.get_env(:httpc_bench, :clients)

  def clients do
    @clients
  end

  @url Application.get_env(:httpc_bench, :url)

  def url do
    @url
  end

  @hostname Application.get_env(:httpc_bench, :hostname)

  def hostname do
    @hostname
  end

  @port Application.get_env(:httpc_bench, :port)

  def port do
    @port
  end

  @host "#{@hostname}:#{@port}"

  def host do
    @host
  end

  @path Application.get_env(:httpc_bench, :path)

  def path do
    @path
  end

  @buoy_url {:buoy_url, @host, @hostname, @path, @port, :http}

  def buoy_url do
    @buoy_url
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
