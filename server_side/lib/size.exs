payload = Randomizer.person()
payload_size = :erts_debug.flat_size(payload) * :erlang.system_info(:wordsize)
IO.puts("Payload size is #{payload_size} B")
payloads = Encoder.encode(payload)
etf_0 = payloads.etf_0
etf_1 = payloads.etf_1
jason = Jason.encode!(payload)
jiffy = :jiffy.encode(payload)
size_etf_0 = byte_size(etf_0)
size_etf_1 = byte_size(etf_1)
size_jason = byte_size(jason)
size_jiffy = byte_size(jiffy)
perc_etf_1 = Float.round(100 - (size_etf_1 / size_etf_0) * 100, 2)
perc_jason = Float.round(100 - (size_jason / size_etf_0) * 100, 2)
perc_jiffy = Float.round(100 - (size_jiffy / size_etf_0) * 100, 2)

IO.puts("External Term Format (Compression 0) => #{byte_size(etf_0)} Byte")
IO.puts("External Term Format (Compression 1) => #{byte_size(etf_1)} Byte - #{perc_etf_1}% smaller")
IO.puts("Jason                                => #{byte_size(jason)} Byte - #{perc_jason}% smaller")
IO.puts("Jiffy                                => #{byte_size(jiffy)} Byte - #{perc_jiffy}% smaller")
