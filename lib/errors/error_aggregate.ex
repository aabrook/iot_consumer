defmodule ReportError do
  defstruct [:message, :room]
end

defmodule ResolveError do
  defstruct [:room]
end

defmodule ErrorReported do
  defstruct [:message, :room]
end

defmodule ErrorEscalated do
  defstruct [:room]
end

defmodule ErrorAlerted do
  defstruct [:room]
end

defmodule ErrorResolved do
  defstruct [:room]
end

defmodule Error do
  require Logger

  defstruct [:room, :message, :status, :frequency]

  def execute(error = %Error{status: status}, %ReportError{message: message, room: room})
    when status in [nil, :resolved]
  do
    %ErrorReported{
      room: room,
      message: message,
    }
  end
  def execute(%Error{status: status, frequency: frequency}, %ReportError{room: room})
    when status in [:reported, :escalated] and frequency < 5
  do
    %ErrorEscalated{
      room: room
    }
  end
  def execute(%Error{status: status, frequency: frequency}, %ReportError{room: room})
    when status in [:escalated, :alerted]
  do
    %ErrorAlerted{
      room: room
    }
  end
  def execute(error = %Error{status: status}, %ResolveError{room: room})
    when status in [nil, :resolved]
  do
    {:error, :already_resolved}
  end
  def execute(error = %Error{status: status}, %ResolveError{room: room}) do
    %ErrorResolved{room: room}
  end

  def apply(
    error = %Error{},
    %{
      "frequency" => frequency,
      "message" => message,
      "room" => room,
      "status" => status,
    })
  do
    %Error{error | room: room, message: message, status: status, frequency: frequency}
  end
  def apply(
    error = %Error{},
    %{
      "room" => room,
      "message" => message
    })
  do
    %Error{error | room: room, message: message, status: :resolved, frequency: 0}
  end
  def apply(error = %Error{}, %{"room" => room}) do
    Error.apply(error, %{"room" => room, "message" => ""})
  end

  def apply(error = %Error{}, %ErrorReported{room: room, message: message}) do
    %Error{error | room: room, message: message, frequency: 1, status: :reported}
  end
  def apply(error = %Error{frequency: frequency}, %ErrorEscalated{}) do
    %Error{error | frequency: frequency + 1, status: :escalated}
  end
  def apply(error = %Error{frequency: frequency, message: message}, %ErrorAlerted{room: room}) do
    Logger.error("#{room} has had #{frequency} consecutive problems", [message: message])
    %Error{error | frequency: frequency + 1, status: :alerted}
  end
  def apply(error = %Error{}, %ErrorResolved{}) do
    %Error{error | frequency: 0, status: :resolved}
  end
end
