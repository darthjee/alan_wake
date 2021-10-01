(function(angular) {
  var module = angular.module('alan_wake', [
    'global',
    'cyberhawk',
    'kanto',
    'home',
    'login'
  ]);

  module.config(['$httpProvider', function($httpProvider) {
    $httpProvider.defaults.headers.patch = {
      'Content-Type': 'application/json;charset=utf-8'
    };
  }]);
}(window.angular));
