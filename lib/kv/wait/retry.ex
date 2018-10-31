defmodule Kv.Wait.Retry do
  use Retry
  require Logger
  import Stream

  @moduledoc """
  Test https://github.com/safwank/ElixirRetry
  """
  @doc """
    alias Kv.Wait.Retry
    Retry.retrying_constant()
    Retry.retrying_linear()
    Retry.retrying_exponential()
    Retry.retrying_cycle()
    Retry.waiting()
  """
  def retrying_constant() do
    result =
      retry with: constant_backoff(100) |> take(10) do
        # fails if other system is down
        external_proc()
        #
      after
        result -> result
      else
        error -> error
      end

    Logger.info(result)
  end

  @doc """
    alias Kv.Wait.Retry
    Retry.retrying_linear()
  """
  def retrying_linear() do
    result =
      retry with: linear_backoff(10, 2) |> cap(1_000) |> Stream.take(10) do
        external_proc()
      after
        result -> result
      else
        error -> error
      end

    Logger.info(result)
  end

  @doc """
    alias Kv.Wait.Retry
    Retry.retrying_exponential()
  """
  def retrying_exponential() do
    result =
      retry with: exponential_backoff() |> randomize |> expiry(10_000),
            rescue_only: [TimeoutError] do
        external_proc()
      after
        result -> result
      else
        error -> error
      end

    Logger.info(result)
  end

  @doc """
    alias Kv.Wait.Retry
    Retry.retrying_cycle()
  """
  def retrying_cycle() do
    result =
      retry with: Stream.cycle([500]) do
        external_proc()
      after
        result -> result
      else
        error -> error
      end

    Logger.info(result)
  end

  @doc """
    alias Kv.Wait.Retry
    Retry.waiting()
  """
  def waiting() do
    result =
      wait constant_backoff(100) |> expiry(1_000) do
        we_there_yet?()
      after
        _ ->
          {:ok, "We have arrived!"}
      else
        _ ->
          {:error, "We're still on our way :("}
      end

    Logger.info("result:#{inspect(result)}")
  end

  #######################################################
  # PRIVATE ## PRIVATE ## PRIVATE ## PRIVATE ## PRIVATE #
  #######################################################
  defp external_proc() do
    x = Enum.random(0..4)

    result =
      case x do
        0 -> :ok
        x when x > 0 -> :error
      end

    Logger.info("do_something:#{result}")
    result
  end
  defp we_there_yet?() do
    x = Enum.random(0..4)

    result =
      case x do
        0 -> true
        x when x > 0 -> false
      end

    Logger.info("do_something:#{result}")
    result
  end
end
