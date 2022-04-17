defmodule Bound do
  def get_http(url) do
    IO.inspect(url)
    pokemon_impl().get_http(url)
  end

  def get_pokemon(limit, offset) do
    IO.inspect(limit)
    pokemon_impl().get_pokemon(limit, offset)
  end

  defp pokemon_impl() do
    Application.get_env(:bound, :college, CollegeWeb.Clinet)
  end
end
