recipeBook.controller('recipesCtrl', ['$scope', 'Restangular', 'Auth', 'recipe', function($scope, Restangular,  Auth, recipe){

  $scope.recipe = recipe[0];

  Auth.currentUser().then( function(user) {
      $scope.currentUser = user
    })

}]);