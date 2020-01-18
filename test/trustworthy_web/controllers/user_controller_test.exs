defmodule TrustworthyWeb.UserControllerTest do
  @moduledoc false
  use TrustworthyWeb.ConnCase

  alias Trustworthy.Customers

  describe "register user" do
    @tag :web
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: build(:user))

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    @tag :web
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: build(:user, username: ""))
      response = html_response(conn, 200)
      assert response =~ "New User"
      assert response =~ "something went wrong"
      assert response =~ "can&#39;t be blank"
    end

    @tag :web
    @tag :wip
    test "renders errors when username has been taken", %{conn: conn} do
      # register a user
      fixture(:user, %{username: "jvoegele"})

      # attempt to register the same username
      conn = post(conn, Routes.user_path(conn, :create), user: build(:user, username: "jvoegele"))
      response = html_response(conn, 200)
      assert response =~ "New User"
      assert response =~ "something went wrong"
      assert response =~ "already taken"
    end
  end


  @create_attrs %{hashed_password: "some hashed_password", username: "some username"}
  @update_attrs %{hashed_password: "some updated hashed_password", username: "some updated username"}
  @invalid_attrs %{hashed_password: nil, username: nil}

  def fixture(:user, attrs \\ %{}) do
    attrs = Map.merge(@create_attrs, attrs)
    {:ok, user} = Customers.create_user(attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "some updated hashed_password"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.user_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
