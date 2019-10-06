file = "#{:code.priv_dir(:server_side)}/earth_rivers.json"
IO.puts("File size is #{File.stat!(file).size}")
IO.puts("Going to read file...")
t1 = DateTime.utc_now()
json_payload = File.read!(file)
t2 = DateTime.utc_now()
IO.puts("Done.")
IO.puts("Took #{DateTime.diff(t2, t1)} seconds.")
{:ok, decoded_payload} = Jason.decode(json_payload)
payloads = Encoder.encode(decoded_payload)

Benchee.run(
  %{
    "External Term Format (Compression 0)" => fn ->
      :erlang.binary_to_term(payloads.etf_0)
    end,
    "External Term Format (Compression 1)" => fn ->
      :erlang.binary_to_term(payloads.etf_1)
    end,
    "External Term Format (Compression 6)" => fn ->
      :erlang.binary_to_term(payloads.etf_6)
    end,
    "External Term Format (Compression 9)" => fn ->
      :erlang.binary_to_term(payloads.etf_9)
    end,
    "Jason" => fn ->
      Jason.decode!(payloads.json)
    end,
    "Jiffy" => fn ->
      :jiffy.decode(payloads.json)
    end
  },
  warmup: 30,
  time: 30,
  memory_time: 10,
  formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
)
