defmodule LXCAdmin.Containers do
  @moduledoc """
  The boundary for the Containers system.
  """

  alias LXCAdmin.Containers.Container

  @doc """
  Returns the list of containers.

  ## Examples

      iex> list_containers()
      [%Container{}, ...]

  """
  def list_containers do
    for name <- list_container_names() do
      get_container!(name)
    end
  end

  def list_containers_short do
    for name <- list_container_names() do
      get_container_short!(name)
    end
  end

  def list_container_names do
    %Porcelain.Result{out: output, status: 0} = Porcelain.exec "lxc-ls", ["-1"]
    output
    |> String.trim
    |> String.split "\n"
  end

  @doc """
  Gets a single container.

  Raises if the Container does not exist.

  ## Examples

      iex> get_container!(123)
      %Container{}

  """
  def get_container!(name) do
    %Porcelain.Result{out: output, status: 0} = Porcelain.exec "lxc-info", ["-n", name, "-H"]
    Container.from_lxc_info output
  end

  def get_container_short!(name) do
    %Porcelain.Result{out: output, status: 0} = Porcelain.exec "lxc-info", ["-sin", name]
    Container.from_lxc_info(output)
    |> Map.put(:name, name)
  end

  @doc ~S"""
  
  """
  def exists?(name) do
    case Porcelain.exec("lxc-info", ["-n", name, "-s"]).status do
      0 -> true
      _ -> false
    end
  end

  @doc """
  Creates a container.

  ## Examples

      iex> create_container(%{field: value})
      {:ok, %Container{}}

      iex> create_container(%{field: bad_value})
      {:error, ...}

  """
  def create_container(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a container.

  ## Examples

      iex> update_container(container, %{field: new_value})
      {:ok, %Container{}}

      iex> update_container(container, %{field: bad_value})
      {:error, ...}

  """
  def update_container(%Container{} = container, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Container.

  ## Examples

      iex> delete_container(container)
      {:ok, %Container{}}

      iex> delete_container(container)
      {:error, ...}

  """
  def delete_container(%Container{} = container) do
    raise "TODO"
  end

  @doc """
  Returns a datastructure for tracking container changes.

  ## Examples

      iex> change_container(container)
      %Todo{...}

  """
  def change_container(%Container{} = container) do
    raise "TODO"
  end
end
