defmodule College.PokemonTest do
  use ExUnit.Case
  alias CollegeWeb.Factory

  import Mox

  setup :verify_on_exit!

  defstruct response: Factory.get_response()

  describe "get_http/1" do
    test ":ok on 200" do
      expect(PokemonBehaviourMock, :get_http, fn args ->
        assert args == "https://pokeapi.co/api/v2/pokemon?offset=0&limit=10"
        {:ok, %HTTPoison.Response{body: "some pokemon", status_code: 200}}
      end)

      assert {:ok, %{status_code: 200}} =
               Bound.get_http("https://pokeapi.co/api/v2/pokemon?offset=0&limit=10")
    end

    test ":error on 404" do
      expect(PokemonBehaviourMock, :get_http, fn args ->
        assert args == "https://pokeapi.co/api/v2/pokemon?offset=0&limit=10"
        {:ok, %HTTPoison.Response{status_code: 404}}
      end)

      assert {:ok, %{status_code: 404}} =
               Bound.get_http("https://pokeapi.co/api/v2/pokemon?offset=0&limit=10")
    end
  end

  describe "get_pokemon saved api" do
    test "compatibility between the real api response and the expected data" do
      expect(PokemonBehaviourMock, :get_pokemon, fn _limit, _offset ->
        pokemon_api = %__MODULE__{}
        {:ok, response} = pokemon_api.response
        {:ok, response}
      end)

      assert Bound.get_pokemon(10, 0) ==
               {:ok,
                %{
                  "count" => 1126,
                  "next" => "https://pokeapi.co/api/v2/pokemon?offset=10&limit=10",
                  "previous" => nil,
                  "results" => [
                    %{"name" => "bulbasaur", "url" => "https://pokeapi.co/api/v2/pokemon/1/"},
                    %{"name" => "ivysaur", "url" => "https://pokeapi.co/api/v2/pokemon/2/"},
                    %{"name" => "venusaur", "url" => "https://pokeapi.co/api/v2/pokemon/3/"},
                    %{"name" => "charmander", "url" => "https://pokeapi.co/api/v2/pokemon/4/"},
                    %{"name" => "charmeleon", "url" => "https://pokeapi.co/api/v2/pokemon/5/"},
                    %{"name" => "charizard", "url" => "https://pokeapi.co/api/v2/pokemon/6/"},
                    %{"name" => "squirtle", "url" => "https://pokeapi.co/api/v2/pokemon/7/"},
                    %{"name" => "wartortle", "url" => "https://pokeapi.co/api/v2/pokemon/8/"},
                    %{"name" => "blastoise", "url" => "https://pokeapi.co/api/v2/pokemon/9/"},
                    %{"name" => "caterpie", "url" => "https://pokeapi.co/api/v2/pokemon/10/"}
                  ]
                }}
    end
  end

  describe "get_pokemon/2" do
    test "fetches pokemons based on specified limit and offset" do
      Mox.stub(PokemonBehaviourMock, :get_pokemon, fn _limit, _offset ->
        response = %{
          "count" => 1126,
          "next" => "https://pokeapi.co/api/v2/pokemon?offset=10&limit=10",
          "previous" => nil,
          "results" => [
            %{"name" => "bulbasaur", "url" => "https://pokeapi.co/api/v2/pokemon/1/"},
            %{"name" => "ivysaur", "url" => "https://pokeapi.co/api/v2/pokemon/2/"},
            %{"name" => "venusaur", "url" => "https://pokeapi.co/api/v2/pokemon/3/"},
            %{"name" => "charmander", "url" => "https://pokeapi.co/api/v2/pokemon/4/"},
            %{"name" => "charmeleon", "url" => "https://pokeapi.co/api/v2/pokemon/5/"},
            %{"name" => "charizard", "url" => "https://pokeapi.co/api/v2/pokemon/6/"},
            %{"name" => "squirtle", "url" => "https://pokeapi.co/api/v2/pokemon/7/"},
            %{"name" => "wartortle", "url" => "https://pokeapi.co/api/v2/pokemon/8/"},
            %{"name" => "blastoise", "url" => "https://pokeapi.co/api/v2/pokemon/9/"},
            %{"name" => "caterpie", "url" => "https://pokeapi.co/api/v2/pokemon/10/"}
          ]
        }

        {:ok, response}
      end)

      {:ok, response} = Bound.get_pokemon(10, 0)
      assert response["count"] == 1126
      assert response["next"] == "https://pokeapi.co/api/v2/pokemon?offset=10&limit=10"
      assert length(response["results"]) == 10
      assert is_list(response["results"]) == true

      assert Bound.get_pokemon(10, 0) ==
               {:ok,
                %{
                  "count" => 1126,
                  "next" => "https://pokeapi.co/api/v2/pokemon?offset=10&limit=10",
                  "previous" => nil,
                  "results" => [
                    %{"name" => "bulbasaur", "url" => "https://pokeapi.co/api/v2/pokemon/1/"},
                    %{"name" => "ivysaur", "url" => "https://pokeapi.co/api/v2/pokemon/2/"},
                    %{"name" => "venusaur", "url" => "https://pokeapi.co/api/v2/pokemon/3/"},
                    %{"name" => "charmander", "url" => "https://pokeapi.co/api/v2/pokemon/4/"},
                    %{"name" => "charmeleon", "url" => "https://pokeapi.co/api/v2/pokemon/5/"},
                    %{"name" => "charizard", "url" => "https://pokeapi.co/api/v2/pokemon/6/"},
                    %{"name" => "squirtle", "url" => "https://pokeapi.co/api/v2/pokemon/7/"},
                    %{"name" => "wartortle", "url" => "https://pokeapi.co/api/v2/pokemon/8/"},
                    %{"name" => "blastoise", "url" => "https://pokeapi.co/api/v2/pokemon/9/"},
                    %{"name" => "caterpie", "url" => "https://pokeapi.co/api/v2/pokemon/10/"}
                  ]
                }}
    end
  end
end
