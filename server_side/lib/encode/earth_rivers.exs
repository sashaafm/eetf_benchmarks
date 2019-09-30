file = "#{:code.priv_dir(:server_side)}/earth_rivers.json"
payload = File.read!(file)
{:ok, decoded_payload} = Jason.decode(payload)
IO.puts("Payload size is #{Utils.byte_size(decoded_payload)} byte.")

Benchee.run(
  %{
    "External Term Format" => fn ->
      :erlang.term_to_binary(decoded_payload)
    end,
    "Jason" => fn ->
      Jason.encode!(decoded_payload)
    end,
    "Jiffy" => fn(input) ->
      Enum.map(input, &:jiffy.encode(&1))
    end
  },
  warmup: 30,
  time: 30,
  memory_time: 10,
  formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
)
