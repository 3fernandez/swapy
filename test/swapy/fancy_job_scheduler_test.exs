defmodule Swapy.FancyJobSchedulerTest do
  use ExUnit.Case

  alias Swapy.FancyJobScheduler

  setup do
    pid =
      %{
        id: FancyJobSchedulerTest,
        start: {FancyJobScheduler, :start_link, [[name: FancyJobSchedulerTest]]}
      }
      |> start_supervised!()

    %{pid: pid}
  end

  test "should be able to recover from unexpected exits", %{pid: pid} do
    Process.exit(pid, :normal)

    assert :ok = FancyJobScheduler.schedule_job(FancyJobSchedulerTest)
  end
end
