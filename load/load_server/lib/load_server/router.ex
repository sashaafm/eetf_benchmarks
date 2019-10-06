defmodule LoadServer.Router do
  use Plug.Router
  import Plug.Conn

  plug :match
  plug :dispatch

  @person %{
    name: "Tomás",
    role: :member,
    nicknames: [
      "El Matador",
      "Big Shot",
      "OG T"
    ],
    houses: [
      %{location: "Lisbon", area: 80},
      %{location: "Stockholm", area: 120}
    ],
    crimes: [
      {"murder", 0},
      {"grand theft", 2}
    ],
    father: "Júlio",
    mother: "Clotilde",
    company: %{
      name: "TopCode",
      employee_count: 20,
      industry: :tech
    }
  }

  size = :erts_debug.size(@person) * :erlang.system_info(:wordsize)
  IO.puts("Payload byte size is #{size} B")

  get "/person" do
    case get_req_header(conn, "accept") do
      ["application/json" | _] ->
        {:ok, encoded_person} = Jason.encode(@person)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, encoded_person)

      ["application/octet-stream" | _] ->
        case get_req_header(conn, "x-compression-level") do
          [] ->
            encoded_person = :erlang.term_to_binary(@person)

            conn
            |> put_resp_content_type("application/octet-stream")
            |> send_resp(200, encoded_person)

          ["1" | _] ->
            encoded_person = :erlang.term_to_binary(@person, [compressed: 1])

            conn
            |> put_resp_content_type("application/octet-stream")
            |> send_resp(200, encoded_person)

          ["6" | _] ->
            encoded_person = :erlang.term_to_binary(@person, [compressed: 6])

            conn
            |> put_resp_content_type("application/octet-stream")
            |> send_resp(200, encoded_person)

          ["9" | _] ->
            encoded_person = :erlang.term_to_binary(@person, [compressed: 9])

            conn
            |> put_resp_content_type("application/octet-stream")
            |> send_resp(200, encoded_person)
        end
    end
  end

  defimpl Jason.Encoder, for: [Tuple] do
    def encode({crime, count}, opts) do
      Jason.Encode.map(%{crime => count}, opts)
    end
  end
end
