defmodule Encoder do
  def encode(payload) do
    etf_0_task = Task.async(fn ->
      :erlang.term_to_binary(payload, [compressed: 0])
    end)
    etf_1_task = Task.async(fn ->
      :erlang.term_to_binary(payload, [compressed: 1])
    end)
    etf_6_task = Task.async(fn ->
      :erlang.term_to_binary(payload, [compressed: 6])
    end)
    etf_9_task = Task.async(fn ->
      :erlang.term_to_binary(payload, [compressed: 9])
    end)
    json_task = Task.async(fn ->
      :jiffy.encode(payload)
    end)

    etf_0 = Task.await(etf_0_task, :infinity)
    etf_1 = Task.await(etf_1_task, :infinity)
    etf_6 = Task.await(etf_6_task, :infinity)
    etf_9 = Task.await(etf_9_task, :infinity)
    json = Task.await(json_task, :infinity)

    %{
      etf_0: etf_0,
      etf_1: etf_1,
      etf_6: etf_6,
      etf_9: etf_9,
      json: json
    }
  end
end
