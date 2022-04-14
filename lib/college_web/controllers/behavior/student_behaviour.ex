defmodule CollegeWeb.StudentBehavior do
  @callback create(Plug.Conn.t, %{String.t => String.t}) :: Plug.Conn.t
end
