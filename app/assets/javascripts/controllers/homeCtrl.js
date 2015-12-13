recipeBook.controller('homeCtrl', ['$scope', '$window', 'Restangular', 'Auth', '$location', function($scope, $window, Restangular, Auth, $location){

  $scope.credentials = {};

  $scope.signup = function() {
    var config = {
      headers: {
        'X-HTTP-Method-Override': 'POST'
      }
    };

    Auth.register($scope.credentials).then(function(user) {
      $window.location.reload();
    }, function(error) {
      //auth failed
    });
  };

  $scope.updatePage = function() {
    $location.path("/dashboard/index");
  };

  var jumboHeight = $('.jumbotron').outerHeight();

  parallax = function() {
    var scrolled = $(window).scrollTop();
    $('.bg').css('height', (jumboHeight-scrolled + 100) + 'px');
  };

  $(window).scroll(function(e) {
    parallax();
  });

}]);
