recipeBook.controller('recipesCtrl', ['$scope', 'Restangular', 'Auth', function($scope, Restangular,  Auth){

  $scope.testValue = "angular works"
  Auth.currentUser().then( function(user) {
      $scope.currentUser = user
    })

}]);