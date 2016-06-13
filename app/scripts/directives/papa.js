'use strict';

/**
 * @ngdoc directive
 * @name pruebasApp.directive:papa
 * @description
 * # papa
 */
angular.module('pruebasApp')
  .directive('papa', function () {
    return {
      template: '<span></span>',
      replace: true,
      restrict: 'E',
      link: function postLink(scope, element, attrs) {
        element.text('this is the papa directive');
      }
    };
  });
