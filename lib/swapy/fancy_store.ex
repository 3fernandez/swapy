defmodule Swapy.FancyStore do
  @moduledoc """
  My custom key/value data store implementation, based on 
  Erlang :dets(a disk persistent version of :ets).
  """

  @table_name :github_data

  def start_link(opts \\ []) do
    Task.start_link(fn ->
      {:ok, _} =
        :dets.open_file(
          opts[:table_name] || @table_name,
          [{:auto_save, :timer.seconds(1)} | opts]
        )

      :ok = :dets.delete_all_objects(@table_name)
      Process.hibernate(Function, :identity, [nil])
    end)
  end

  def all(table_name \\ @table_name) do
    case :dets.foldl(fn elem, acc -> [elem | acc] end, [], table_name) do
      [] ->
        {:ok, nil}

      table_objects ->
        values =
          table_objects
          |> extract_values()
          |> List.flatten()

        {:ok, values}
    end
  end

  def put(key, value, table_name \\ @table_name) do
    :dets.insert(table_name, {key, value})
  end

  defp extract_values(table_objects) do
    for {_key, value} <- table_objects, do: value
  end
end
