defmodule CollegeWeb.Request do
  @behaviour CollegeWeb.PokemonBehaviour

  @impl CollegeWeb.PokemonBehaviour
  def get_http(url) do
    HTTPoison.get(url)
  end
end
