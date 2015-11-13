recipeBook.controller('recipesCtrl', ['$scope', 'Restangular', 'Auth', 'recipe', function($scope, Restangular,  Auth, recipe){

  $scope.recipe = recipe;

  //Auth.currentUser().then( function(user) {
  //    $scope.currentUser = user;
  //  })

  $scope.submitScrape = function() {
    Restangular.one('recipes', $scope.recipe.id).patch($scope.scraper)
      .then(function(response){
        $scope.recipe = response;
      })
  };


  $scope.updateRecipe = function() {
    var recipeNested = {}
    recipeNested['recipe'] = $scope.recipe
    recipeNested['recipe']['ingredients_attributes'] = $scope.recipe.ingredients
    recipeNested['recipe']['instructions_attributes'] = $scope.recipe.instructions

    Restangular.one('recipes', $scope.recipe.id).patch(recipeNested);
  };

}]);