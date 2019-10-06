random_person = fn -> Randomizer.person() end
payload = Randomizer.list(10_000, random_person)
payload_size = :erts_debug.flat_size(payload) * :erlang.system_info(:wordsize)
IO.puts("Payload size is #{payload_size} B")
payloads = Encoder.encode(payload)

Benchee.run(
  %{
    "External Term Format (Compression 0)" => fn ->
      :erlang.binary_to_term(payloads.etf_0)
    end,
    "External Term Format (Compression 1)" => fn ->
      :erlang.binary_to_term(payloads.etf_1)
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
