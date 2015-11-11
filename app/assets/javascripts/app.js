var recipeBook = angular.module('recipeBook', ['angularModalService', 'xeditable', 'ui.router', 'restangular', 'Devise']);

recipeBook.run(function(editableOptions) {
  editableOptions.theme = 'bs3';
});

recipeBook.config(['RestangularProvider', function(RestangularProvider) {
  RestangularProvider.setBaseUrl('/api/v1');
  RestangularProvider.setRequestSuffix('.json');
}]);

recipeBook.config(function($stateProvider, $urlRouterProvider) {

  $urlRouterProvider.otherwise("/");

  $stateProvider
    .state('home', {
      url: "/",
      templateUrl: "/templates/home.html",
      controller: "homeCtrl"
    })

    .state('dashboard', {
      url: "/dashboard",
      templateUrl: "/templates/dashboard/dashboard.html"
    })

    .state('dashboard.index', {
      url: "/index",
      templateUrl: "/templates/dashboard/index.html",
      controller: "dashboardCtrl"
    })


    .state('recipes', {
      url: "/recipes",
      templateUrl: "/templates/recipes/layout.html"
    })

    .state('recipes.show', {
      url: "/:id",
      templateUrl: "/templates/recipes/show.html",
      controller: "recipesCtrl"
    })

});
