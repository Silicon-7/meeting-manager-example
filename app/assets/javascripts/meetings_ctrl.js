(function(){
  "use strict";

  angular.module("app").controller("meetingsCtrl", function($scope, $http){
    $scope.setup = function() {
      $http.get("/api/v1/meetings.json").then(function(response) {
        $scope.meetings = response.data;
      });
      $http.get("/api/v1/tags.json").then(function(response) {
        $scope.tags = response.data;
      });
    };

    $scope.filterByTag = function(tag) {
      $scope.tagFilterId = tag ? tag.id : null;
    };

    $scope.matchTag = function(meeting) {
      if ($scope.tagFilterId) {
        for (var i = 0; i < meeting.tags.length; i++) {
          var tag = meeting.tags[i];
          if (tag.id === $scope.tagFilterId) {
            return true;
          }
        }
        return false;
      } else {
        return true;
      }
    };

    $scope.changeOrderAttribute = function(attribute) {
      $scope.descending = (attribute !== $scope.orderAttribute) ? false : !$scope.descending;
      $scope.orderAttribute = attribute;
    };

    $scope.createMeeting = function(name, address, startTime, endTime, notes, tags) {
      var params = {
                    name: name,
                    address: address,
                    "start_time": startTime,
                    "end_time": endTime,
                    notes: notes,
                    tags: tags
                    };

      $http.post("/api/v1/meetings.json", params).then(function(response){
        $scope.meetings.push(response.data);
      });
    };
  });
}());





