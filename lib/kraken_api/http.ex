defmodule KrakenApi.Http do
  @moduledoc """
  HTTP helpers for Kraken
  """

  # Returns a tuple {status, result}
  def get(method) do
    query_url = Application.get_env(:kraken_api, :api_endpoint) <> "/" <> Application.get_env(:kraken_api, :api_version)
    <> "/public/" <> method

    case HTTPoison.get(query_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body = Poison.decode!(body)
        {:ok, Map.get(body, "result")}
      # Try to get and display the error message from Kraken.
      {:ok, %HTTPoison.Response{status_code: _, body: body}} ->
        body = Poison.decode!(body)
        {:error, Map.get(body, "error")}
        # Otherwise just error
        _ ->
        {:error, %{}}
    end
  end
end
