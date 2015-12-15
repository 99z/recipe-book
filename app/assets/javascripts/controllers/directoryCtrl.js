recipeBook.controller('directoryCtrl', ['$scope', '$location', 'Restangular', 'Auth', function($scope, $location, Restangular,  Auth){

  Auth.currentUser().then( function(user) {
      $scope.currentUser = user;
    });

  Restangular.all('users').getList().then(function(users) {
    $scope.users = users;

    $scope.users.forEach(function(user) {
      user.profile = Restangular
                     .one('profiles', user.id)
                     .get()
                     .$object;
    });
  });

}]);
