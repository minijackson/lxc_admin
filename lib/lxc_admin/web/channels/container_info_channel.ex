defmodule LXCAdmin.Web.ContainerInfoChannel do
  @moduledoc ~S"""
  
  """

  use Phoenix.Channel

  alias LXCAdmin.Containers
  alias LXCAdmin.Containers.Container

  def join("containers_short_info", _message, socket) do
    {:ok, socket}
  end

  def join("container_info:" <> container_name, _message, socket) do
    case Containers.exists?(container_name) do
      true -> {:ok, socket}
      false -> {:error, %{reason: "container '#{container_name}' does not exists"}}
    end
  end

  def join(_room, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("update", %{}, socket) do
    handle_update(socket.topic, socket)
  end

  def handle_update("containers_short_info", socket) do
    infos = Containers.list_containers_short()
            |> Enum.map(fn %Container{name: name, state: state, ip: ip} -> 
              {name, %{state: state, ip: ip}}
            end)
            |> Enum.sort_by(fn {name, _} -> name end)
            |> Enum.into(%{})

    push socket, "update", infos
    {:noreply, socket}
  end

  def handle_update("container_info:" <> container_name, socket) do
    container = Containers.get_container!(container_name)
    push socket, "update", container
    {:noreply, socket}
  end

end
