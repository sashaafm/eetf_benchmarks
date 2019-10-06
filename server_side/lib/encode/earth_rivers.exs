file = "#{:code.priv_dir(:server_side)}/earth_rivers.json"
IO.puts("File size is #{File.stat!(file).size}")
IO.puts("Going to read file...")
t1 = DateTime.utc_now()
payload = File.read!(file)
t2 = DateTime.utc_now()
IO.puts("Done.")
IO.puts("Took #{DateTime.diff(t2, t1)} seconds.")
{:ok, decoded_payload} = Jason.decode(payload)

Benchee.run(
  %{
    "External Term Format (Compression 0)" => fn ->
      :erlang.term_to_binary(decoded_payload, [compressed: 0])
    end,
    "External Term Format (Compression 1)" => fn ->
      :erlang.term_to_binary(decoded_payload, [compressed: 1])
    end,
    "External Term Format (Compression 6)" => fn ->
      :erlang.term_to_binary(decoded_payload, [compressed: 6])
    end,
    "External Term Format (Compression 9)" => fn ->
      :erlang.term_to_binary(decoded_payload, [compressed: 9])
    end,
    "Jason" => fn ->
      Jason.encode!(decoded_payload)
    end,
    "Jiffy" => fn(input) ->
      :jiffy.encode(decoded_payload)
    end
  },
  warmup: 30,
  time: 30,
  memory_time: 10,
  formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
)
