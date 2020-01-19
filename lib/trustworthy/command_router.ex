defmodule Trustworthy.CommandRouter do
  @moduledoc false

  use Commanded.Commands.Router,
    application: Trustworthy.App

  alias Trustworthy.Customers.Commands.RegisterUser
  alias Trustworthy.Customers.Aggregates.User

  dispatch [RegisterUser], to: User, identity: :user_uuid
end
