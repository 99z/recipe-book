recipeBook.controller('dashboardCtrl', ['$scope', 'Restangular', 'Auth', function($scope, Restangular,  Auth){

  $scope.test = "angular works";
  Auth.currentUser().then( function(user) {
      $scope.currentUser = user;
    });

    $scope.following = [];
    $scope.followers = [];

    Restangular.all('followerships').getList().then(function(followerships) {

      following = followerships.filter(function(f) {
        return f.follower_id == $scope.currentUser.id;
      });

      followers = followerships.filter(function(f) {
        return f.followed_id == $scope.currentUser.id;
      });

      following.forEach(function(following) {

        user = Restangular
                .one('users', following.followed_id)
                .get()
                .$object;

        user.profile = Restangular
                       .one('profiles', following.followed_id)
                       .get()
                       .$object;

        $scope.following.push(user);

        console.log(user.profile);

      });

      followers.forEach(function(follower) {
        $scope.followers.push(Restangular
                          .one('users', follower.follower_id)
                          .get()
                          .$object);
      });
    });

}]);
