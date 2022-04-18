defmodule Bound do
  def get_http(url) do
    pokemon_impl().get_http(url)
  end

  def get_pokemon(limit, offset) do
    pokemon_impl().get_pokemon(limit, offset)
  end

  defp pokemon_impl() do
    Application.get_env(:bound, :college, CollegeWeb.Clinet)
  end
end
