# {:ok, _} = Application.ensure_all_started(:ex_machina)
# <- Add this
Mox.defmock(PokemonBehaviourMock, for: CollegeWeb.PokemonBehaviour)
Application.put_env(:bound, :college, PokemonBehaviourMock)

Faker.start()
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(College.Repo, :manual)
