recipeBook.controller('dashboardCtrl', ['$scope', 'Restangular', 'Auth', function($scope, Restangular,  Auth){

  $scope.test = "angular works";
  Auth.currentUser().then( function(user) {
      $scope.currentUser = user;
    });

    $scope.following = [];
    $scope.followers = [];

    Restangular.all('followerships').getList().then(function(followerships) {

      followers = followerships.filter(function(f) {
        return f.followed_id == $scope.currentUser.id;
      });

      following = followerships.filter(function(f) {
        return f.follower_id == $scope.currentUser.id;
      });

      console.log($scope.following);

      following.forEach(function(following) {
        $scope.following.push(Restangular
                          .one('users', following.followed_id)
                          .get()
                          .$object);
      });

      followers.forEach(function(follower) {
        $scope.followers.push(Restangular
                          .one('users', follower.follower_id)
                          .get()
                          .$object);
      });
    });

}]);
