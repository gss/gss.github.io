View = require 'signup-form-view'
ViewModel = require 'signup-form-view-model'


class SignupForm

  constructor: (options) ->
    {
      @parentSelector
      onError
      onSuccess
      useTemplate
      betaId
      id
      buttonText
      placeholderText
      errorMessages
      successMessage
    } = options

    @parentSelector ?= 'body'
    useTemplate ?= true


    @view = new View
      id: id
      buttonText: buttonText
      placeholderText: placeholderText
      errorMessages: errorMessages
      successMessage: successMessage


    if useTemplate
      @template = @view.render()
      $(@parentSelector).append @template


    @viewModel = new ViewModel
      betaId: betaId

    Rx.Observable.fromEvent(@view.$inputField()[0], 'keyup')
      .map((e) ->
        return e.target.value
      )
      .startWith(@view.$inputField().val())
      .subscribe((emailAddress) =>
        @viewModel.emailAddress.onNext emailAddress
      )


    @viewModel.success.subscribe((success) =>
      @view.$successMessage().toggleClass 'hidden', not success
    )

    @viewModel.success
      .filter((success) ->
        return success
      )
      .subscribe((success) =>
        onSuccess? @viewModel.emailAddress.value
      )


    errorObservable = @viewModel.genericError.combineLatest(@viewModel.invalidEmailError, (genericError, invalidEmailError) ->
      return (genericError or invalidEmailError)
    )

    errorObservable.subscribe((error) =>
      @view.$errorMessage().toggleClass 'hidden', not error
    )

    errorObservable
      .filter((error) ->
        return error
      )
      .subscribe((error) =>
        onError?()
      )


    @viewModel.genericError
      .filter((genericError) ->
        return genericError
      )
      .subscribe((genericError) =>
        @view.$errorMessage().text @view.errorMessages.genericError
      )

    @viewModel.invalidEmailError
      .filter((invalidEmailError) ->
        return invalidEmailError
      )
      .subscribe((invalidEmailError) =>
        @view.$errorMessage().text @view.errorMessages.invalidEmail
      )


    @viewModel.emailAddressIsValid.subscribe((valid) =>
      @view.$submitButton().prop 'disabled', not valid
    )


    Rx.Observable.fromEvent(@view.$form()[0], 'submit').subscribe((e) =>
      e.preventDefault()
      @viewModel.executeSubmitCommand()
    )


module.exports = SignupForm
