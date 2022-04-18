defmodule CollegeWeb.PokemonBehaviour do
  @callback get_pokemon(integer(), integer()) :: {:ok, map()} | {:error, term()}
  @callback get_http(url :: String.t()) :: {:ok, map()} | {:error, term()}
end
