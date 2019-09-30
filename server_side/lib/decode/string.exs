random_str = fn -> Randomizer.string(Enum.random(0..63), :all) end
list_small = Randomizer.list(1_000, random_str)
list_medium = Randomizer.list(10_000, random_str)
list_large = Randomizer.list(50_000, random_str)
list_largest = Randomizer.list(100_000, random_str)

Benchee.run(
  %{
    "External Term Format" => fn({bin, _}) ->
      :erlang.binary_to_term(bin)
    end,
    "Jason" => fn({_, json}) ->
      Jason.decode!(json)
    end,
    "Jiffy" => fn({_, json}) ->
      :jiffy.decode(json)
    end
  },
  warmup: 30,
  time: 30,
  memory_time: 10,
  inputs: %{
    "Small" => {:erlang.term_to_binary(list_small), Jason.encode!(list_small)},
    "Medium" => {:erlang.term_to_binary(list_medium), Jason.encode!(list_medium)},
    "Large" => {:erlang.term_to_binary(list_large), Jason.encode!(list_large)},
    "Largest" => {:erlang.term_to_binary(list_largest), Jason.encode!(list_largest)}
  },
  formatters: [{Benchee.Formatters.Console, extended_statistics: true}]
)
