require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"signup-form":[function(require,module,exports){
module.exports=require('++li7K');
},{}],"++li7K":[function(require,module,exports){
var SignupForm, View, ViewModel;

View = require('signup-form-view');

ViewModel = require('signup-form-view-model');

SignupForm = (function() {
  function SignupForm(options) {
    var betaId, buttonText, errorMessages, errorObservable, id, onError, onSuccess, placeholderText, successMessage, useTemplate;
    this.parentSelector = options.parentSelector, onError = options.onError, onSuccess = options.onSuccess, useTemplate = options.useTemplate, betaId = options.betaId, id = options.id, buttonText = options.buttonText, placeholderText = options.placeholderText, errorMessages = options.errorMessages, successMessage = options.successMessage;
    if (this.parentSelector == null) {
      this.parentSelector = 'body';
    }
    if (useTemplate == null) {
      useTemplate = true;
    }
    this.view = new View({
      id: id,
      buttonText: buttonText,
      placeholderText: placeholderText,
      errorMessages: errorMessages,
      successMessage: successMessage
    });
    if (useTemplate) {
      this.template = this.view.render();
      $(this.parentSelector).append(this.template);
    }
    this.viewModel = new ViewModel({
      betaId: betaId
    });
    Rx.Observable.fromEvent(this.view.$inputField()[0], 'keyup').map(function(e) {
      return e.target.value;
    }).startWith(this.view.$inputField().val()).subscribe((function(_this) {
      return function(emailAddress) {
        return _this.viewModel.emailAddress.onNext(emailAddress);
      };
    })(this));
    this.viewModel.success.subscribe((function(_this) {
      return function(success) {
        return _this.view.$successMessage().toggleClass('hidden', !success);
      };
    })(this));
    this.viewModel.success.filter(function(success) {
      return success;
    }).subscribe((function(_this) {
      return function(success) {
        return typeof onSuccess === "function" ? onSuccess(_this.viewModel.emailAddress.value) : void 0;
      };
    })(this));
    errorObservable = this.viewModel.genericError.combineLatest(this.viewModel.invalidEmailError, function(genericError, invalidEmailError) {
      return genericError || invalidEmailError;
    });
    errorObservable.subscribe((function(_this) {
      return function(error) {
        return _this.view.$errorMessage().toggleClass('hidden', !error);
      };
    })(this));
    errorObservable.filter(function(error) {
      return error;
    }).subscribe((function(_this) {
      return function(error) {
        return typeof onError === "function" ? onError() : void 0;
      };
    })(this));
    this.viewModel.genericError.filter(function(genericError) {
      return genericError;
    }).subscribe((function(_this) {
      return function(genericError) {
        return _this.view.$errorMessage().text(_this.view.errorMessages.genericError);
      };
    })(this));
    this.viewModel.invalidEmailError.filter(function(invalidEmailError) {
      return invalidEmailError;
    }).subscribe((function(_this) {
      return function(invalidEmailError) {
        return _this.view.$errorMessage().text(_this.view.errorMessages.invalidEmail);
      };
    })(this));
    this.viewModel.emailAddressIsValid.subscribe((function(_this) {
      return function(valid) {
        return _this.view.$submitButton().prop('disabled', !valid);
      };
    })(this));
    Rx.Observable.fromEvent(this.view.$form()[0], 'submit').subscribe((function(_this) {
      return function(e) {
        e.preventDefault();
        return _this.viewModel.executeSubmitCommand();
      };
    })(this));
  }

  return SignupForm;

})();

module.exports = SignupForm;


},{"signup-form-view":"V7h571","signup-form-view-model":"M94WLT"}],"signup-form-view-model":[function(require,module,exports){
module.exports=require('M94WLT');
},{}],"M94WLT":[function(require,module,exports){
var HOST, SignUpFormViewModel,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

HOST = 'http://localhost:5000';

SignUpFormViewModel = (function() {
  function SignUpFormViewModel(options) {
    this.executeSubmitCommand = __bind(this.executeSubmitCommand, this);
    this.betaId = options.betaId;
    this.emailAddress = new Rx.BehaviorSubject;
    this.emailAddressIsValid = new Rx.BehaviorSubject;
    this.genericError = new Rx.BehaviorSubject(false);
    this.invalidEmailError = new Rx.BehaviorSubject(false);
    this.success = new Rx.BehaviorSubject(false);
    this.emailAddress.map(function(value) {
      return /^.+@.+\..+$/.test(value);
    }).subscribe((function(_this) {
      return function(isValid) {
        return _this.emailAddressIsValid.onNext(isValid);
      };
    })(this));
    this.genericError.combineLatest(this.invalidEmailError, function(genericError, invalidEmailError) {
      return genericError || invalidEmailError;
    }).filter(function(error) {
      return error;
    }).subscribe((function(_this) {
      return function(error) {
        return _this.success.onNext(false);
      };
    })(this));
    this.success.filter(function(success) {
      return success;
    }).subscribe((function(_this) {
      return function(success) {
        _this.genericError.onNext(false);
        return _this.invalidEmailError.onNext(false);
      };
    })(this));
  }

  SignUpFormViewModel.prototype.executeSubmitCommand = function() {
    var _ref;
    if ((_ref = this._jqXHR) != null) {
      _ref.abort();
    }
    this.genericError.onNext(false);
    this.invalidEmailError.onNext(false);
    this.success.onNext(false);
    this._jqXHR = $.ajax({
      type: 'POST',
      url: "" + HOST + "/api/v2/betas/" + this.betaId + "/testers",
      data: JSON.stringify({
        tester: {
          email: this.emailAddress.value
        }
      }),
      contentType: 'application/json; charset=utf-8',
      dataType: 'json'
    });
    return Rx.Observable.fromPromise(this._jqXHR.promise()).subscribe((function(_this) {
      return function(data) {
        return _this.success.onNext(true);
      };
    })(this), (function(_this) {
      return function(error) {
        if (error.status === 422 && error.responseJSON.errors[0].code === 2310) {
          return _this.success.onNext(true);
        } else if (error.status === 422 && error.responseJSON.errors[0].code === 2301) {
          return _this.invalidEmailError.onNext(true);
        } else {
          return _this.genericError.onNext(true);
        }
      };
    })(this));
  };

  return SignUpFormViewModel;

})();

module.exports = SignUpFormViewModel;


},{}],"signup-form-view":[function(require,module,exports){
module.exports=require('V7h571');
},{}],"V7h571":[function(require,module,exports){
var SignupFormView,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

SignupFormView = (function() {
  function SignupFormView(options) {
    var _base, _base1;
    if (options == null) {
      options = {};
    }
    this._successMessageId = __bind(this._successMessageId, this);
    this._submitButtonId = __bind(this._submitButtonId, this);
    this._inputFieldId = __bind(this._inputFieldId, this);
    this._errorMessageId = __bind(this._errorMessageId, this);
    this.$successMessage = __bind(this.$successMessage, this);
    this.$submitButton = __bind(this.$submitButton, this);
    this.$form = __bind(this.$form, this);
    this.$inputField = __bind(this.$inputField, this);
    this.$errorMessage = __bind(this.$errorMessage, this);
    this.render = __bind(this.render, this);
    this.id = options.id, this.buttonText = options.buttonText, this.placeholderText = options.placeholderText, this.errorMessages = options.errorMessages, this.successMessage = options.successMessage;
    if (this.id == null) {
      this.id = 'signup-form';
    }
    if (this.buttonText == null) {
      this.buttonText = 'Sign up';
    }
    if (this.placeholderText == null) {
      this.placeholderText = 'Email address';
    }
    if (this.errorMessages == null) {
      this.errorMessages = {};
    }
    if ((_base = this.errorMessages).generic == null) {
      _base.generic = 'There was an error processing your request. Please try again.';
    }
    if ((_base1 = this.errorMessages).invalidEmail == null) {
      _base1.invalidEmail = 'Your email address is invalid. Please try again.';
    }
    if (this.successMessage == null) {
      this.successMessage = 'Thanks!';
    }
  }

  SignupFormView.prototype.render = function() {
    var errorMessage;
    if (this.errorMessages.generic.length > this.errorMessages.invalidEmail.length) {
      errorMessage = this.errorMessages.generic;
    } else {
      errorMessage = this.errorMessages.invalidEmail;
    }
    return "<form id=\"" + this.id + "\" novalidate>\n  <p id=\"" + (this._errorMessageId()) + "\" class=\"alert error hidden\">" + errorMessage + "</p>\n  <p id=\"" + (this._successMessageId()) + "\" class=\"alert success hidden\">" + this.successMessage + "</p>\n  <input id=\"" + (this._inputFieldId()) + "\" type=\"email\" placeholder=\"" + this.placeholderText + "\" autocapitalize=\"off\" autocomplete=\"off\" autocorrect=\"off\" spellcheck=\"false\">\n  <input id=\"" + (this._submitButtonId()) + "\" class=\"button\" type=\"submit\" value=\"" + this.buttonText + "\">\n</form>";
  };

  SignupFormView.prototype.$errorMessage = function() {
    return $("#" + (this._errorMessageId()));
  };

  SignupFormView.prototype.$inputField = function() {
    return $("#" + (this._inputFieldId()));
  };

  SignupFormView.prototype.$form = function() {
    return $("#" + this.id);
  };

  SignupFormView.prototype.$submitButton = function() {
    return $("#" + (this._submitButtonId()));
  };

  SignupFormView.prototype.$successMessage = function() {
    return $("#" + (this._successMessageId()));
  };

  SignupFormView.prototype._errorMessageId = function() {
    return "" + this.id + "-error-message";
  };

  SignupFormView.prototype._inputFieldId = function() {
    return "" + this.id + "-input-field";
  };

  SignupFormView.prototype._submitButtonId = function() {
    return "" + this.id + "-submit-button";
  };

  SignupFormView.prototype._successMessageId = function() {
    return "" + this.id + "-success-message";
  };

  return SignupFormView;

})();

module.exports = SignupFormView;


},{}]},{},["++li7K","M94WLT","V7h571"]);