defmodule CollegeWeb.Clinet do
  alias CollegeWeb.Request
  @behaviour CollegeWeb.PokemonBehaviour

  @impl CollegeWeb.PokemonBehaviour
  def get_pokemon(limit, offset) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
      Request.get_http("https://pokeapi.co/api/v2/pokemon?limit=#{limit}&offset=#{offset}") do
      Jason.decode(body)
    else
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} -> {:error , Jason.decode(body)}
      {:ok, %HTTPoison.Response{status_code: 500, body: body}} -> {:error , Jason.decode(body)}
      {:error, error} -> {:error, error}
    end
  end


end
