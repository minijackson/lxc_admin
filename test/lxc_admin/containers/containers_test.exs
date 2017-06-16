defmodule LXCAdmin.ContainersTest do
  use LXCAdmin.DataCase

  alias LXCAdmin.Containers

  describe "containers" do
    alias LXCAdmin.Containers.Container

    @valid_attrs %{ephemeral: true, name: "some name"}
    @update_attrs %{ephemeral: false, name: "some updated name"}
    @invalid_attrs %{ephemeral: nil, name: nil}

    def container_fixture(attrs \\ %{}) do
      {:ok, container} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Containers.create_container()

      container
    end

    test "list_containers/0 returns all containers" do
      container = container_fixture()
      assert Containers.list_containers() == [container]
    end

    test "get_container!/1 returns the container with given id" do
      container = container_fixture()
      assert Containers.get_container!(container.id) == container
    end

    test "create_container/1 with valid data creates a container" do
      assert {:ok, %Container{} = container} = Containers.create_container(@valid_attrs)
      assert container.ephemeral == true
      assert container.name == "some name"
    end

    test "create_container/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Containers.create_container(@invalid_attrs)
    end

    test "update_container/2 with valid data updates the container" do
      container = container_fixture()
      assert {:ok, container} = Containers.update_container(container, @update_attrs)
      assert %Container{} = container
      assert container.ephemeral == false
      assert container.name == "some updated name"
    end

    test "update_container/2 with invalid data returns error changeset" do
      container = container_fixture()
      assert {:error, %Ecto.Changeset{}} = Containers.update_container(container, @invalid_attrs)
      assert container == Containers.get_container!(container.id)
    end

    test "delete_container/1 deletes the container" do
      container = container_fixture()
      assert {:ok, %Container{}} = Containers.delete_container(container)
      assert_raise Ecto.NoResultsError, fn -> Containers.get_container!(container.id) end
    end

    test "change_container/1 returns a container changeset" do
      container = container_fixture()
      assert %Ecto.Changeset{} = Containers.change_container(container)
    end
  end
end
