class SignupFormView

  constructor: (options = {}) ->
    {
      @id
      @buttonText
      @placeholderText
      @errorMessages
      @successMessage
    } = options

    @id ?= 'signup-form'
    @buttonText ?= 'Sign up'
    @placeholderText ?= 'Email address'
    @errorMessages ?= {}
    @errorMessages.generic ?= 'There was an error processing your request. Please try again.'
    @errorMessages.invalidEmail ?= 'Your email address is invalid. Please try again.'
    @successMessage ?= 'Thanks!'


  render: =>
    # Workaround for GSS and volatile DOM
    # Set the error message to the longest message initially
    if @errorMessages.generic.length > @errorMessages.invalidEmail.length
      errorMessage = @errorMessages.generic
    else
      errorMessage = @errorMessages.invalidEmail


    return """
      <form id="#{@id}" novalidate>
        <p id="#{@_errorMessageId()}" class="alert error hidden">#{errorMessage}</p>
        <p id="#{@_successMessageId()}" class="alert success hidden">#{@successMessage}</p>
        <input id="#{@_inputFieldId()}" type="email" placeholder="#{@placeholderText}" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false">
        <input id="#{@_submitButtonId()}" class="button" type="submit" value="#{@buttonText}">
      </form>
    """


  $errorMessage: => $("##{@_errorMessageId()}")
  $inputField: => $("##{@_inputFieldId()}")
  $form: => $("##{@id}")
  $submitButton: => $("##{@_submitButtonId()}")
  $successMessage: => $("##{@_successMessageId()}")


  _errorMessageId: => "#{@id}-error-message"
  _inputFieldId: => "#{@id}-input-field"
  _submitButtonId: => "#{@id}-submit-button"
  _successMessageId: => "#{@id}-success-message"


module.exports = SignupFormView
