# HOST = 'https://the-grid-prefinery.herokuapp.com'
HOST = 'http://localhost:5000'


class SignUpFormViewModel

  constructor: (options)->
    {@betaId} = options

    @emailAddress = new Rx.BehaviorSubject
    @emailAddressIsValid = new Rx.BehaviorSubject
    @genericError = new Rx.BehaviorSubject false
    @invalidEmailError = new Rx.BehaviorSubject false
    @success = new Rx.BehaviorSubject false

    @emailAddress
      .map((value) ->
        return /^.+@.+\..+$/.test value
      )
      .subscribe((isValid) =>
        @emailAddressIsValid.onNext isValid
      )

    @genericError
      .combineLatest(@invalidEmailError, (genericError, invalidEmailError) ->
        return (genericError or invalidEmailError)
      )
      .filter((error) ->
        return error
      )
      .subscribe((error) =>
        @success.onNext false
      )

    @success
      .filter((success) ->
        return success
      )
      .subscribe((success) =>
        @genericError.onNext false
        @invalidEmailError.onNext false
      )


  executeSubmitCommand: =>
    @_jqXHR?.abort()

    @genericError.onNext false
    @invalidEmailError.onNext false
    @success.onNext false

    @_jqXHR = $.ajax
      type: 'POST'
      url: "#{HOST}/api/v2/betas/#{@betaId}/testers",
      data: JSON.stringify({
        tester:
          email: @emailAddress.value
      })
      contentType: 'application/json; charset=utf-8',
      dataType: 'json'

    Rx.Observable.fromPromise(@_jqXHR.promise()).subscribe((data) =>
      @success.onNext true
    , (error) =>
      if error.status is 422 and error.responseJSON.errors[0].code is 2310
        # Disregard errors about duplicate testers
        @success.onNext true
      else if error.status is 422 and error.responseJSON.errors[0].code is 2301
        # Handle invalid email address error
        @invalidEmailError.onNext true
      else
        @genericError.onNext true
    )


module.exports = SignUpFormViewModel
