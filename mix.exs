defmodule Boom.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi3"

  def project do
    [app: :boom,
     version: "0.1.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.2.1"],

     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",

     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),

     kernel_modules: kernel_modules(@target),

     deps: deps() ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Boom, []},
     extra_applications: [:logger, :nerves_leds]]
  end

  def deps do
    [{:nerves, "~> 0.4.0"},
     {:nerves_interim_wifi, "~> 0.1"},
     {:nerves_leds, "~> 0.8.0"}
    ]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

  def kernel_modules("rpi3"), do: ["brcmfmac"]
  def kernel_modules(_), do: []
end
