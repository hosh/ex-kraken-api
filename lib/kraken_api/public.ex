defmodule KrakenApi.Public do
  @moduledoc """
  Public Kraken API calls
  """

  alias KarkenApi.Http, as: Http

  @doc """
  Get the server time.

  (This API call accepts no parameters)

  ## Example

  iex(1)> KrakenApi.Public.server_time()
  {:ok, %{"rfc1123" => "Thu,  5 Oct 17 14:03:21 +0000", "unixtime" => 1507212201}}
  """
  def server_time() do
    Http.get("Time")
  end

  @doc """
  Get asset info.

  Params:
  - info = info to retrieve (optional):
  - info = all info (default)
  - aclass = asset class (optional):
  - currency (default)
  - asset = comma delimited list of assets to get info on (optional.  default = all for given asset class)

  ## Example

  iex(1)> KrakenApi.Public.asset_info()
  {:ok,
  %{"BCH" => %{"aclass" => "currency", "altname" => "BCH", "decimals" => 10,
  "display_decimals" => 5},
  ...
  }

  iex(1)> KrakenApi.Public.asset_info(%{asset: "BCH,XBT"})
  {:ok,
  %{"BCH" => %{"aclass" => "currency", "altname" => "BCH", "decimals" => 10,
  "display_decimals" => 5},
  "XXBT" => %{"aclass" => "currency", "altname" => "XBT", "decimals" => 10,
  "display_decimals" => 5}}}
  """
  def asset_info(params \\ %{}) do
    Http.get("Assets?" <> URI.encode_query(params))
  end

  @doc """
  Get tradable asset pairs

  Params:
  - info = info to retrieve (optional):
  - info = all info (default)
  - leverage = leverage info
  - fees = fees schedule
  - margin = margin info
  - pair = comma delimited list of asset pairs to get info on (optional.  default = all)
  """
  def tradable_asset_pairs(params \\ %{}) do
    Http.get("AssetPairs?" <> URI.encode_query(params))
  end

  @doc """
  Get ticker information

  Param:
  - pair = comma delimited list of asset pairs to get info on
  """
  def ticker_information(params \\ %{}) do
    Http.get("Ticker" <> URI.encode_query(params))
  end

  @doc """
  Get OHLC data

  Params:
  - pair = asset pair to get OHLC data for
  - interval = time frame interval in minutes (optional):
  1 (default), 5, 15, 30, 60, 240, 1440, 10080, 21600
  - since = return committed OHLC data since given id (optional.  exclusive)
  """
  def ohlc_data(params \\ %{}) do
    Http.get("OHLC" <> URI.encode_query(params))
  end

  @doc """
  Get order book

  Params:
  - pair = asset pair to get market depth for
  - count = maximum number of asks/bids (optional)
  """
  def order_book(params \\ %{}) do
    Http.get("Depth" <> URI.encode_query(params))
  end

  @doc """
  Get recent trades

  Params:
  - pair = asset pair to get spread data for
  - since = return spread data since given id (optional.  inclusive)
  """
  def recent_trades(params \\ %{}) do
    Http.get("Trades" <> URI.encode_query(params))
  end

  @doc """
  Get recent spread data

  Params:
  - pair = asset pair to get spread data for
  - since = return spread data since given id (optional.  inclusive)
  """
  def recent_spread_data(params \\ %{}) do
    Http.get("Spread" <> URI.encode_query(params))
  end
end
