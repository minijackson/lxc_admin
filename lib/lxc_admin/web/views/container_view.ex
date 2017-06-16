defmodule LXCAdmin.Web.ContainerView.Macros do
  defmacro defunitprefix power, name do
    bound = :math.pow(1024, power)
    quote do
      def humanize_bytes(value) when value >= unquote(bound) do
        value = Float.round(value / unquote(bound), 2)
        "#{value} #{unquote(name)}B"
      end
    end
  end
end

defmodule LXCAdmin.Web.ContainerView do
  use LXCAdmin.Web, :view

  alias __MODULE__.Macros
  require Macros

  Macros.defunitprefix 4, "Ti"
  Macros.defunitprefix 3, "Gi"
  Macros.defunitprefix 2, "Mi"
  Macros.defunitprefix 1, "ki"

  def humanize_bytes(value) do
    "#{value} B"
  end

end
