recipeBook.controller('userShowCtrl', ['$scope', '$location', '$window', '$stateParams', 'Restangular', 'Auth', 'user', '$http', function($scope, $location, $window, $stateParams, Restangular, Auth, user, $http){

  $scope.user = user;

  Auth.currentUser().then(function(user) {
    $scope.currentUser = user;
    $scope.currentUserID = user.id;
    $scope.userCopy = $.extend({}, $scope.currentUser);
  });

  $scope.currentProfileID = $stateParams.userId;

  Restangular.all('profiles').getList().then(function(profiles) {
    $scope.profile = _.find(profiles, function(p) { return p.user_id == $stateParams.userId; });
  });

  Restangular.all('recipes').getList().then(function(recipes) {
    $scope.recipes = $.grep(recipes, function(recipe) {
      return recipe.user_id == $stateParams.userId;
    });
  });

  Restangular.all('followerships').getList().then(function(followerships) {
    filter = _.find(followerships, function(f) { return f.followed_id == $stateParams.userId && f.follower_id == $scope.currentUser.id; });

    if (filter) {
      $scope.alreadyFollowed = false;
    } else {
      $scope.alreadyFollowed = true;
    }

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

    var config = {
      headers: {
        'X-HTTP-Method-Override': 'DELETE'
      }
    };

    Auth.logout(config).then(function(user) {
      $window.location.reload();
    }, function(error) {
      //auth failed
    });
  };

  $scope.removeAcct = function() {
    $location.path("/");
    Restangular.one('users', $scope.userCopy.id).remove().then(function() {
      alert("Your account has been deleted.");
    });
  };

  $scope.newRecipe = function() {
    Restangular.all('recipes').post().then(function(recipe) {
      $location.path('recipes/' + recipe.id);
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

  $scope.follow = function(userID) {
    $scope.alreadyFollowed = !$scope.alreadyFollowed;

    var newFollow = { followed_id: userID,
                      follower_id: $scope.currentUser.id };

    Restangular.all('followerships').post(newFollow);
  };

  $scope.unfollow = function(userID, index) {
    $scope.alreadyFollowed = !$scope.alreadyFollowed;

    Restangular.all('followerships').getList().then(function(followerships) {

      var unfollowedUser = followerships.filter(function(f) {
        return f.followed_id == userID;
      });

      Restangular.one('followerships', unfollowedUser[0].id).remove();
    });
  };

}]);
