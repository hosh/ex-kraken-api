defmodule KrakenApi.Account do
  @moduledoc """
  Private User Account Kraken API calls
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
end
