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

  # Function to sign the private request.
  def sign(path, post_data, private_key, nonce) do
    post_data = URI.encode_query(post_data)
    decoded_key = Base.decode64!(private_key)
    hash_result = :crypto.hash(:sha256, nonce <> post_data)
    :crypto.hmac(:sha512, decoded_key, path <> hash_result) |> Base.encode64
  end

  def invoke_private_api(method, params, nonce \\ DateTime.utc_now() |> DateTime.to_unix(:millisecond) |> to_string) do
    post_data = Map.merge(params, %{"nonce": nonce})
    path = "/" <> Application.get_env(:kraken_api, :api_version) <> "/private/" <> method
    query_url = Application.get_env(:kraken_api, :api_endpoint) <> path

    signed_message = sign(path, post_data, Application.get_env(:kraken_api, :private_key), nonce)

    # Transform the data into list-of-tuple format required by HTTPoison.
    post_data = Enum.map(post_data, fn({k, v}) -> {k, v} end)
    case HTTPoison.post(query_url,
           {:form, post_data},
           [{"API-Key", Application.get_env(:kraken_api, :api_key)}, {"API-Sign", signed_message}, {"Content-Type", "application/x-www-form-urlencoded"}]
         ) do
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
end
