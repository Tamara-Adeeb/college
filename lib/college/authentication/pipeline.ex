defmodule College.Authentication.Pipeline do
  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
    otp_app: :college,
    module: College.Authentication.Guardian,
    error_handler: College.Authentication.ErrorHandler

  plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, ensure: true)

end
