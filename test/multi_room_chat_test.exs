defmodule MultiRoomChatTest do
  use ExUnit.Case
  doctest MultiRoomChat

  test "greets the world" do
    assert MultiRoomChat.hello() == :world
  end
end
