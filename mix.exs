defmodule Apigateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :apigateway,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Apigateway.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.13"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:distillery, "~> 2.1"},
      {:cors_plug, "~> 2.0"},
      {:bamboo, "~> 1.3"},
      {:bamboo_ses, "~> 0.1"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_sns, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:poison, "~> 3.0"},
      {:sweet_xml, "~> 0.6"},
      {:configparser_ex, "~> 4.0"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
