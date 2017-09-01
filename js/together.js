//////map的相关设置//////////////////////
var map = new BMap.Map("allmap");
map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
map.addControl(new BMap.MapTypeControl()); 
map.centerAndZoom(new BMap.Point(113.340217, 23.12408 ), 16);
map.addTileLayer(getTLs());
////////////////////////////////////////////////////////
$("#draw").click(function(){
	params = getParm();
	if (params.ratio == 0){
		alert('请输入有关参数');
		return;//如果发现参数有错误。就终止函数的继续执行。
	}
	$.ajax({
	url:'./getResult.php',
	type:'post',
	dataType:'json',
	data: params,
	success:function(data){
		if(typeof(data) == "number")
		{
			alert("系统繁忙，请稍后重试！！！");
		}else{
		console.log(data);
			alert("计算完成");
		}
	}
	});
});
function getParm()
{
	var delta = 15;
	var weekday = 1;
	var ratio = Number(document.getElementById('drawA').value);
	if($('#h1').is(':checked')) weekday = 1;
	if($('#h2').is(':checked')) weekday = 0;
	var params = {type:2,ratio:ratio,weekday:weekday};
	console.log(params);
	return params;
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
