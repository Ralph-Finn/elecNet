
	// 百度地图API功能
	$(function(){
		$( "#road, #line" ).button();
	});
	//////map的相关设置//////////////////////
	var map = new BMap.Map('allmap',{enableMapClick : false});
	map.addControl(new BMap.NavigationControl());
	map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
	map.addControl(new BMap.MapTypeControl()); 
	map.centerAndZoom(new BMap.Point(113.340217, 23.12408 ), 16);/////////////////分别制作两个变量,带s的表示的是输电线路///////////////////////////////////////
	function getTL()
	{
		var tileLayer = new BMap.TileLayer({isTransparentPng: true});
		tileLayer.getTilesUrl = function(tileCoord, zoom) {
			var x = tileCoord.x;
			var y = tileCoord.y;
			return 'tile/' + zoom + '/tile' + x + '_' + y + '.png';  //根据当前坐标，选取合适的瓦片图
		}
		return tileLayer;
	}
	
	function getTLs()
	{
		var tileLayers = new BMap.TileLayer({isTransparentPng: true});
		tileLayers.getTilesUrl = function(tileCoord, zoom) {
			var x = tileCoord.x;
			var y = tileCoord.y;
			return 'tiles/' + zoom + '/tile' + x + '_' + y + '.png';  //根据当前坐标，选取合适的瓦片图
		}
		return tileLayers;
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//add_control();
	function addRoad()
	{
		window.location.href="./addRoadLayer.html"
	}
	function addLine()
	{
		window.location.href="./addLineLayer.html"
	}
	//map.addTileLayer(getTL());
