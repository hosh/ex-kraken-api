defmodule KrakenApi.Account do
  @moduledoc """
  Private User Account Kraken API calls
  """

  alias KrakenApi.Http, as: Http

  @doc """
  Get account balance

  (This API call accepts no parameters)

  ## Example
      iex(1)> KrakenApi.Account.balance()
      {:ok,
      %{"BCH" => "...", "XETH" => "...", "XLTC" => "...",
       "XXBT" => "...", "XZEC" => "...", "ZEUR" => "..."}}
  """
  def balance(params \\ %{}) do
    Http.signed_post("Balance", params)
  end

  @doc """
  Get trade balance

  Params:
  - aclass = asset class (optional):
      - currency (default)
  - asset = base asset used to determine balance (default = ZUSD)
  """
  def trade_balance(params \\ %{}) do
    Http.signed_post("TradeBalance", params)
  end

  @doc """
  Get open orders

  Params:
  - trades = whether or not to include trades in output (optional.  default = false)
  - userref = restrict results to given user reference id (optional)
  """
  def open_orders(params \\ %{}) do
    Http.signed_post("OpenOrders", params)
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
      iex(8)> KrakenApi.Account.closed_orders(%{start: 1507204548})
      {:ok,
      %{"closed" => ...},
        ...}
  """
  def closed_orders(params \\ %{}) do
    Http.signed_post("ClosedOrders", params)
  end

  @doc """
  Query orders info

  Params:
  - trades = whether or not to include trades in output (optional.  default = false)
  - userref = restrict results to given user reference id (optional)
  - txid = comma delimited list of transaction ids to query info about (20 maximum)

  """
  def query_orders_info(params \\ %{}) do
    Http.signed_post("QueryOrders", params)
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
  def trades_history(params \\ %{}) do
    Http.signed_post("TradesHistory", params)
  end

  @doc """
  Query trades info

  Params:
  - txid = comma delimited list of transaction ids to query info about (20 maximum)
  - trades = whether or not to include trades related to position in output (optional.  default = false)
  """
  def query_trades_info(params \\ %{}) do
    Http.signed_post("QueryTrades", params)
  end

  @doc """
  Get open positions

  Params:
  - txid = comma delimited list of transaction ids to restrict output to
  - docalcs = whether or not to include profit/loss calculations (optional.  default = false)
  """
  def open_positions(params \\ %{}) do
    Http.signed_post("OpenPositions", params)
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
      ex(1)> KrakenApi.Account.ledgers_info(%{type: "deposit"})
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
  def ledgers_info(params \\ %{}) do
    Http.signed_post("Ledgers", params)
  end

  @doc """
  Query ledgers

  Params:
  - id = comma delimited list of ledger ids to query info about (20 maximum)
  """
  def query_ledgers(params \\ %{}) do
    Http.signed_post("QueryLedgers", params)
  end

  @doc """
  Get trade volume

  Params:
  - pair = comma delimited list of asset pairs to get fee info on (optional)
  - fee-info = whether or not to include fee info in results (optional)
  """
  def trade_volume(params \\ %{}) do
    Http.signed_post("TradeVolume", params)
  end
end
