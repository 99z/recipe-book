recipeBook.controller('userShowCtrl', ['$scope', '$stateParams', 'Restangular', 'Auth', 'user', '$http', function($scope, $stateParams, Restangular, Auth, user, $http){

  $scope.user = user;

  Auth.currentUser().then(function(user) {
    $scope.currentUser = user;
    $scope.currentUserID = user.id;
  });

  $scope.currentProfileID = $stateParams.userId;

  Restangular.all('profiles').getList().then(function(profiles) {
    $scope.profile = _.find(profiles, function(p) { return p.user_id == $stateParams.userId; });
  });

  Restangular.all('recipes').getList().then(function(recipes) {
    $scope.recipes = recipes;
  });

  $scope.viewMode = "thumbnail";
  $scope.sortType = "title";
  $scope.sortReverse = "false";

  $scope.setViewMode = function(mode) {
    $scope.viewMode = mode;
  };

  $scope.updateProfile = function() {
    console.log($scope.profile);
    $scope.profile.put();
  };

  $scope.deleteAccount = function() {
    Restangular.all('users').getList().then(function(users) {
      user = _.find(users, function(u) { return u.id == $scope.currentUser.id; });
      user.remove();
    });
  };


  $scope.uploadFile = function(files) {
    var fd = new FormData();
    fd.append('profile[avatar]', files[0]);
    $http.put("/api/v1/profiles/"+$scope.profile.id+".json",
              fd, {
                withCredentials: true,
                headers: {
                  'Content-Type': undefined,
                  'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')
                },
                transformRequest: angular.identity
              }
    ).then(function(response) {
        $scope.profile.avatar = response.data.avatar;
    });
  };



}]);
