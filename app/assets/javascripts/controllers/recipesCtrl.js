recipeBook.controller('recipesCtrl', ['$scope', '$state', '$window', 'Restangular', 'Auth', 'recipe', function($scope, $state, $window, Restangular,  Auth, recipe){

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
    if ($scope.owner && $window.confirm("Delete this list?")) {
      Restangular.one('recipes', $scope.recipe.id).remove()
        .then( function() {
          $state.go('users.show', {userId: $scope.currentUser.id});
        })
    };
  };


  $scope.printRecipe = function() {
    // pop up new window with formatted recipe
    $window.open('/api/v1/recipes/'+$scope.recipe.id+'.html?method=print', '_blank');
    // open print dialog
    //$window.print();
  }


}]);