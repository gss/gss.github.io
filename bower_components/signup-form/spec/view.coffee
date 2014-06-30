{expect} = chai
View = require 'signup-form-view'


describe 'View', ->

  describe 'options', ->

    context 'when not specified', ->

      it 'should set an ID', ->
        view = new View
        expect(view.id).to.exist


      it 'should set button text', ->
        view = new View
        expect(view.buttonText).to.exist


      it 'should set placeholder text', ->
        view = new View
        expect(view.placeholderText).to.exist


      it 'should set an error message for generic errors', ->
        view = new View
        expect(view.errorMessages.generic).to.exist


      it 'should set a error message for invalid email addresses', ->
        view = new View
        expect(view.errorMessages.invalidEmail).to.exist


      it 'should set a success message', ->
        view = new View
        expect(view.successMessage).to.exist


    context 'when specified', ->

      it 'should set the ID', ->
        id = 'test-id'

        view = new View
          id: id

        expect(view.id).to.equal id


      it 'should set the button text', ->
        buttonText = 'test button text'

        view = new View
          buttonText: buttonText

        expect(view.buttonText).to.equal buttonText


      it 'should set the placeholder text', ->
        placeholderText = 'test placeholder text'

        view = new View
          placeholderText: placeholderText

        expect(view.placeholderText).to.equal placeholderText


      it 'should set the error message for generic errors', ->
        errorMessage = 'test generic error message'

        view = new View
          errorMessages:
            generic: errorMessage

        expect(view.errorMessages.generic).to.equal errorMessage


      it 'should set the error message for invalid email addresses', ->
        errorMessage = 'test invalid email error message'

        view = new View
          errorMessages:
            invalidEmail: errorMessage

        expect(view.errorMessages.invalidEmail).to.equal errorMessage


      it 'should set the success message', ->
        successMessage = 'test success message'

        view = new View
          successMessage: successMessage

        expect(view.successMessage).to.equal successMessage
