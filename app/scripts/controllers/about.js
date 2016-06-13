'use strict';

/**
 * @ngdoc function
 * @name pruebasApp.controller:AboutCtrl
 * @description
 * # AboutCtrl
 * Controller of the pruebasApp
 */
angular.module('pruebasApp')
  .controller('AboutCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
  });
