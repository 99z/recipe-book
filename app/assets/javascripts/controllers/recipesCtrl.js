recipeBook.controller('recipesCtrl', ['$scope', 'Restangular', 'Auth', 'recipe', function($scope, Restangular,  Auth, recipe){

  $scope.recipe = recipe;

  Auth.currentUser().then( function(user) {
      $scope.currentUser = user;
    })

  $scope.submitScrape = function() {
    Restangular.one('recipes', $scope.recipe.id).patch($scope.scraper)
      .then(function(response){
        $scope.recipe = response;
      })
  }

}]);