defmodule CollegeWeb.Clinet do
  @behaviour CollegeWeb.PokemonBehaviour

  @impl CollegeWeb.PokemonBehaviour
  def get_pokemon(limit, offset) do
    with {:ok, response} <-
           get_http("https://pokeapi.co/api/v2/pokemon?limit=#{limit}&offset=#{offset}") do
      response =
        response.body
        |> Jason.decode()

      response
    else
      {:error, error} -> {:error, error}
    end
  end

  @impl CollegeWeb.PokemonBehaviour
  def get_http(url) do
    HTTPoison.get(url)
  end
end
