defmodule College.PokemonTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  describe "get_http/1" do
    test "fetches pokemons based on specified limit and offset" do
      expect(PokemonBehaviourMock, :get_http, fn args ->
        assert args == "https://pokeapi.co/api/v2/pokemon?offset=0&limit=10"

        response = %HTTPoison.Response{
          body:
            "{\"count\":1126,\"next\":\"https://pokeapi.co/api/v2/pokemon?offset=10&limit=10\",\"previous\":null,\"results\":[{\"name\":\"bulbasaur\",\"url\":\"https://pokeapi.co/api/v2/pokemon/1/\"},{\"name\":\"ivysaur\",\"url\":\"https://pokeapi.co/api/v2/pokemon/2/\"},{\"name\":\"venusaur\",\"url\":\"https://pokeapi.co/api/v2/pokemon/3/\"},{\"name\":\"charmander\",\"url\":\"https://pokeapi.co/api/v2/pokemon/4/\"},{\"name\":\"charmeleon\",\"url\":\"https://pokeapi.co/api/v2/pokemon/5/\"},{\"name\":\"charizard\",\"url\":\"https://pokeapi.co/api/v2/pokemon/6/\"},{\"name\":\"squirtle\",\"url\":\"https://pokeapi.co/api/v2/pokemon/7/\"},{\"name\":\"wartortle\",\"url\":\"https://pokeapi.co/api/v2/pokemon/8/\"},{\"name\":\"blastoise\",\"url\":\"https://pokeapi.co/api/v2/pokemon/9/\"},{\"name\":\"caterpie\",\"url\":\"https://pokeapi.co/api/v2/pokemon/10/\"}]}",
          headers: [
            {"Date", "Sat, 16 Apr 2022 17:43:04 GMT"},
            {"Content-Type", "application/json; charset=utf-8"},
            {"Transfer-Encoding", "chunked"},
            {"Connection", "keep-alive"},
            {"access-control-allow-origin", "*"},
            {"Cache-Control", "public, max-age=86400, s-maxage=86400"},
            {"etag", "W/\"2fa-TMmoXZnWSt8oZQqeJSKIjQ4R/Rs\""},
            {"function-execution-id", "tjwr5by7i6ll"},
            {"strict-transport-security", "max-age=31556926"},
            {"x-cloud-trace-context", "10464ef9196b0fa739bbfd7909437917"},
            {"x-country-code", "ES"},
            {"x-orig-accept-language", "es-ES,es;q=0.9,en;q=0.8"},
            {"x-powered-by", "Express"},
            {"x-served-by", "cache-mrs10583-MRS"},
            {"x-cache", "MISS"},
            {"x-cache-hits", "0"},
            {"x-timer", "S1650116094.464852,VS0,VE386"},
            {"vary",
             "Accept-Encoding,cookie,need-authorization, x-fh-requested-host, accept-encoding"},
            {"CF-Cache-Status", "HIT"},
            {"Age", "14890"},
            {"Expect-CT",
             "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\""},
            {"Report-To",
             "{\"endpoints\":[{\"url\":\"https:\\/\\/a.nel.cloudflare.com\\/report\\/v3?s=c14RMHYaTdq0uX50i80oITZzjU1aJxGR1owE6MScksJtqkTT3UikF3jH3kI8hSAIP%2BE%2B5iOstCD15gT2RQBseb3cUx4ajCfAvEL4aL2D%2Bn%2FpWRQSpJHuXyWXvNFg\"}],\"group\":\"cf-nel\",\"max_age\":604800}"},
            {"NEL", "{\"success_fraction\":0,\"report_to\":\"cf-nel\",\"max_age\":604800}"},
            {"Server", "cloudflare"},
            {"CF-RAY", "6fceb89ebd7fcd4d-ZDM"},
            {"alt-svc", "h3=\":443\"; ma=86400, h3-29=\":443\"; ma=86400"}
          ],
          request: %HTTPoison.Request{
            body: "",
            headers: [],
            method: :get,
            options: [],
            params: %{},
            url: "https://pokeapi.co/api/v2/pokemon?limit=10&offset=0"
          },
          request_url: "https://pokeapi.co/api/v2/pokemon?limit=10&offset=0",
          status_code: 200
        }

        {:ok, response}
      end)

      assert {:ok, _} = Bound.get_http("https://pokeapi.co/api/v2/pokemon?offset=0&limit=10")
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
