defmodule CollegeWeb.ClientBehaviour do
  @callback get_pokemon(integer(), integer()) :: {:ok, map()} | {:error, term()}
  @callback get_http(url :: String.t()) :: {:ok, map()} | {:error, term()}
  @callback post_http(url :: String.t() , body :: map() , headers :: list()) :: {:ok, map()} | {:error, term()}
  @callback create_student(map()) :: {:ok, map()} | {:error, term()}
end
