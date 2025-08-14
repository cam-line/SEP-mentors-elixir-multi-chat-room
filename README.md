# MultiRoomChat

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `multi_room_chat` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:multi_room_chat, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/multi_room_chat>.

## TODO

### Plan to turn this project into an OTP app


1. **OTP Application Structure**

   - Create a top-level `MultiRoomChat.Application` module implementing the `Application` behaviour.
   - In `MultiRoomChat.Application.start/2`, define a supervision tree using `Supervisor`.
   - Identify all long-lived processes (e.g., chat room registry, directory, user manager) and convert them to OTP GenServers or Agents if not already.
   - Add each process to the supervision tree as a child specification.
   - Use appropriate supervision strategies (`:one_for_one`, `:rest_for_one`, etc.) based on process relationships.
   - Example:

     ```elixir
     def start(_type, _args) do
       children = [
         MultiRoomChat.Directory,
         MultiRoomChat.UserManager,
         # Add other GenServers/Agents here
       ]

       opts = [strategy: :one_for_one, name: MultiRoomChat.Supervisor]
       Supervisor.start_link(children, opts)
     end
     ```

   - Ensure all chat room processes are started and supervised dynamically (e.g., using `DynamicSupervisor` for chat rooms).
   - Refactor code so that processes are started by the supervisor, not manually.
   - Add tests to verify that the supervision tree starts and restarts child processes as expected.

1. **Configuration**

- Add configuration options in `config/config.exs` for customizing app behaviour (e.g., default rooms, logging).

1. **Documentation**

- Update README and module docs to reflect the new name and OTP structure.
- Add usage examples for starting the app and interacting with chat rooms.

1. **Testing**

- Refactor and expand tests to cover OTP supervision and failure scenarios.
- Add integration tests for starting/stopping the app and chat room interactions.

1. **Optional Features**

- Add support for distributed chat rooms (using `:global` or `:via` for process registration).
- Add persistence (ETS, Mnesia, or database) for chat history and user data.
- Provide a CLI or web interface for interacting with the app.

---
