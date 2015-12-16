recipeBook.controller('dashboardCtrl', ['$scope', '$location', 'Restangular', 'Auth', function($scope, $location, Restangular,  Auth){

  Auth.currentUser().then( function(user) {
      $scope.currentUser = user;
    });

    $scope.following = [];
    $scope.followers = [];

    Restangular.all('newsfeeds').getList().then(function(newsfeed) {
      $scope.newsfeed = newsfeed;
    });

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

        /*user.profile = Restangular
                       .one('profiles', following.followed_id)
                       .get()
                       .$object;*/

        Restangular.all('recipes').getList().then(function(recipes) {
          user.recipes = $.grep(recipes, function(recipe) {
           return recipe.user_id == following.followed_id;
          });
        });

        $scope.following.push(user);

      });

      followers.forEach(function(follower) {

        var user = Restangular
               .one('users', follower.follower_id)
               .get()
               .$object;

        /*user.profile = Restangular
                       .one('profiles', follower.follower_id)
                       .get()
                       .$object;*/

         Restangular.all('recipes').getList().then(function(recipes) {
           user.recipes = $.grep(recipes, function(recipe) {
            return recipe.user_id == follower.follower_id;
           });
         });

        $scope.followers.push(user);

      });
    });

    $scope.unfollow = function(user, index) {
      Restangular.all('followerships').getList().then(function(followerships) {

        var unfollowedUser = followerships.filter(function(f) {
          return f.followed_id == user.id;
        });

        console.log(unfollowedUser);

        Restangular.one('followerships', unfollowedUser[0].id).remove().then(function(followership) {
          $scope.following.splice(index, 1);
        });
      });
    };

    $scope.addRecipe = function(recipe, $event) {
/*      recipe.user_id = $scope.currentUser.id;

      var recipeNested = {};
      recipeNested['recipe'] = recipe;
      recipeNested['recipe']['ingredients_attributes'] = recipe.ingredients;
      recipeNested['recipe']['instructions_attributes'] = recipe.instructions;

      //console.log(recipe);*/
      console.log($event);
      Restangular.all('recipes').post(recipe);
    };

}]);
