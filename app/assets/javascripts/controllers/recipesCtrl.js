recipeBook.controller('recipesCtrl', ['$scope', '$state', 'Restangular', 'Auth', 'recipe', function($scope, $state, Restangular,  Auth, recipe){

  $scope.recipe = recipe;

  Auth.currentUser().then( function(user) {
    $scope.currentUser = user;
    $scope.owner = $scope.checkOwner(user);
  });


  $scope.checkOwner = function(user) {
    return $scope.recipe.user_id === user.id
  };


  $scope.submitScrape = function() {
    if ($scope.owner) {
      Restangular.one('recipes', $scope.recipe.id).patch($scope.scraper)
        .then(function(response){
          $scope.recipe = response;
      })
    };
  };


  $scope.updateRecipe = function() {
    if ($scope.owner) {
      var recipeNested = {}
      recipeNested['recipe'] = $scope.recipe
      recipeNested['recipe']['ingredients_attributes'] = $scope.recipe.ingredients
      recipeNested['recipe']['instructions_attributes'] = $scope.recipe.instructions

      Restangular.one('recipes', $scope.recipe.id).patch(recipeNested);
    };
  };


  $scope.deleteRecipe = function() {
    if ($scope.owner) {
      Restangular.one('recipes', $scope.recipe.id).remove()
        .then( function() {
          $state.go('users.show', {userId: $scope.currentUser.id});
        })
    };
  };


}]);