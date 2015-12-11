recipeBook.controller('ShareModalController',
  ['$scope', '$window', 'Auth', 'recipe', 'close', 'Restangular',
  function($scope, $window, Auth, recipe, close, Restangular) {

    $scope.allFollowing = [];

    Auth.currentUser().then( function(user) {
        $scope.currentUser = user;
      });

    Restangular.all('followerships').getList().then(function(followerships) {
      following = followerships.filter(function(f) {
        return f.follower_id == $scope.currentUser.id;
      });

      following.forEach(function(following) {

        var user = Restangular
               .one('users', following.followed_id)
               .get()
               .$object;

        user.profile = Restangular
                       .one('profiles', following.followed_id)
                       .get()
                       .$object;

        $scope.allFollowing.push(user);

      });
    });

    $scope.shareRecipe = function() {
      Restangular.all('shares').post({recipe_id: recipe.id, recipient_id: $scope.selectedUser})
        .then(function(response) {
          close();
        });
    };

}]);
