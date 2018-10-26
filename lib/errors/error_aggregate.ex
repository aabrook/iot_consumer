defmodule ReportError do
  defstruct [:message, :source]
end

defmodule ResolveError do
  defstruct [:source]
end

defmodule ErrorReported do
  defstruct [:message, :source]
end

defmodule ErrorEscalated do
  defstruct [:message, :source]
end

defmodule ErrorAlerted do
  defstruct [:message, :source]
end

defmodule ErrorResolved do
  defstruct [:source]
end

defmodule Error do
  require Logger

  defstruct [:source, :message, :status, :frequency]

  def execute(error = %Error{status: status}, %ReportError{message: message, source: source})
      when status in [nil, :resolved] do
    %ErrorReported{
      source: source,
      message: message
    }
  end

  def execute(%Error{status: status, frequency: frequency}, %ReportError{message: message, source: source})
      when status in [:reported, :escalated] and frequency < 3 do
    %ErrorEscalated{
      source: source,
      message: message
    }
  end

  def execute(%Error{status: status, frequency: frequency}, %ReportError{source: source, message: message})
      when status in [:escalated, :alerted] do
    %ErrorAlerted{
      source: source,
      message: message
    }
  end

  def execute(error = %Error{status: status}, %ResolveError{source: source}) do
    %ErrorResolved{source: source}
  end

  def apply(error = %Error{}, %{
        "frequency" => frequency,
        "message" => message,
        "source" => source,
        "status" => status
      }) do
    %Error{error | source: source, message: message, status: status, frequency: frequency}
  end

  def apply(error = %Error{}, %{
        "source" => source,
        "message" => message
      }) do
    %Error{error | source: source, message: message, status: :resolved, frequency: 0}
  end

  def apply(error = %Error{}, %{"source" => source}) do
    Error.apply(error, %{"source" => source, "message" => ""})
  end

  def apply(error = %Error{}, %ErrorReported{source: source, message: message}) do
    %Error{error | source: source, message: message, frequency: 1, status: :reported}
  end

  def apply(error = %Error{frequency: frequency}, %ErrorEscalated{}) do
    %Error{error | frequency: frequency + 1, status: :escalated}
  end

  def apply(error = %Error{frequency: frequency, message: message}, %ErrorAlerted{source: source}) do
    Logger.error("#{source} has had #{frequency} consecutive problems", message: message)
    %Error{error | frequency: frequency + 1, status: :alerted}
  end

  def apply(error = %Error{}, %ErrorResolved{}) do
    %Error{error | frequency: 0, status: :resolved}
  end
end
