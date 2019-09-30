defmodule Randomizer do
  def person do
    %{
      name: string(Enum.random(2..16), :downcase),
      surname: string(Enum.random(2..20), :downcase),
      age: Enum.random(0..125),
      company: string(Enum.random(2..24), :alpha),
      cars: list(Enum.random(0..4), fn ->
        %{
          brand: string(Enum.random(2..16), :downcase),
          model: string(Enum.random(2..16), :alpha)
        }
      end),
      body_temperature: float(35, 42),
      marital_status: Enum.at([:single, :married, :divorced], Enum.random(0..2)),
      birth_place: "#{string(Enum.random(2..16))}, #{string(Enum.random(2..16))}",
      looking_for_job: Enum.at([true, false], Enum.random(0..1))
    }
  end

  def float(min, max) do
    Float.round(:rand.uniform() * 10, 1)
  end

  def int, do: Enum.random(1..1_000_000)

  def list(len, fun) do
    filter_ok_results = fn(result) ->
      case result do
        {:ok, _} -> true
        _ -> false
      end
    end

    1..len
    |> Enum.map(fn(_) -> Task.async(fn -> fun.() end) end)
    |> Task.yield_many
    |> Enum.map(fn({task, res}) -> res || Task.shutdown(task, :brutal_kill) end)
    |> Enum.filter(filter_ok_results)
    |> Enum.map(&elem(&1, 1))
  end

  # String randomizer taken from
  # https://gist.github.com/ahmadshah/8d978bbc550128cca12dd917a09ddfb7
  def string(length, type \\ :all) do
    alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    numbers = "0123456789"
    lists =
      cond do
        type == :alpha -> alphabets <> String.downcase(alphabets)
        type == :numeric -> numbers
        type == :upcase -> alphabets
        type == :downcase -> String.downcase(alphabets)
        true -> alphabets <> String.downcase(alphabets) <> numbers
      end
      |> String.split("", trim: true)
    do_randomizer(length, lists)
  end

  @doc false
  defp get_range(length) when length > 1, do: (1..length)
  defp get_range(_), do: [1]

  @doc false
  defp do_randomizer(length, lists) do
    get_range(length)
    |> Enum.reduce([], fn(_, acc) -> [Enum.random(lists) | acc] end)
    |> Enum.join("")
  end
end
