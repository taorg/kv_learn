defmodule KV.Binary.Util do
  require Logger

  def each(binarray, func) when is_binary(binarray),
    do: Logger.debug("[x,y,z]#{inspect(_each(binarray, func, []))}")

  defp _each(<<head::size(16), tail::binary>>, func, result) do
    rhead =
      head
      |> :binary.encode_unsigned()
      |> :binary.bin_to_list()
      |> Enum.reverse()
      |> :binary.list_to_bin()
      |> :binary.decode_unsigned()

    <<shead::integer-signed-16>> = <<rhead::size(16)>>
    func.(shead)
    <<f::float-32>> = <<0, 0, shead::size(16)>>
    func.(f)
    _each(tail, func, [shead | result])
  end

  defp _each(<<>>, _func, result), do: result

  def length(bytes) do
    rhead =
      bytes
      |> :binary.encode_unsigned()
      |> :binary.bin_to_list()
      |> Enum.reverse()
      |> :binary.list_to_bin()
      |> :binary.decode_unsigned()

    <<shead::integer-signed-32>> = <<rhead::size(32)>>
    shead
  end

  def init(%{bus: bus} = state) do
    Logger.debug("bus:#{inspect(bus)}")
    print_frec(state)
  end

  def print_frec(%{pwm_freq: hz} = state) do
    Logger.debug("state:#{inspect(state)}")
    Logger.debug("pwm_freq:#{inspect(hz)}")
  end
end

# KV.Binary.Util.each(<<20, 0, 239, 254, 239, 255>>, fn char -> IO.inspect char end)
# key = ''.join(chr(x) for x in [0x14, 0x00, 0xEF, 0xFE, 0xEF, 0xFF])
# >>> struct.unpack('<hhh', key)
# (20, -273, -17)

# KV.Binary.Util.each(<<23, 0, 177, 255, 211, 0>>, fn char -> IO.inspect char end)
# KV.Binary.Util.each(<<22, 0, 93, 255, 105, 0>>, fn char -> IO.inspect char end)
# KV.Binary.Util.each(<<21, 0, 237, 254, 242, 255>>, fn char -> IO.inspect char end)
# >>> key = ''.join(chr(x) for x in [0x15, 0x00, 0xB5, 0xFF, 0xD3, 0x00])
# >>> struct.unpack('<hhh', key)
# (21, -75, 211)
# KV.Binary.Util.each(<<43, 0, 226, 255, 216, 0>>, fn char -> IO.inspect char end)
# KV.Binary.Util.length(<<6, 0, 0, 0>>)
KV.Binary.Util.init(%{bus: 1, pwm_freq: 50})
