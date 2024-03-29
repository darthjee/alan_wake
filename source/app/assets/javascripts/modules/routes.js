(function(angular) {
  var module = angular.module('alan_wake');

  module.config(['kantoProvider', function(provider) {
    provider.defaultConfig = {
      controller: 'Cyberhawk.Controller',
      controllerAs: 'gnc',
      templateBuilder: function(route, params) {
        return route + '?ajax=true';
      }
    }

    provider.configs = [{
      routes: ['/'],
      config: {
        controller: 'Home.Controller',
        controllerAs: 'hc'
      }
    }, {
      routes: ["/games", "/games/new", "/games/:id", "/games/:id/edit"]
    }];
    provider.$get().bindRoutes();
  }]);
}(window.angular));

