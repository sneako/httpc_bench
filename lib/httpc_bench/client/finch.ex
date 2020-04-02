defmodule HttpcBench.Client.Finch do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  require Logger

  def get do
    case Finch.request(:get, Config.url(), Config.headers(), "", timeout: Config.timeout()) do
      {:ok, _} ->
        :ok

      error ->
        {:error, :fail}
        # error -> error
    end
  end

  def post do
    case Finch.request(:post, Config.url(), Config.post_headers(), Config.post_body(),
           timeout: Config.timeout()
         ) do
      {:ok, _} ->
        :ok

      error ->
        {:error, :fail}
        # error -> error
    end
  end

  def start(pool_size, pool_count) do
    :application.stop(:finch)
    Application.put_env(:finch, :pool_size, pool_size)
    Application.put_env(:finch, :pool_count, pool_count)

    :application.ensure_all_started(:finch)

    :ok
  end

  def stop do
    :ok = :application.stop(:finch)
  end
end
