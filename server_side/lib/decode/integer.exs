random_int = fn -> Randomizer.int() end
list = Randomizer.list(100_000, random_int)
payloads = Encoder.encode(list)

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
