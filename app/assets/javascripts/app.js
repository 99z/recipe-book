var recipeBook = angular.module('recipeBook', ['angularModalService', 'xeditable', 'ui.router', 'restangular', 'Devise']);

recipeBook.run(['editableOptions', function(editableOptions) {
  editableOptions.theme = 'bs3';
}]);

recipeBook.config(['RestangularProvider', function(RestangularProvider) {
  RestangularProvider.setBaseUrl('/api/v1');
  RestangularProvider.setRequestSuffix('.json');
}]);

recipeBook.config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {

  $urlRouterProvider.otherwise("/");

  $stateProvider
    .state('home', {
      url: "/",
      templateUrl: "/templates/home.html",
      controller: "homeCtrl"
    })

    .state('sign_in', {
      url: "/sign_in",
      templateUrl: "/templates/sign_in.html",
      controller: "signinCtrl"
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

    .state('dashboard.directory', {
      url:"/directory",
      templateUrl: "/templates/dashboard/directory.html",
      controller: "directoryCtrl"
    })

    .state('recipes', {
      url: "/recipes",
      templateUrl: "/templates/recipes/layout.html"
    })

    .state('recipes.show', {
      url: "/:id",
      templateUrl: "/templates/recipes/show.html",
      controller: "recipesCtrl",
      resolve: {
        recipe: ['Restangular', '$stateParams', function(Restangular, $stateParams){
          return Restangular.one('recipes', $stateParams.id).get();
        }]}
      })

    .state('users', {
      url: "/users",
      templateUrl: "/templates/users/index.html"
    })

    .state('users.show', {
      url: "/:userId",
      templateUrl: "/templates/users/show.html",
      controller: "userShowCtrl",
      resolve: {
        user: ['Restangular', '$stateParams', function(Restangular, $stateParams){
          return Restangular.one('users', $stateParams.userId).get();
        }]}
    });

}]);
