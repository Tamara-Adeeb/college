# {:ok, _} = Application.ensure_all_started(:ex_machina)
# <- Add this
Mox.defmock(ClientBehaviourMock, for: CollegeWeb.ClientBehaviour)
Application.put_env(:bound, :college, ClientBehaviourMock)

Faker.start()
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(College.Repo, :manual)
