defmodule LXCAdmin.Web.ContainerController do
  use LXCAdmin.Web, :controller

  alias LXCAdmin.Containers

  def index(conn, _params) do
    containers = Containers.list_containers_short()
    render(conn, "index.html", containers: containers)
  end

  def new(conn, _params) do
    changeset = Containers.change_container(%LXCAdmin.Containers.Container{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"container" => container_params}) do
    case Containers.create_container(container_params) do
      {:ok, container} ->
        conn
        |> put_flash(:info, "Container created successfully.")
        |> redirect(to: container_path(conn, :show, container))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    container = Containers.get_container!(id)
    render(conn, "show.html", container: container)
  end

  def edit(conn, %{"id" => id}) do
    container = Containers.get_container!(id)
    changeset = Containers.change_container(container)
    render(conn, "edit.html", container: container, changeset: changeset)
  end

  def update(conn, %{"id" => id, "container" => container_params}) do
    container = Containers.get_container!(id)

    case Containers.update_container(container, container_params) do
      {:ok, container} ->
        conn
        |> put_flash(:info, "Container updated successfully.")
        |> redirect(to: container_path(conn, :show, container))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", container: container, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    container = Containers.get_container!(id)
    {:ok, _container} = Containers.delete_container(container)

    conn
    |> put_flash(:info, "Container deleted successfully.")
    |> redirect(to: container_path(conn, :index))
  end
end
