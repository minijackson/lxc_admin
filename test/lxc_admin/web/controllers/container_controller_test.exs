defmodule LXCAdmin.Web.ContainerControllerTest do
  use LXCAdmin.Web.ConnCase

  alias LXCAdmin.Containers

  @create_attrs %{ephemeral: true, name: "some name"}
  @update_attrs %{ephemeral: false, name: "some updated name"}
  @invalid_attrs %{ephemeral: nil, name: nil}

  def fixture(:container) do
    {:ok, container} = Containers.create_container(@create_attrs)
    container
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, container_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Containers"
  end

  test "renders form for new containers", %{conn: conn} do
    conn = get conn, container_path(conn, :new)
    assert html_response(conn, 200) =~ "New Container"
  end

  test "creates container and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, container_path(conn, :create), container: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == container_path(conn, :show, id)

    conn = get conn, container_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Container"
  end

  test "does not create container and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, container_path(conn, :create), container: @invalid_attrs
    assert html_response(conn, 200) =~ "New Container"
  end

  test "renders form for editing chosen container", %{conn: conn} do
    container = fixture(:container)
    conn = get conn, container_path(conn, :edit, container)
    assert html_response(conn, 200) =~ "Edit Container"
  end

  test "updates chosen container and redirects when data is valid", %{conn: conn} do
    container = fixture(:container)
    conn = put conn, container_path(conn, :update, container), container: @update_attrs
    assert redirected_to(conn) == container_path(conn, :show, container)

    conn = get conn, container_path(conn, :show, container)
    assert html_response(conn, 200) =~ "some updated name"
  end

  test "does not update chosen container and renders errors when data is invalid", %{conn: conn} do
    container = fixture(:container)
    conn = put conn, container_path(conn, :update, container), container: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Container"
  end

  test "deletes chosen container", %{conn: conn} do
    container = fixture(:container)
    conn = delete conn, container_path(conn, :delete, container)
    assert redirected_to(conn) == container_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, container_path(conn, :show, container)
    end
  end
end
