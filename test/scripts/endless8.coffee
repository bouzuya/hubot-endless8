{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'hello', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    # for warning: possible EventEmitter memory leak detected.
    # process.on 'uncaughtException'
    @sinon.stub process, 'on', -> null
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      setTimeout done, 10 # wait for parseHelp()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    describe 'valid patterns', ->
      beforeEach ->
        @tests = [
          message: '@hubot いま何回目だ？'
          matches: ['@hubot いま何回目だ？']
        ,
          message: '@hubot 何回目だ？'
          matches: ['@hubot 何回目だ？']
        ,
          message: '@hubot なんかいめだ'
          matches: ['@hubot なんかいめだ']
        ]

      it 'should match', ->
        @tests.forEach ({ message, matches }) =>
          callback = @sinon.spy()
          @robot.listeners[0].callback = callback
          sender = new User 'bouzuya', room: 'hitoridokusho'
          @robot.adapter.receive new TextMessage(sender, message)
          actualMatches = callback.firstCall.args[0].match.map((i) -> i)
          assert callback.callCount is 1
          assert.deepEqual actualMatches, matches

  describe 'listeners[0].callback', ->
    beforeEach ->
      @hello = @robot.listeners[0].callback

    describe 'receive "@hubot なんかいめだ"', ->
      beforeEach ->
        @send = @sinon.spy()
        @hello
          match: ['@hubot なんかいめだ']
          send: @send
          robot:
            brain:
              get: (-> null)
              set: (-> null)
              save: (-> null)

      it 'send "1回目"', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is '1回目'

  describe 'robot.helpCommands()', ->
    it '''
should be ["hubot 何回目だ？ - counts your messages like the endless 8"]
       ''', ->
      assert.deepEqual @robot.helpCommands(), [
        "hubot 何回目だ？ - counts your messages like the endless 8"
      ]
