random_int = fn -> Randomizer.int() end
list = Randomizer.list(100_000, random_int)

Benchee.run(
  %{
    "External Term Format (Compression 0)" => fn ->
      :erlang.term_to_binary(list, [compressed: 0])
    end,
    "External Term Format (Compression 1)" => fn ->
      :erlang.term_to_binary(list, [compressed: 1])
    end,
    "External Term Format (Compression 6)" => fn ->
      :erlang.term_to_binary(list, [compressed: 6])
    end,
    "External Term Format (Compression 9)" => fn ->
      :erlang.term_to_binary(list, [compressed: 9])
    end,
    "Jason" => fn ->
      Jason.encode(list)
    end,
    "Jiffy" => fn ->
      :jiffy.encode(list)
    end
  },
  warmup: 30,
  time: 30,
  memory_time: 10,
  formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
)
