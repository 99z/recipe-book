recipeBook.controller('homeCtrl', ['$scope', 'Restangular', 'Auth', '$location', function($scope, Restangular, Auth, $location){

  $scope.credentials = {};

  $scope.signup = function() {
    var config = {
      headers: {
        'X-HTTP-Method-Override': 'POST'
      }
    };

    Auth.register($scope.credentials).then(function(user) {
      // console.log(user);
    }, function(error) {
      //auth failed
    });
  };

  $scope.$on('devise:new-registration', function(event, currentUser){
    $location.path("/dashboard/index");
  });

  var jumboHeight = $('.jumbotron').outerHeight();

  parallax = function() {
    var scrolled = $(window).scrollTop();
    $('.bg').css('height', (jumboHeight-scrolled + 100) + 'px');
  };

  $(window).scroll(function(e) {
    parallax();
  });

}]);
