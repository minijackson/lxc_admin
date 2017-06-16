defmodule LXCAdmin.Containers.Container do
  @moduledoc ~S"""
  
  """

  @derive {Phoenix.Param, key: :name}

  defstruct name: nil, state: nil,
    pid: nil, cpu: nil,
    blkIO: nil, memory: nil, kMem: nil,
    ip: nil, link: nil, tx: nil, rx: nil, total: nil

  def from_lxc_info(output) do
    {:ok, symbols, _num} = output
                           |> String.to_charlist
                           |> :lxc_info_lexer.string
    {:ok, infos} = :lxc_info_parser.parse(symbols)

    struct(__MODULE__, infos)
  end

end
