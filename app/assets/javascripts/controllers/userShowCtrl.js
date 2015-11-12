recipeBook.controller('userShowCtrl', ['$scope', '$stateParams', 'Restangular', 'Auth', function($scope, $stateParams, Restangular, Auth){

  Auth.currentUser().then( function(user) {
      $scope.currentUser = user;
    });

    Restangular.all('profiles').getList().then(function(profiles) {
      $scope.profile = _.find(profiles, function(p) { return p.user_id == $stateParams.userId; });
    });

}]);
