defmodule KV.Math do

  def pow( num, power ) do
    do_pow num, power, 1
  end

  defp do_pow( _num, 0, acc ) do
    acc
  end

  defp do_pow( num, power, acc ) when power > 0 do
    do_pow( num, power - 1, acc * num)
  end

end
