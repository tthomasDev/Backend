var myNeighTool = angular.module('myNeighTool', []);
     
	myNeighTool.controller('SiteConstantsListCtrl', function ($scope) {
    $scope.constants = [{
    	'siteName': 'MyNeighTool',
    	'siteSlogan': 'Pretez avec vos voisin',
    	'siteMainPage': 'dashboard.html'
    }];
    
    $scope.botmenu = [
	{
    	'linkUrl': 'index.html',
    	'linkName': 'Index'
    },
    {
    	'linkUrl': 'contact.html',
    	'linkName': 'Contact'
    }];
    
});