defmodule TrustworthyWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TrustworthyWeb, :controller

  def call(conn, {:error, :validation_failure, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(TrustworthyWeb.ValidationView)
    |> render("error.json", errors: errors)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(TrustworthyWeb.ErrorView)
    |> render(:"404")
  end
end
