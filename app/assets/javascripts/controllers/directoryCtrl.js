recipeBook.controller('directoryCtrl', ['$scope', '$location', 'Restangular', 'Auth', function($scope, $location, Restangular,  Auth){

  $scope.sortReverse = false;
  $scope.sortType = 'profile.last_name';

  Auth.currentUser().then( function(user) {
      $scope.currentUser = user;
    });

  Restangular.all('users').getList().then(function(users) {
    $scope.users = users;

    $scope.users.forEach(function(user) {
      /*user.profile = Restangular
                     .one('profiles', user.id)
                     .get()
                     .$object;*/

      Restangular.all('recipes').getList().then(function(recipes) {
        user.recipes = $.grep(recipes, function(recipe) {
          return recipe.user_id == user.id;
        });
      })
    });

    console.log($scope.users);
  });

}]);
