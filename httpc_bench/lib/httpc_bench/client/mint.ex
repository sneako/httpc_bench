defmodule HttpcBench.Client.Mint do
  @behaviour HttpcBench.Client
  alias HttpcBench.Config

  def get do
    req = %Mojito.Request{
      method: :get,
      url: Config.url(),
    }

    case Mojito.Request.Single.request(req) do
      {:ok, _} -> :ok
      {:error, _, _} -> {:error, :lol}
      {:error, _, _, _} -> {:error, :lol}
      other -> other
    end
  end

  def start(_, 1) do
    {:ok, _} = :application.ensure_all_started(:mojito)
    :ok
  end

  def start(_pool_count, _pool_size) do
    {:error, "multiple pools not supported"}
  end

  def stop do
  end
end
