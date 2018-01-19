defmodule KrakenApi do
  @moduledoc """
  Documentation of all the API calls and the corresponding parameters.
  """

  @doc """
  Get account balance

  (This API call accepts no parameters)

  ## Example
      iex(1)> KrakenApi.get_account_balance()
      {:ok,
      %{"BCH" => "...", "XETH" => "...", "XLTC" => "...",
       "XXBT" => "...", "XZEC" => "...", "ZEUR" => "..."}}
  """
  def get_account_balance(params \\ %{}) do
    invoke_private_api("Balance", params)
  end

  @doc """
  Get trade balance

  Params:
  - aclass = asset class (optional):
      - currency (default)
  - asset = base asset used to determine balance (default = ZUSD)
  """
  def get_trade_balance(params \\ %{}) do
    invoke_private_api("TradeBalance", params)
  end

  @doc """
  Get open orders

  Params:
  - trades = whether or not to include trades in output (optional.  default = false)
  - userref = restrict results to given user reference id (optional)
  """
  def get_open_orders(params \\ %{}) do
    invoke_private_api("OpenOrders", params)
  end

  @doc """
  Get closed orders

  Params:
  - trades = whether or not to include trades in output (optional.  default = false)
  - userref = restrict results to given user reference id (optional)
  - start = starting unix timestamp or order tx id of results (optional.  exclusive)
  - end = ending unix timestamp or order tx id of results (optional.  inclusive)
  - ofs = result offset
  - closetime = which time to use (optional)
    - open
    - close
    - both (default)

  ## Example
      iex(8)> KrakenApi.get_closed_orders(%{start: 1507204548})
      {:ok,
      %{"closed" => ...},
        ...}
  """
  def get_closed_orders(params \\ %{}) do
    invoke_private_api("ClosedOrders", params)
  end

  @doc """
  Query orders info

  Params:
  - trades = whether or not to include trades in output (optional.  default = false)
  - userref = restrict results to given user reference id (optional)
  - txid = comma delimited list of transaction ids to query info about (20 maximum)

  """
  def query_orders_info(params \\ %{}) do
    invoke_private_api("QueryOrders", params)
  end

  @doc """
  Get trades history

  Params:
  - type = type of trade (optional)
    - all = all types (default)
    - any position = any position (open or closed)
    - closed position = positions that have been closed
    - closing position = any trade closing all or part of a position
    - no position = non-positional trades
  - trades = whether or not to include trades related to position in output (optional.  default = false)
  - start = starting unix timestamp or trade tx id of results (optional.  exclusive)
  - end = ending unix timestamp or trade tx id of results (optional.  inclusive)
  - ofs = result offset
  """
  def get_trades_history(params \\ %{}) do
    invoke_private_api("TradesHistory", params)
  end

  @doc """
  Query trades info

  Params:
  - txid = comma delimited list of transaction ids to query info about (20 maximum)
  - trades = whether or not to include trades related to position in output (optional.  default = false)
  """
  def query_trades_info(params \\ %{}) do
    invoke_private_api("QueryTrades", params)
  end

  @doc """
  Get open positions

  Params:
  - txid = comma delimited list of transaction ids to restrict output to
  - docalcs = whether or not to include profit/loss calculations (optional.  default = false)
  """
  def get_open_positions(params \\ %{}) do
    invoke_private_api("OpenPositions", params)
  end

  @doc """
  Get ledgers info

  Params:
  - aclass = asset class (optional):
    - currency (default)
  - asset = comma delimited list of assets to restrict output to (optional.  default = all)
  - type = type of ledger to retrieve (optional):
    - all (default)
    - deposit
    - withdrawal
    - trade
    - margin
  - start = starting unix timestamp or ledger id of results (optional.  exclusive)
  - end = ending unix timestamp or ledger id of results (optional.  inclusive)
  - ofs = result offset

  ## Example
      ex(1)> KrakenApi.get_ledgers_info(%{type: "deposit"})
      {:ok,
      %{"count" => 125,
       "ledger" => %{"..." => %{"aclass" => "currency",
           "amount" => "...", "asset" => "XETH",
           "balance" => "...", "fee" => "...",
           "refid" => "...", "time" => ...,
           "type" => "deposit"},
            ...
           }}}

  """
  def get_ledgers_info(params \\ %{}) do
    invoke_private_api("Ledgers", params)
  end

  @doc """
  Query ledgers

  Params:
  - id = comma delimited list of ledger ids to query info about (20 maximum)
  """
  def query_ledgers(params \\ %{}) do
    invoke_private_api("QueryLedgers", params)
  end

  @doc """
  Get trade volume

  Params:
  - pair = comma delimited list of asset pairs to get fee info on (optional)
  - fee-info = whether or not to include fee info in results (optional)
  """
  def get_trade_volume(params \\ %{}) do
    invoke_private_api("TradeVolume", params)
  end

  ## Private user trading
  @doc """
  Add standard order

  Params:
  - pair = asset pair
  - type = type of order (buy/sell)
  - ordertype = order type:
    - market
    - limit (price = limit price)
    - stop-loss (price = stop loss price)
    - take-profit (price = take profit price)
    - stop-loss-profit (price = stop loss price, price2 = take profit price)
    - stop-loss-profit-limit (price = stop loss price, price2 = take profit price)
    - stop-loss-limit (price = stop loss trigger price, price2 = triggered limit price)
    - take-profit-limit (price = take profit trigger price, price2 = triggered limit price)
    - trailing-stop (price = trailing stop offset)
    - trailing-stop-limit (price = trailing stop offset, price2 = triggered limit offset)
    - stop-loss-and-limit (price = stop loss price, price2 = limit price)
    - settle-position
  - price = price (optional.  dependent upon ordertype)
  - price2 = secondary price (optional.  dependent upon ordertype)
  - volume = order volume in lots
  - leverage = amount of leverage desired (optional.  default = none)
  - oflags = comma delimited list of order flags (optional):
    - viqc = volume in quote currency (not available for leveraged orders)
    - fcib = prefer fee in base currency
    - fciq = prefer fee in quote currency
    - nompp = no market price protection
    - post = post only order (available when ordertype = limit)
  - starttm = scheduled start time (optional):
    - 0 = now (default)
    - +<n> = schedule start time <n> seconds from now
    - <n> = unix timestamp of start time
  - expiretm = expiration time (optional):
    - 0 = no expiration (default)
    - +<n> = expire <n> seconds from now
    - <n> = unix timestamp of expiration time
  - userref = user reference id.  32-bit signed number.  (optional)
  - validate = validate inputs only.  do not submit order (optional)

  optional closing order to add to system when order gets filled:
    - close[ordertype] = order type
    - close[price] = price
    - close[price2] = secondary price
  """
  def add_standard_order(params \\ %{}) do
    invoke_private_api("AddOrder", params)
  end

  @doc """
  Cancel open order

  Params:
  - txid = transaction id
  """
  def cancel_open_order(params \\ %{}) do
    invoke_private_api("CancelOrder", params)
  end

  # Function to sign the private request.
  defp sign(path, post_data, private_key, nonce) do
    post_data = URI.encode_query(post_data)
    decoded_key = Base.decode64!(private_key)
    hash_result = :crypto.hash(:sha256, nonce <> post_data)
    :crypto.hmac(:sha512, decoded_key, path <> hash_result) |> Base.encode64
  end


  defp invoke_private_api(method, params, nonce \\ DateTime.utc_now() |> DateTime.to_unix(:millisecond) |> to_string) do
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
