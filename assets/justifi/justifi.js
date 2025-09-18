
var cardForm = document.querySelector('justifi-card-form');
var bankAccountForm = document.querySelector('justifi-bank-account-form');

new ResizeObserver(heightListener).observe(content)

function heightListener() {
    if (typeof window.flutter_inappwebview !== "undefined" && typeof window.flutter_inappwebview.callHandler !== "undefined")
        window.flutter_inappwebview.callHandler('onHeightChanged', document.getElementById("content").offsetHeight);
}

var validateAndTokenize = function (isCardForm, isOtherFieldsValid, paramsData, doTokenize) {
    var paymentForm = isCardForm ? cardForm : bankAccountForm;

    paymentForm.validate().then(function(data) {
        var shouldTokenize = data.isValid && isOtherFieldsValid && doTokenize;
        if (shouldTokenize) {
            var clientId = paramsData['client_id'];
            var accountId = paramsData['account_id'];
            var params = paramsData['params'];
            getToken(isCardForm, clientId, params, accountId);
        }
    });
}

var getToken = function (isCardForm, CLIENT_ID, params, account_id) {
    // Determine which form to use
    var form = isCardForm ? cardForm : bankAccountForm;
    // Start loading on the Flutter side
    window.flutter_inappwebview.callHandler('tokenize', true);
    // Tokenize the form data
    form.tokenize(CLIENT_ID, params, account_id).then(function(data) {
        // Check for error message and display on the Flutter side
        if (haveValue(data) && haveValue(data.error) && haveValue(data.error.message)) {
            window.flutter_inappwebview.callHandler('tokenize', data.error.message);
        }
        // Send tokenized data to the Flutter side
        if (haveValue(data) && haveValue(data.data)) {
            var justifiData = {};
            if (haveValue(data.id)) justifiData.paymentToken = data.id;
            if (haveValue(data.data.card)) justifiData.cardDetails = data.data.card;
            if (haveValue(data.data.bank_account)) justifiData.bankAccountDetails = data.data.bank_account;
            window.flutter_inappwebview.callHandler('tokenize', justifiData);
        }
        // Stop loading on the Flutter side
        window.flutter_inappwebview.callHandler('tokenize', false);
    }).catch(function(error) {
        // Display error message and stop loading on the Flutter side
        window.flutter_inappwebview.callHandler('tokenize', data.error.message);
        window.flutter_inappwebview.callHandler('tokenize', false);
        throw error;
    });
};

function haveValue(value) {
    return value !== undefined && value !== null;
}

var scaleContent = function (scale) {
  document.body.style.margin = '0';
  document.body.style.padding = '2';

  var viewportmeta = document.createElement('meta');
  viewportmeta.setAttribute('name', 'viewport');
  viewportmeta.setAttribute('content', 'width=device-width, initial-scale=' + scale + ', maximum-scale=1.0');
  document.getElementsByTagName('head')[0].appendChild(viewportmeta);
}

var unFocus = function () {
    $('*').blur();
}

var setContent = function (isCardForm) {
    if (isCardForm) {
        // Remove listener if already exists
        if (haveValue(bankAccountForm)) {
            bankAccountForm.removeEventListener('bankAccountFormReady', bankAccountFormReadyCallback);
        }
        // Update content to display card form
        $('#content').html('<justifi-card-form validation-mode="onChange"></justifi-card-form>');
        // Add new listener on card form
        cardForm = document.querySelector('justifi-card-form');
        cardForm.addEventListener('cardFormReady', cardFormReadyCallback);
    } else {
        // Remove listener if already exists
        if (haveValue(cardForm)) {
            cardForm.removeEventListener('cardFormReady', cardFormReadyCallback);
        }
        // Update content to display bank account form
        $('#content').html('<justifi-bank-account-form validation-mode="onChange"></justifi-bank-account-form>');
        // Add new listener on bank account form
        bankAccountForm = document.querySelector('justifi-bank-account-form');
        bankAccountForm.addEventListener('bankAccountFormReady', bankAccountFormReadyCallback);
    }
}

var cardFormReadyCallback = function () {
    window.flutter_inappwebview.callHandler('paymentMethodLoaded', 'card');
};

var bankAccountFormReadyCallback = function () {
    window.flutter_inappwebview.callHandler('paymentMethodLoaded', 'bank');
};
