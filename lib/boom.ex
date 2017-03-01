defmodule Boom do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Task, [fn -> blinker() end], id: Boom.Blinker),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Boom.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def blinker() do
    Leds.set green: true
    :timer.sleep 200
    Leds.set green: false
    :timer.sleep 200
    blinker()
  end

end
