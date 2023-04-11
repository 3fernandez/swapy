defmodule Swapy.DataStream do
  @moduledoc """
  The DataStream module will act as a Stream builder, 
  leveraging Stream.resource/3 fn. Due to the nature of 
  Github paginated API, I've decided to go with 'lazily' 
  type of approach instead of 'eagerly'.
  """

  @endpoint "https://api.github.com/repos"
  @params %{state: "all", per_page: "100"}
  @webhook_address "https://webhook.site/4596c005-3918-434b-84b8-3cf4904e40a7"

  def new(resource_path) do
    Stream.resource(
      fn -> fetch_page(resource_path) end,
      &process_page/1,
      &done/1
    )
  end

  def send_issues(body) do
    http_client().post(@webhook_address, Jason.encode!(body))
  end

  defp fetch_page(resource_path) do
    response = http_client().get!(@endpoint <> resource_path, [], params: @params)
    issues = decode_issues(response.body)
    next_page_link = next_page_link(response.headers)

    {issues, next_page_link}
  end

  defp http_client(), do: Application.get_env(:swapy, :http_client)

  defp decode_issues(response_body) do
    response_body
    |> Jason.decode!(keys: :atoms)
    |> Enum.map(fn issue ->
      %{
        labels: issue[:labels],
        title: issue[:title],
        author: issue[:user][:login]
      }
    end)
  end

  defp next_page_link(headers) do
    links =
      headers
      |> List.keyfind("Link", 0, {nil, nil})
      |> elem(1)
      |> parse_links()

    links["next"]
  end

  defp parse_links(nil), do: %{}

  defp parse_links(links_string) do
    links = String.split(links_string, ", ")

    Enum.map(links, fn link ->
      [_, name] = Regex.run(~r{rel="([a-z]+)"}, link)
      [_, url] = Regex.run(~r{<([^>]+)>}, link)
      resource_path = String.replace(url, @endpoint, "")

      {name, resource_path}
    end)
    |> Enum.into(%{})
  end

  defp process_page({nil, nil}), do: {:halt, nil}

  defp process_page({nil, next_page_url}) do
    next_page_url
    |> fetch_page()
    |> process_page()
  end

  defp process_page({issues, next_page_url}) do
    {issues, {nil, next_page_url}}
  end

  defp done(_), do: nil
end
