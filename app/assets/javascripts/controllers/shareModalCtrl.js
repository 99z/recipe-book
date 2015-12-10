recipeBook.controller('ShareModalController',
  ['$scope', '$window', 'recipe', 'close', 'Restangular',
  function($scope, $window, recipe, close, Restangular) {


    $scope.deleteNote = function(note, index) {
      Restangular.one('notes',note.id).remove()
        .then( function() {
          $scope.notable.notes.splice(index, 1);
        });
    };


    $scope.addNote = function() {
      Restangular.all('notes').post({notable: notable, notable_type: notable_type})
        .then(function(response) {
          $scope.notable.notes.push(response);
        });
    };

}]);