$(function(){
	$( "#draw" ).button();
});
//////map的相关设置//////////////////////
var map = new BMap.Map('allmap');
map.addControl(new BMap.NavigationControl());
map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
map.addControl(new BMap.MapTypeControl()); 
map.centerAndZoom(new BMap.Point(113.340217, 23.12408 ), 16);
////////////////////////////////////////////////////////
var storage=window.localStorage;
$("#draw").click(function(){
	$.ajax({
	url:'./getData.php',
	type:'post',
	dataType:'json', 
	success:function(data){
		console.log(data);
		drawLine(data,0,1);
		drawPoint(data);
	}
	});
});

function drawPoint(data)
 {
	var point1=new BMap.Point(113.14,23.08);
	pointClub = data[0];
	console.log('in drawPoint function');
	var Icon = new Array();
	var Center = new Array();
	for(i=0;i<8;i++)
	{
		//构造icon的列表，这里面的图片非常的完全。
		var mac = new BMap.Icon("./resource/n"+ String(i)+".png", new BMap.Size(15, 15), {});
		var cen = new BMap.Icon("./resource/t"+ String(i)+".png", new BMap.Size(25, 25), {});
		Icon.push(mac);
		Center.push(cen);
	}
	var station = new BMap.Icon("./resource/station.png", new BMap.Size(40, 40), {});
	for(var key in pointClub){ 	
		point1.lng=pointClub[key]['lng'];
		point1.lat=pointClub[key]['lat'];
	  //覆盖物点坐标
		if(pointClub[key]['center']==1){
			var marker = new BMap.Marker(point1,{icon: Center[pointClub[key]['section']]});
		}else if(pointClub[key]['center']==0){
			var marker = new BMap.Marker(point1,{icon: Icon[pointClub[key]['section']]});
				}else{
						var marker = new BMap.Marker(point1,{icon:station});
					}
		map.addOverlay(marker);
	}

 }
 
  function drawLine(data,pointindex,lineindex)
 {
	console.log('in drawLine function');
	var point1=new BMap.Point(113.14,23.08);
	var point2=new BMap.Point(113.14,23.08);
	var pointClub = data[pointindex];
	var lineClub = data[lineindex];
	var color = ['FFFFFF','#FF0000','#00FF00','#0000FF','#FFFF00','#00FFFF','#FF00FF','#A52A2A'];//颜色表
	for(var key in lineClub){ 
	  point = getLineData(key, lineClub, pointClub);
	  //覆盖物点坐标
		if(pointindex == 0){
			var polyline = new BMap.Polyline([
				point[0],
				point[1]
			], {strokeColor:color[lineClub[key]['section']], strokeWeight:2, strokeOpacity:1}); 
		}else{
			var polyline = new BMap.Polyline([
				point[0],
				point[1]
			], {strokeColor:'black', strokeWeight:2, strokeOpacity:1}); 
		}
		map.addOverlay(polyline); 
	}

 }
 
 function getLineData(key, lineClub, pointClub)
 {
	var point1=new BMap.Point(113.14,23.08);
	var point2=new BMap.Point(113.14,23.08);
	var keygen1 = lineClub[key]['start'];
	point1.lng=pointClub[keygen1-1]['lng'];
	point1.lat=pointClub[keygen1-1]['lat'];
	var keygen2 = lineClub[key]['end'];
	point2.lng=pointClub[keygen2-1]['lng'];
	point2.lat=pointClub[keygen2-1]['lat'];
	return [point1,point2];
 }