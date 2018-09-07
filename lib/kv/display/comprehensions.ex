defmodule Kv.Display.Comprehension do
  @moduledoc """
         [a,b,c,d,e,f,g,h]
  null = [0,0,0,0,0,0,0,0]
  zero = [1,1,1,1,1,1,0,0]
  one = [0,1,1,0,0,0,0,0]
  two = [1,1,0,0,1,0,1,0]
  three = [1,1,1,1,0,0,1,0]
  four = [0,1,1,0,0,1,1,0]
         [a,b,c,d,e,f,g,h]
  five = [1,0,1,1,0,1,1,0]
  six = [1,0,1,1,1,1,1,0]
  seven = [1,1,1,0,0,0,0,0]
  eight = [1,1,1,1,1,1,1,0]
  nine = [1,1,1,1,0,1,1,0]
         [a,b,c,d,e,f,g,h]
  String.to_integer("FC", 16)|>Integer.digits(2)
  """
  require Logger

  # 0~9
  @digits_code %{
    zero: 0xFC,
    one: 0x60,
    two: 0xCA,
    tree: 0xF2,
    four: 0x64,
    five: 0xB6,
    six: 0xBE,
    seven: 0xE0,
    eight: 0xFE,
    nine: 0xF6
  }
  @pins_code [:a, :b, :c, :d, :e, :f, :g, :h]
  @doc """
    alias Kv.Display.Comprehension
    Kv.Display.Comprehension.set_pins(0,1,2,3,4,5,6,7)
  """
  def set_pins(pin_a, pin_b, pin_c, pin_d, pin_e, pin_f, pin_g, pin_h) do
    input_pins = [pin_a, pin_b, pin_c, pin_d, pin_e, pin_f, pin_g, pin_h]
    digit_pids = %{}

    digit_pids =
      for n <- 0..7 do
        # input_pin = input_pins|>Enum.at(n)
        # {:ok, digit_pid} = GPIO.start_link(input_pin, :output)
        # digit_pids|>Map.put(pin_code, digit_pid)
        input_pin = input_pins |> Enum.at(n)
        pin_code = @pins_code |> Enum.at(n)
        # Logger.info("pin_code#{inspect(pin_code)}==>input_pin#{inspect(input_pin)}")
        digit_pids |> Map.put(pin_code, input_pin)
      end

    Logger.info("digit_pids:#{inspect(digit_pids)}")
    digit_pids
  end

  @doc """
    alias Kv.Display.Comprehension
    digit_pids = Comprehension.set_pins(0,1,2,3,4,5,6,7)
    Comprehension.clear_all(digit_pids,Comprehension.@digits_code.eight)
  """
  def clear(digit_pids) do
    Enum.each(digit_pids, fn digit_pid ->
      # GPIO.write(digit_pid, 0)
      Logger.info("digit_pid#{inspect(digit_pid)}")
    end)
  end

  @doc """
    alias Kv.Display.Comprehension
    digit_pids = Comprehension.set_pins(0,1,2,3,4,5,6,7)
    Comprehension.clear(digit_pids,0xFE)
  """
  def clear(digit_pids, digit) do
    digit_bits = Integer.digits(digit, 2)
    pids_list = Map.to_list(digit_pids)
    Logger.info("digit#{inspect(@digits_code.eight)}")
    for n <- 0..7 do
      if 1 == digit_bits |> Enum.at(n) do
        pid = pids_list |> Enum.at(n)
        Logger.info("pid#{inspect(pid)}")
        # GPIO.write(pid, 0)
      end
    end
  end
end
