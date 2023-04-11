defmodule Swapy.FancyStoreTest do
  use ExUnit.Case

  alias Swapy.FancyStore
  @test_table :test_table

  setup do
    pid =
      %{
        id: FancyStoreTest,
        start: {FancyStore, :start_link, [[table_name: @test_table]]}
      }
      |> start_supervised!()

    %{pid: pid}
  end

  test "should store data into the key/value FancyStore" do
    # FancyStore.put("1", "John Due", @test_table)
  end
end
