defmodule Jido.Tools.Weather do
  use Jido.Action,
    name: "weather",
    description: "Get the weather for a given location via the OpenWeatherMap API",
    category: "Weather",
    tags: ["weather"],
    vsn: "1.0.0",
    schema: [
      location: [type: :string, doc: "The location to get the weather for"],
      units: [type: :string, doc: "Units to use (metric/imperial)", default: "metric"],
      hours: [type: :integer, doc: "Number of hours to forecast", default: 24],
      format: [
        type: :string,
        doc: "Output format (text/map)",
        default: "text"
      ],
      test: [
        type: :boolean,
        doc: "Whether to use test data instead of real API",
        default: true
      ]
    ]

  @doc """
  Demo function to test both test and real API cases.
  Usage in IEx:
    iex> Jido.Tools.Weather.demo()
  """
  def demo do
    IO.puts("\n=== Testing with fake data (text format) ===")

    case run(%{location: "any", test: true, format: "text"}, %{}) do
      {:ok, result} when is_binary(result) -> IO.puts(result)
      {:ok, result} -> IO.inspect(result, label: "Weather Data")
      {:error, error} -> IO.puts("Error: #{error}")
    end

    IO.puts("\n=== Testing with fake data (map format) ===")

    case run(%{location: "any", test: true, format: "map"}, %{}) do
      {:ok, result} when is_binary(result) -> IO.puts(result)
      {:ok, result} -> IO.inspect(result, label: "Weather Data")
      {:error, error} -> IO.puts("Error: #{error}")
    end

    IO.puts("\n=== Testing with real API ===")

    case run(%{location: "60618,US", format: "text"}, %{}) do
      {:ok, result} when is_binary(result) -> IO.puts(result)
      {:ok, result} -> IO.inspect(result, label: "Weather Data")
      {:error, error} -> IO.puts("Error: #{error}")
    end
  end

  def run(params, _context) do
    with {:ok, opts} <- build_opts(params),
         {:ok, response} <- Weather.API.fetch_weather(opts) do
      {:ok, format_response(response.body, params)}
    else
      {:error, error} -> {:error, "Failed to fetch weather: #{inspect(error)}"}
    end
  end

  defp build_opts(%{test: true}) do
    {:ok, Weather.Opts.new!(test: "rain")}
  end

  defp build_opts(params) do
    with {:ok, api_key} <- System.fetch_env!("OPENWEATHER_API_KEY") do
      {:ok,
       Weather.Opts.new!(
         api_key: api_key,
         zip: params.location,
         units: params.units,
         hours: params.hours,
         twelve: false
       )}
    else
      :error -> {:error, "Missing OPENWEATHER_API_KEY environment variable"}
    end
  end

  defp format_response(response, %{format: "map"}) do
    current = response["current"]
    daily = List.first(response["daily"])
    unit = if current["temp"] > 32, do: "F", else: "C"

    %{
      current: %{
        temperature: current["temp"],
        feels_like: current["feels_like"],
        humidity: current["humidity"],
        wind_speed: current["wind_speed"],
        conditions: List.first(current["weather"])["description"],
        unit: unit
      },
      forecast: %{
        high: daily["temp"]["max"],
        low: daily["temp"]["min"],
        summary: daily["summary"],
        unit: unit
      }
    }
  end

  defp format_response(response, _params) do
    current = response["current"]
    daily = List.first(response["daily"])

    """
    Current Weather:
    Temperature: #{current["temp"]}°#{if current["temp"] > 32, do: "F", else: "C"}
    Feels like: #{current["feels_like"]}°#{if current["feels_like"] > 32, do: "F", else: "C"}
    Humidity: #{current["humidity"]}%
    Wind: #{current["wind_speed"]} mph
    Conditions: #{List.first(current["weather"])["description"]}

    Today's Forecast:
    High: #{daily["temp"]["max"]}°#{if daily["temp"]["max"] > 32, do: "F", else: "C"}
    Low: #{daily["temp"]["min"]}°#{if daily["temp"]["min"] > 32, do: "F", else: "C"}
    Conditions: #{daily["summary"]}
    """
    |> String.trim()
  end
end
