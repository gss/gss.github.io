{expect} = chai
ViewModel = require 'signup-form-view-model'


describe 'View model', ->

  viewModel = null


  beforeEach ->
    viewModel = new ViewModel
      betaId: Math.floor Math.random()


  describe 'email address', ->

    context 'when valid', ->

      it 'validity should be true', (done) ->
        viewModel.emailAddressIsValid.onNext false
        viewModel.emailAddress.onNext 'email@address.com'

        viewModel.emailAddressIsValid.subscribe (isValid) ->
          try
            expect(isValid).to.be.true
            done()
          catch e
            done e


    context 'when invalid', ->

      it 'validity should be false', (done) ->
        viewModel.emailAddressIsValid.onNext true
        viewModel.emailAddress.onNext 'emailaddress.com'

        viewModel.emailAddressIsValid.subscribe (isValid) ->
          try
            expect(isValid).to.be.false
            done()
          catch e
            done e


  describe 'genericError', ->

    context 'when success is true', ->

      it 'should be false', (done) ->
        viewModel.genericError.onNext true
        viewModel.success.onNext true

        viewModel.genericError.subscribe (genericError) ->
          try
            expect(genericError).to.be.false
            done()
          catch e
            done e


  describe 'invalidEmailError', ->

    context 'when success is true', ->

      it 'should be false', (done) ->
        viewModel.invalidEmailError.onNext true
        viewModel.success.onNext true

        viewModel.invalidEmailError.subscribe (invalidEmailError) ->
          try
            expect(invalidEmailError).to.be.false
            done()
          catch e
            done e


  describe 'success', ->

    context 'when genericError is true', ->

      it 'should be false', (done) ->
        viewModel.success.onNext true
        viewModel.genericError.onNext true

        viewModel.success.subscribe (success) ->
          try
            expect(success).to.be.false
            done()
          catch e
            done e


    context 'when invalidEmailError is true', ->

      it 'should be false', (done) ->
        viewModel.success.onNext true
        viewModel.invalidEmailError.onNext true

        viewModel.success.subscribe (success) ->
          try
            expect(success).to.be.false
            done()
          catch e
            done e


  describe 'submit command', ->

    context 'when executed', ->

      it 'should make an ajax request', ->
        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()
        expect(stub.calledOnce).to.be.true


      it 'should make a POST request', ->
        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()
        expect(stub.firstCall.args[0].type).to.equal 'POST'


      it.skip 'should make a request to the "testers" resource url', ->
        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()

        HOST = 'https://the-grid-prefinery.herokuapp.com'
        url = "#{HOST}/api/v2/betas/#{viewModel.betaId}/testers"
        expect(stub.firstCall.args[0].url).to.equal url


      it 'should send an email address as payload', ->
        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()

        data = JSON.stringify
          tester:
            email: viewModel.emailAddress.value

        expect(stub.firstCall.args[0].data).to.equal data


      it 'should send the content type as JSON with character set as UTF-8', ->
        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()

        contentType = 'application/json; charset=utf-8'
        expect(stub.firstCall.args[0].contentType).to.equal contentType


      it 'should expect the response to be JSON', ->
        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()
        expect(stub.firstCall.args[0].dataType).to.equal 'json'


      it 'should cancel a previous request', ->
        stub = sinon.stub $, 'ajax', (options) ->
          fakeJqXHR = new $.Deferred()
          fakeJqXHR.abort = ->
          return fakeJqXHR

        viewModel.executeSubmitCommand()
        spy = sinon.spy stub.firstCall.returnValue, 'abort'

        viewModel.executeSubmitCommand()

        stub.restore()
        spy.restore()

        expect(spy.calledOnce).to.be.true


      it 'should set success to false', (done) ->
        viewModel.success.onNext true

        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()

        viewModel.success.subscribe (success) ->
          try
            expect(success).to.be.false
            done()
          catch e
            done e


      it 'should set genericError to false', (done) ->
        viewModel.genericError.onNext true

        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()

        viewModel.genericError.subscribe (genericError) ->
          try
            expect(genericError).to.be.false
            done()
          catch e
            done e


      it 'should set invalidEmailError to false', (done) ->
        viewModel.invalidEmailError.onNext true

        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()

        viewModel.invalidEmailError.subscribe (invalidEmailError) ->
          try
            expect(invalidEmailError).to.be.false
            done()
          catch e
            done e


    context 'when receiving a success response', ->

      it 'should set success to true', (done) ->
        viewModel.success.onNext false

        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()

        stub.firstCall.returnValue.resolve
          status: 200

        viewModel.success.subscribe (success) ->
          try
            expect(success).to.be.true
            done()
          catch e
            done e


    context 'when receiving a generic error response', ->

      it 'should set genericError to true', (done) ->
        viewModel.genericError.onNext false

        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()

        stub.firstCall.returnValue.reject
          status: 500

        viewModel.genericError.subscribe (genericError) ->
          try
            expect(genericError).to.be.true
            done()
          catch e
            done e


    context 'when receiving an "invalid email" error response', ->

      it 'should set invalidEmailError to true', (done) ->
        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()

        stub.firstCall.returnValue.reject
          status: 422
          responseJSON:
            errors: [
              {
                code: 2301
                message: 'is not a valid email address'
              }
            ]

        viewModel.invalidEmailError.subscribe (invalidEmailError) ->
          try
            expect(invalidEmailError).to.be.true
            done()
          catch e
            done e


    context 'when receiving a "tester exists" error response', ->

      it 'should set success to true', (done) ->
        viewModel.success.onNext false

        stub = sinon.stub $, 'ajax', (options) ->
          return new $.Deferred()

        viewModel.executeSubmitCommand()
        stub.restore()

        stub.firstCall.returnValue.reject
          status: 422
          responseJSON:
            errors: [
              {
                code: 2310
                message: 'Tester exists. Please use the update method.'
              }
            ]

        viewModel.success.subscribe (success) ->
          try
            expect(success).to.be.true
            done()
          catch e
            done e
