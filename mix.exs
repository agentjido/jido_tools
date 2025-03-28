defmodule Jido.Tools.MixProject do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :jido_tools,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A collection of tools for the Jido AI agent framework",
      package: package(),
      name: "jido_tools",
      source_url: "https://github.com/agentjido/jido_tools",
      homepage_url: "https://github.com/agentjido/jido_tools",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Mike Hostetler"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/agentjido/jido_tools"
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Jido
      {:jido, "~> 1.1.0-rc.2"},
      {:jido_ai, "~> 0.5.0"},

      # Action Deps
      {:req, "~> 0.5.10"},
      {:tentacat, "~> 2.5"},
      {:weather, "~> 0.4.0"},

      # Testing
      {:credo, "~> 1.7", only: [:dev, :test]},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:doctor, "~> 0.22.0", only: [:dev, :test]},
      {:ex_check, "~> 0.12", only: [:dev, :test]},
      {:ex_doc, "~> 0.37-rc", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18.3", only: [:dev, :test]},
      {:expublish, "~> 2.5", only: [:dev], runtime: false},
      {:git_ops, "~> 2.5", only: [:dev, :test]},
      {:igniter, "~> 0.5", only: [:dev, :test]},
      {:mimic, "~> 1.7", only: [:dev, :test]},
      {:mix_audit, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:sobelow, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:stream_data, "~> 1.1", only: [:dev, :test]}
    ]
  end
end
