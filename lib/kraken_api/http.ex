defmodule KrakenApi.Http do
  @moduledoc """
  HTTP helpers for Kraken
  """

  # Returns a tuple {status, result}
  def get(method) do
    query_url = Application.get_env(:kraken_api, :api_endpoint) <> "/" <> Application.get_env(:kraken_api, :api_version)
    <> "/public/" <> method

    HTTPoison.get(query_url)
    |> api_response
  end

  def signed_post(method, params, nonce \\ DateTime.utc_now() |> DateTime.to_unix(:millisecond) |> to_string) do
    post_data = Map.merge(params, %{"nonce": nonce})
    path = "/" <> Application.get_env(:kraken_api, :api_version) <> "/private/" <> method
    query_url = Application.get_env(:kraken_api, :api_endpoint) <> path

    api_signature = signature(path, post_data, Application.get_env(:kraken_api, :private_key), nonce)

    # Transform the data into list-of-tuple format required by HTTPoison.
    post_data = Enum.map(post_data, fn({k, v}) -> {k, v} end)

    HTTPoison.post(query_url, {:form, Map.to_list(post_data)},
      [{"API-Key", Application.get_env(:kraken_api, :api_key)}, {"API-Sign", api_signature}, {"Content-Type", "application/x-www-form-urlencoded"}])
      |> api_response
  end

  def api_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, Map.get(Poison.decode!(body), "result")}
  end

  def api_response({:ok, %HTTPoison.Response{status_code: _, body: body}}) do
    {:error, Map.get(Poison.decode!(body), "error") }
  end

  def api_response(_) do
    {:error, %{}}
  end

  # Function to sign the private request.
  def signature(path, post_data, private_key, nonce) do
    post_data = URI.encode_query(post_data)
    decoded_key = Base.decode64!(private_key)
    hash_result = :crypto.hash(:sha256, nonce <> post_data)
    :crypto.hmac(:sha512, decoded_key, path <> hash_result) |> Base.encode64
  end
end
