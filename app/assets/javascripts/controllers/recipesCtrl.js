recipeBook.controller('recipesCtrl', ['$scope', '$state', '$window', 'Restangular', 'Auth', 'recipe', 'ModalService', function($scope, $state, $window, Restangular,  Auth, recipe, ModalService){

  $scope.recipe = recipe;
  $scope.scraperActive = false;

  Auth.currentUser().then( function(user) {
    $scope.currentUser = user;
    $scope.owner = $scope.checkOwner(user);
  });


  $scope.checkOwner = function(user) {
    return $scope.recipe.user_id === user.id;
  };


  $scope.toggleScraper = function() {
    $scope.scraperActive = !$scope.scraperActive;
  };


  $scope.submitScrape = function() {
    if ($scope.owner) {
      Restangular.one('recipes', $scope.recipe.id).patch($scope.scraper)
        .then(function(response){
          $scope.recipe = response;
      });
    }
  };


  $scope.updateRecipe = function() {
    if ($scope.owner) {
      var recipeNested = {};
      recipeNested['recipe'] = $scope.recipe;
      recipeNested['recipe']['ingredients_attributes'] = $scope.recipe.ingredients;
      recipeNested['recipe']['instructions_attributes'] = $scope.recipe.instructions;

      Restangular.one('recipes', $scope.recipe.id).patch(recipeNested);
    }
  };


  $scope.deleteRecipe = function() {
    if ($scope.owner && $window.confirm("Delete this recipe?")) {
      Restangular.one('recipes', $scope.recipe.id).remove()
        .then( function() {
          $state.go('users.show', {userId: $scope.currentUser.id});
        });
    }
  };


  $scope.printRecipe = function() {
    var printWindow = $window.open('/api/v1/recipes/'+$scope.recipe.id+'.pdf');
    printWindow.print();
  };


  $scope.addComponent = function(className) {
    Restangular.one('recipes', $scope.recipe.id).all(className).post()
      .then( function(response) {
        $scope.recipe[className].push(response);
      });
  };


  $scope.showAddNote = function(notable) {
    $scope.hovered = notable;
  };


  $scope.isHovered = function(notable) {
    return (notable == $scope.hovered)
  }


  $scope.hideAddNotes = function() {
    $scope.hovered = {};
  }


  $scope.noteCount = function(notable) {
    var count = notable.notes.length;
    var text = "notes"
    if (count == 1) {
      var text = "note"
    };
    return count + " " + text;
  };




  $scope.openModal = function(notable, type) {
    ModalService.showModal({
      templateUrl: "templates/recipes/notesModal.html",
      controller: "NotesModalController",
      inputs: {
        notable: notable,
        notable_type: type,
        owner: $scope.owner
      }
    }).then(function(modal) {
      modal.element.modal();
      modal.close.then(function(result) {
        //console.log(result);
      });
    });
  };


}]);
