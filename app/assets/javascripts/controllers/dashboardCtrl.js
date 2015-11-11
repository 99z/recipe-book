recipeBook.controller('dashboardCtrl', ['$scope', 'Restangular', 'Auth', function($scope, Restangular,  Auth){

  $scope.test = "angular works"
  Auth.currentUser().then( function(user) {
      $scope.currentUser = user
    })

}]);