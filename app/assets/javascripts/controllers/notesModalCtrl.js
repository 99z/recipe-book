recipeBook.controller('NotesModalController',
  ['$scope', '$window', 'notable', 'notable_type', 'close', 'Restangular',
  function($scope, $window, notable, notable_type, close, Restangular) {

    $scope.notable = notable;

    $scope.updateNote = function(note){
      Restangular.one('notes', note.id).patch(note)
        .then(function(response) {
          note.updated_at = response.updated_at;
        });
    };


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