defmodule Utils do
  def byte_size(term) do
    :erts_debug.flat_size(term) * :erlang.system_info(:wordsize)
  end
end
