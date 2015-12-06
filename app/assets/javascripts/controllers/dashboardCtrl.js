recipeBook.controller('dashboardCtrl', ['$scope', '$location', 'Restangular', 'Auth', function($scope, $location, Restangular,  Auth){

  $scope.test = "angular works";
  Auth.currentUser().then( function(user) {
      $scope.currentUser = user;
    });

    $scope.following = [];
    $scope.followers = [];

    Restangular.all('followerships').getList().then(function(followerships) {

      var following = followerships.filter(function(f) {
        return f.follower_id == $scope.currentUser.id;
      });

      var followers = followerships.filter(function(f) {
        return f.followed_id == $scope.currentUser.id;
      });

      // TODO: refactor into a service
      following.forEach(function(following) {

        var user = Restangular
               .one('users', following.followed_id)
               .get()
               .$object;

        user.profile = Restangular
                       .one('profiles', following.followed_id)
                       .get()
                       .$object;

        $scope.following.push(user);

      });

      followers.forEach(function(follower) {

        var user = Restangular
               .one('users', follower.follower_id)
               .get()
               .$object;

        user.profile = Restangular
                       .one('profiles', follower.follower_id)
                       .get()
                       .$object;

        $scope.followers.push(user);

      });
    });

    $scope.unfollow = function(user) {
      Restangular.all('followerships').getList().then(function(followerships) {

        console.log(followerships);

        var unfollowedUser = followerships.filter(function(f) {
          return f.followed_id == user.id;
        });

        console.log(unfollowedUser[0].id);

        Restangular.one('followerships', unfollowedUser[0].id).remove().then(function(followership) {
          $scope.following.splice($scope.following.indexOf(followership), 1);
        });
      });
    };

}]);
