defmodule KV.Hex do
  import Enum
  import KV.Math
  require Logger
  # lookup table for hex values
  @lookup_table ~w{ 0 1 2 3 4 5 6 7 8 9 A B C D E F }

  # given a value as a positive integer
  # return a list of string values containing the hex characters
  def from_dec(value) when value > 0 do
    # convert to list of integers (0-15)
    do_from_dec(value, [])
    # translate integers into 0-F values from @lookup_table
    |> map(&at(@lookup_table, &1))
  end

  # given a value as a positive integer
  # return a string of the hexadecimal representation of said value
  def from_dec_to_string(value) when value > 0 do
    from_dec(value)
    |> join
  end

  defp do_from_dec(0, list) do
    list
  end

  defp do_from_dec(value, list) when value > 0 do
    do_from_dec(div(value, 16), [rem(value, 16) | list])
  end

  # Given a list of hex value strings
  # return a the integer representation of it
  def from_hex(value) when is_list(value) do
    do_from_hex_list(reverse(value), 0, 0)
  end

  # Given a string representation of a hex value,
  # return the integer representation of it
  def from_hex(value) when is_bitstring(value) do
    hex_list =
      String.split(value, ~r{})
      |> filter(fn x -> x != "" end)

    Logger.info("hex_list #{inspect(hex_list)}")
    from_hex(hex_list)
  end

  # convert a single hex value (a nibble) as a string into an integer
  # case-insensitive
  # eg: a -> 10
  def hex_val_to_int(hexval) do
    String.capitalize(hexval)
    |> do_hex_val_to_int(@lookup_table, 0)
  end

  defp do_hex_val_to_int(hexval, [v | tail], acc) when hexval == v do
    acc
  end

  defp do_hex_val_to_int(hexval, [v | tail], acc) do
    do_hex_val_to_int(hexval, tail, acc + 1)
  end

  defp do_from_hex_list([], _power, acc) do
    acc
  end

  defp do_from_hex_list([v | tail], power, acc) do
    val = hex_val_to_int(v)
    do_from_hex_list(tail, power + 1, acc + val * pow(16, power))
  end
end
