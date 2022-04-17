defmodule CollegeWeb.PokemonView do
  use CollegeWeb, :view

  def render("index.json", %{data: data}) do
    IO.inspect(data["count"])
    %{
      count: data["count"],
      next: data["next"],
      previous: data["previous"],
      results: render_many(data["results"], __MODULE__,"show.json")
    }

  end

  def render("show.json", %{pokemon: pokemon}) do
    %{
      name: pokemon["name"],
      url: pokemon["url"]
    }
  end


end
