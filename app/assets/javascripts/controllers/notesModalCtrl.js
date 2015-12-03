recipeBook.controller('NotesModalController',
  ['$scope', '$window', 'notable', 'close', 'Restangular',
  function($scope, $window, notable, close, Restangular) {

    $scope.notable = notable;

    $scope.updateNote = function(note){
      Restangular.one('notes', note.id).patch(note)
        .then(function(response) {
          note.updated_at = response.updated_at;
        });
    };

}]);