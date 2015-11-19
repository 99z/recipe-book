recipeBook.controller('userShowCtrl', ['$scope', '$stateParams', 'Restangular', 'Auth', function($scope, $stateParams, Restangular, Auth){

  Auth.currentUser().then(function(user) {
    $scope.currentUser = user;
  });

  Restangular.all('profiles').getList().then(function(profiles) {
    $scope.profile = _.find(profiles, function(p) { return p.user_id == $stateParams.userId; });
  });

  Restangular.all('recipes').getList().then(function(recipes) {
    $scope.recipes = recipes;
  });

  $scope.viewMode = "thumbnail";

  $scope.setViewMode = function(mode) {
    $scope.viewMode = mode;
  };

  $scope.updateProfile = function() {
    console.log($scope.profile.id);
    $scope.profile.put();
  };

  $scope.deleteAccount = function() {
    Restangular.all('users').getList().then(function(users) {
      user = _.find(users, function(u) { return u.id == $scope.currentUser.id; });
      user.remove();
    });
  };



}]);
