recipeBook.controller('signinCtrl', ['$scope', '$window', 'Restangular', 'Auth', '$location', '$http', function($scope, $window, Restangular, Auth, $location, $http){

  $scope.credentials = {};
  $scope.recover = false;

  $scope.login = function() {
    var config = {
      headers: {
        'X-HTTP-Method-Override': 'POST'
      }
    };

    Auth.login($scope.credentials).then(function(user) {
      $window.location.reload();
    }, function(error) {
      //auth failed
    });
  };

  // $scope.$on('devise:login', function(event, currentUser){
  //   // $location.path("/dashboard/index");
  // });

  $scope.updatePage = function() {
    $location.path("/dashboard/index");
  };

  var jumboHeight = $('.jumbotron').outerHeight();

  parallax = function() {
    var scrolled = $(window).scrollTop();
    $('.bg').css('height', (jumboHeight-scrolled) + 'px');
  };

  $(window).scroll(function(e) {
    parallax();
  });


  $scope.toggleRecover = function() {
    $scope.recover = !$scope.recover;
  };

  $scope.resetPassword = function() {
    $http.post("/users/password",
      {"user": $scope.credentials}
    ).then( $scope.recover = false );
  };

}]);
