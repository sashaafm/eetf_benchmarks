random_person = fn -> Randomizer.person() end
payload = Randomizer.list(10_000, random_person)
payload_size = :erts_debug.flat_size(payload) * :erlang.system_info(:wordsize)
IO.puts("Payload size is #{payload_size} B")

Benchee.run(
  %{
    "External Term Format (Compression 0)" => fn ->
      :erlang.term_to_binary(payload, [compressed: 0])
    end,
    "External Term Format (Compression 1)" => fn ->
      :erlang.term_to_binary(payload, [compressed: 1])
    end,
    "Jason" => fn ->
      Jason.encode!(payload)
    end,
    "Jiffy" => fn ->
      :jiffy.encode(payload)
    end
  },
  warmup: 30,
  time: 30,
  memory_time: 10,
  formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
)
