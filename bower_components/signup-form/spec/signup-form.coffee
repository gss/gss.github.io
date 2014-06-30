{expect} = chai
SignupForm = require 'signup-form'


describe 'Signup form', ->

  afterEach ->
    $('#dynamic').empty()


  describe 'options', ->

    context 'when not specified', ->

      it 'should set a parent selector', ->
        signupForm = new SignupForm
          betaId: 1234

        expect(signupForm.parentSelector).to.exist


    context 'when specified', ->

      it 'should set the parent selector', ->
        parentSelector = '#dynamic'

        signupForm = new SignupForm
          betaId: 1234
          parentSelector: parentSelector

        expect(signupForm.parentSelector).to.equal parentSelector


  describe 'callbacks', ->

    context 'when success is true', ->

      it 'should be called', (done) ->
        signupForm = new SignupForm
          betaId: 1234
          onSuccess: (emailAddress) ->
            done()

        signupForm.viewModel.success.onNext true


      it 'should receive the email address', (done) ->
        signupForm = new SignupForm
          betaId: 1234
          onSuccess: (emailAddress) ->
            try
              expect(emailAddress).to.equal signupForm.viewModel.emailAddress.value
              done()
            catch e
              done e

        signupForm.viewModel.success.onNext true


    context 'when genericError is true', ->

      it 'should be called', (done) ->
        signupForm = new SignupForm
          betaId: 1234
          onError: (emailAddress) ->
            done()

        signupForm.viewModel.genericError.onNext true


    context 'when invalidEmailError is true', ->

      it 'should be called', (done) ->
        signupForm = new SignupForm
          betaId: 1234
          onError: (emailAddress) ->
            done()

        signupForm.viewModel.invalidEmailError.onNext true


  describe 'template', ->

    context 'by default', ->

      it 'should be rendered', ->
        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'

        expect(signupForm.template).to.exist


      it 'should be added to the DOM', ->
        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'

        $parent = $(signupForm.parentSelector)
        $form = $("##{signupForm.view.id}")
        parentContainsForm = $.contains $parent[0], $form[0]

        expect(parentContainsForm).to.be.true


    context 'otherwise', ->

      it 'should not be rendered', ->
        signupForm = new SignupForm
          betaId: 1234
          id: 'static-signup-form'
          parentSelector: '#static'
          useTemplate: false

        expect(signupForm.template).to.not.exist


      it 'should not be added to the DOM', ->
        parentSelector = '#static'

        getHtml = -> $(parentSelector).html()
        html = getHtml()

        signupForm = new SignupForm
          betaId: 1234
          id: 'static-signup-form'
          parentSelector: parentSelector
          useTemplate: false

        expect(html).to.equal getHtml()


  describe 'element getters', ->

    context 'form', ->
      it 'should exist', ->
        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'

        expect(signupForm.view.$form()[0]).to.exist


    context 'input field', ->
      it 'should exist', ->
        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'

        expect(signupForm.view.$inputField()[0]).to.exist


    context 'submit button', ->
      it 'should exist', ->
        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'

        expect(signupForm.view.$submitButton()[0]).to.exist


    context 'error message', ->
      it 'should exist', ->
        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'

        expect(signupForm.view.$errorMessage()[0]).to.exist


    context 'success message', ->
      it 'should exist', ->
        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'

        expect(signupForm.view.$successMessage()[0]).to.exist


  describe 'view model', ->

    context 'options', ->

      it 'should set the beta ID', ->
        betaId = 1234

        signupForm = new SignupForm
          betaId: betaId
          parentSelector: '#dynamic'

        viewModel = signupForm.viewModel
        expect(viewModel.betaId).to.equal betaId


  describe 'view', ->

    context 'options', ->

      it 'should set the ID', ->
        id = 'test-id'

        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'
          id: id

        view = signupForm.view
        expect(view.id).to.equal id


      it 'should set the button text', ->
        buttonText = 'test button text'

        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'
          buttonText: buttonText

        view = signupForm.view
        expect(view.buttonText).to.equal buttonText


      it 'should set the placeholder text', ->
        placeholderText = 'test placeholder text'

        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'
          placeholderText: placeholderText

        view = signupForm.view
        expect(view.placeholderText).to.equal placeholderText


      it 'should set the generic error message', ->
        errorMessage = 'test generic error message'

        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'
          errorMessages:
            generic: errorMessage

        view = signupForm.view
        expect(view.errorMessages.generic).to.equal errorMessage


      it 'should set the invalid email address error message', ->
        errorMessage = 'test error message'

        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'
          errorMessages:
            invalidEmail: errorMessage

        view = signupForm.view
        expect(view.errorMessages.invalidEmail).to.equal errorMessage


      it 'should set the success message', ->
        successMessage = 'test success message'

        signupForm = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'
          successMessage: successMessage

        view = signupForm.view
        expect(view.successMessage).to.equal successMessage


    describe 'submit button', ->

      context 'when email address is valid', ->

        it 'should be enabled', ->
          signupForm = new SignupForm
            betaId: 1234
            parentSelector: '#dynamic'

          $submitButton = signupForm.view.$submitButton()

          $submitButton.prop 'disabled', true
          signupForm.viewModel.emailAddressIsValid.onNext true

          expect($submitButton.is(':disabled')).to.be.false


      context 'when email address is invalid', ->

        it 'should be disabled', ->
          signupForm = new SignupForm
            betaId: 1234
            parentSelector: '#dynamic'

          $submitButton = signupForm.view.$submitButton()

          $submitButton.prop 'disabled', false
          signupForm.viewModel.emailAddressIsValid.onNext false

          expect($submitButton.is(':disabled')).to.be.true


    describe 'success message', ->

      context 'when success is true', ->
        it 'should be visible', ->
          signupForm = new SignupForm
            betaId: 1234
            parentSelector: '#dynamic'

          $successMessage = signupForm.view.$successMessage()

          $successMessage.addClass 'hidden'
          signupForm.viewModel.success.onNext true

          expect($successMessage.hasClass('hidden')).to.be.false


      context 'when success is false', ->
        it 'should not be visible', ->
          signupForm = new SignupForm
            betaId: 1234
            parentSelector: '#dynamic'

          $successMessage = signupForm.view.$successMessage()

          $successMessage.removeClass 'hidden'
          signupForm.viewModel.success.onNext false

          expect($successMessage.hasClass('hidden')).to.be.true


    describe 'error message', ->

      it 'should initially contain the longest error message to workaround GSS and volatile DOM', ->
        longErrorMessage = 'test long error message'

        signupForm1 = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'
          errorMessages:
            generic: longErrorMessage
            invalidEmail: 'test'

        expect(signupForm1.view.$errorMessage().text()).to.equal longErrorMessage


        signupForm2 = new SignupForm
          betaId: 1234
          parentSelector: '#dynamic'
          errorMessages:
            generic: 'test'
            invalidEmail: longErrorMessage

        expect(signupForm2.view.$errorMessage().text()).to.equal longErrorMessage


      context 'when genericError is true', ->

        it 'should be visible', ->
          signupForm = new SignupForm
            betaId: 1234
            parentSelector: '#dynamic'

          $errorMessage = signupForm.view.$errorMessage()

          $errorMessage.addClass 'hidden'
          signupForm.viewModel.genericError.onNext true

          expect($errorMessage.hasClass('hidden')).to.be.false


        it 'should contain the generic error message', ->
          signupForm = new SignupForm
            betaId: 1234
            parentSelector: '#dynamic'

          signupForm.view.$errorMessage().text signupForm.view.errorMessages.invalidEmailError
          signupForm.viewModel.genericError.onNext true

          expect(signupForm.view.$errorMessage().text()).to.equal signupForm.view.errorMessages.generic


      context 'when genericError is false', ->

        it 'should not be visible', ->
          signupForm = new SignupForm
            betaId: 1234
            parentSelector: '#dynamic'

          $errorMessage = signupForm.view.$errorMessage()

          $errorMessage.removeClass 'hidden'
          signupForm.viewModel.genericError.onNext false

          expect($errorMessage.hasClass('hidden')).to.be.true


      context 'when invalidEmailError is true', ->

        it 'should be visible', ->
          signupForm = new SignupForm
            betaId: 1234
            parentSelector: '#dynamic'

          $errorMessage = signupForm.view.$errorMessage()

          $errorMessage.addClass 'hidden'
          signupForm.viewModel.invalidEmailError.onNext true

          expect($errorMessage.hasClass('hidden')).to.be.false


        it 'should contain the invalid email address error message', ->
          signupForm = new SignupForm
            betaId: 1234
            parentSelector: '#dynamic'

          signupForm.view.$errorMessage().text signupForm.view.errorMessages.genericError
          signupForm.viewModel.invalidEmailError.onNext true

          expect(signupForm.view.$errorMessage().text()).to.equal signupForm.view.errorMessages.invalidEmail


      context 'when invalidEmailError is false', ->

        it 'should not be visible', ->
          signupForm = new SignupForm
            betaId: 1234
            parentSelector: '#dynamic'

          $errorMessage = signupForm.view.$errorMessage()

          $errorMessage.removeClass 'hidden'
          signupForm.viewModel.invalidEmailError.onNext false

          expect($errorMessage.hasClass('hidden')).to.be.true
