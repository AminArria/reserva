defmodule ReservaWeb.TrimesterView do
  use ReservaWeb, :view

  def display_date(date) do
    "#{date.year}-#{date.month}-#{date.day}"
  end
end
