defmodule HttpcBench.Client do
  @callback get() :: :ok
  @callback start(pool_size :: pos_integer, pool_count :: pos_integer) ::
              :ok | {:error, String.t()}
  @callback stop() :: :ok
end
