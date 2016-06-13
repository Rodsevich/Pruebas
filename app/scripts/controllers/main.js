'use strict';

/**
 * @ngdoc function
 * @name pruebasApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the pruebasApp
 */
angular.module('pruebasApp')
  .controller('MainCtrl', function ($scope) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
    $scope.titulo = "LONGA";
  });
