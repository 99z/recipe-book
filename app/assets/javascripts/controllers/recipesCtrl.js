recipeBook.controller('recipesCtrl', ['$scope', 'Restangular', 'Auth', 'recipe', function($scope, Restangular,  Auth, recipe){

  $scope.receipe = recipe;

  Auth.currentUser().then( function(user) {
      $scope.currentUser = user
    })

}]);