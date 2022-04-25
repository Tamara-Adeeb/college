defmodule CollegeWeb.Clinet do
  alias CollegeWeb.Request
  @behaviour CollegeWeb.ClientBehaviour

  @body %{
    address: "Ramallah",
    date_of_birth: "2000-01-01",
    email: "kenyaa@iikk",
    first_name: "Tena",
    gender: "female",
    last_name: "Adeeb"
  }

  @impl CollegeWeb.ClientBehaviour
  def get_pokemon(limit, offset) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           Request.get_http("https://pokeapi.co/api/v2/pokemon?limit=#{limit}&offset=#{offset}") do
      Jason.decode(body)
    else
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} -> {:error, Jason.decode(body)}
      {:ok, %HTTPoison.Response{status_code: 500, body: body}} -> {:error, Jason.decode(body)}
      {:error, error} -> {:error, error}
    end
  end

  @impl CollegeWeb.ClientBehaviour
  def create_student(body) do
    {:ok, body} = Poison.encode(body)
    headers = [{"Content-type", "application/json"}]
    IO.inspect(body)

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           Request.post_http("http://localhost:4000/api/students/", body, headers) do
      Jason.decode(body)
    else
      {:error, error} -> {:error, error}
    end
  end
end

# {:ok,
#  %{
#    "data" => %{
#      "address" => "Ramallah",
#      "courses" => [],
#      "date_of_birth" => "2000-01-01",
#      "email" => "kenyaa@iikk",
#      "first_name" => "Tena",
#      "gender" => "female",
#      "id" => 8,
#      "last_name" => "Adeeb"
#    }
#  }}
