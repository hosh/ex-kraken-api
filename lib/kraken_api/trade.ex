defmodule KrakenApi.Trade do
  @moduledoc """
  Private User Trading Kraken API calls
  """

  alias KrakenApi.Http, as: Http

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
    Http.signed_post("AddOrder", params)
  end

  @doc """
  Cancel open order

  Params:
  - txid = transaction id
  """
  def cancel_open_order(params \\ %{}) do
    Http.signed_post("CancelOrder", params)
  end
end
