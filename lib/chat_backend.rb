class ChatBackend
  KEEPALIVE_TIME = 15 # in seconds

  def initialize(app)
    @app     = app
    @clients = []
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
      ws.on :open do |event|
        p [:open, ws.object_id]
        @clients << ws
      end

      ws.on :message do |event|
        p [:message, event.data]
        rawData = JSON.parse(event.data)
        Message.create!(content: rawData["content"], user_id: rawData["user"]["id"])
        # Message.create(event
        @clients.each {|client| client.send(event.data) }
      end

      ws.on :close do |event|
        p [:close, ws.object_id, event.code, event.reason]
        @clients.delete(ws)
        ws = nil
      end

      # Return async Rack response
      ws.rack_response
    else
      @app.call(env)
    end
  end
end
