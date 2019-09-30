random_int = fn -> Randomizer.random_int() end

Benchee.run(
  %{
    "External Term Format" => fn(input) ->
      Enum.map(input, &:erlang.term_to_binary(&1))
    end,
    "Jason" => fn(input) ->
      Enum.map(input, &Jason.encode(&1))
    end,
    "Jiffy" => fn(input) ->
      Enum.map(input, &:jiffy.encode(&1))
    end
  },
  warmup: 30,
  time: 30,
  memory_time: 10,
  inputs: %{
    "Small" => Randomizer.list(1_000, random_int),
    "Medium" => Randomizer.list(10_000, random_int),
    "Large" => Randomizer.list(50_000, random_int),
    "Largest" => Randomizer.list(100_000, random_int),
  },
  formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
)
