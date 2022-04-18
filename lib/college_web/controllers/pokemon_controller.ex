defmodule CollegeWeb.PokemonController do
  use CollegeWeb, :controller

  def index(conn, params) do
    case CollegeWeb.Clinet.get_pokemon(params["limit"], params["offset"]) do
      {:ok, data} -> render(conn, "index.json", data: data)
      {:error, error} -> json(conn, error.reason)
    end
  end
end
