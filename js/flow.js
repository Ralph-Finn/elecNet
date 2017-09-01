
$(function(){
	$( "#draw" ).button();
});
//////map的相关设置//////////////////////
var map = new BMap.Map('allmap',{enableMapClick : false});
map.addControl(new BMap.NavigationControl());
map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
map.addControl(new BMap.MapTypeControl()); 
map.centerAndZoom(new BMap.Point(113.340217, 23.12408 ), 16);
////////////////////////////////////////////////////////
var street = echarts.init(document.getElementById('street'));
var time = echarts.init(document.getElementById('time'));
$("#drawA").keyup(function(event){
	if(event.keyCode ==13){
	$.ajax({
	url:'./getMux.php',
	type:'post',
	dataType:'json', 
	success:function(data){
		console.log($('#drawA').val());
		var times = $('#drawA').val();
		console.log(data);
		drawLine(data,5,6,times);
		time.setOption(getOption(data[4],times,1));
		//drawPoint(data);
	}
	});
	}
});
	$("#drawB").keyup(function(event){
		if(event.keyCode ==13){
		$.ajax({
			url:'./getMux.php',
			type:'post',
			dataType:'json', 
			success:function(data){
				console.log(data);
				var streets = $('#drawB').val();
				console.log(streets);
				street.setOption(getOption(data[4],streets,0));
			}
		});
		}
	});
  function colorMap(num)
  {
	val = parseInt(num/30)+1;
	var color = '#096'; 
	switch(val)
	{
	case 1:
	  color ='#096';
	  break;
	case 2:
	  color ='#ffde33';
	  break;
	case 3:
	  color = '#ff9933';
	  break;
	case 4:
	  color = '#cc0033';
	  break;
	case 5:
	  color = '#660099';
	  break;
	case 6:
	  color = '#7e0023';
	  break;
	default:
	  color = '#000000';
	}
	return color;
  }
  
 function verdataM(data,key)
 {
		var ver = new Array();
		var div = 1;
		if(data[0].length < 30) {div = 1;}
		else if (data[0].length < 50) {div = 2;}
			else {div = 4};
		key =key *div;
		console.log(key);
		for (var i in data){
			ver.push(data[i][key]);
		}
		
		return ver;
}
	
 function drawLine(data,pointindex,lineindex,key)
 {
	console.log('in drawLine function');
	var point1=new BMap.Point(113.14,23.08);
	var point2=new BMap.Point(113.14,23.08);
	var pointClub = data[pointindex];
	var lineClub = data[lineindex];
	console.log(key);
	var ver = verdataM(data[4],key);
	console.log(ver);
	for(var key in lineClub){ 
	  point = getLineData(key, lineClub, pointClub);
	  //覆盖物点坐标
		console.log(colorMap(ver[key]));
		if(pointindex == 5){
			var polyline = new BMap.Polyline([
				point[0],
				point[1]
			], {strokeColor:colorMap(ver[key]), strokeWeight:6, strokeOpacity:1}); 
		}else{
			var polyline = new BMap.Polyline([
				point[0],
				point[1]
			], {strokeColor:'black', strokeWeight:3, strokeOpacity:1}); 
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
 
function verdata(data,key,type)
{
		var ver = new Array();
		var xA = new Array();
		var div = 1;
		if(data[key].length < 30) {div = 1;}
		else if (data[key].length < 50) {div = 2;}
			else {div = 4};
		if(type == 1)
		{
			key = key*div;
			console.log(key);
			for (var i in data){
				ver.push(data[i][key]);
				xA.push(i);
			}
		}else{
			for (var i in data[key]){
				ver.push(data[key][i]);
				xA.push(i/div);
				console.log(i);
			}
		}
		return [xA,ver];
}

function getOption(data,key,type)
{
	
	ver = verdata(data,key,type);
	//console.log(ver);
	var colors = ['#5793f3', '#d14a61', '#675bba'];


	option = {
		color: colors,  //设置color的数组

		tooltip : {
			trigger: 'axis',
			axisPointer: {
				type: 'cross',
				label: {
					backgroundColor: '#6a7985'
				}
			}
		},
		legend: {
			show:false
		},
		grid: {
			top: 20,
			bottom: 20,
			left:35,
			right:10
		},
		xAxis: [
			{
				type: 'category',
				axisTick: {
					alignWithLabel: true
				},
				axisLine: {
					onZero: false,
					lineStyle: {
						color: colors[0]
					}
				},
				axisPointer: {
				},
				data: ver[0]
			}
		],
		yAxis: [
		{
			type: 'value',
			axisLabel:{
                            textStyle:{
                                color:'#fff'
                            }
                        }
		}
		],
		visualMap: {
				top: 10,
				right: 10,
				show:false,
				pieces: [{
					gt: 0,
					lte: 30,
					color: '#096'
				}, {
					gt: 30,
					lte: 60,
					color: '#ffde33'
				}, {
					gt: 60,
					lte: 90,
					color: '#ff9933'
				}, {
					gt: 90,
					lte: 120,
					color: '#cc0033'
				}, {
					gt: 120,
					lte: 150,
					color: '#660099'
				}, {
					gt: 150,
					color: '#7e0023'
				}],
				outOfRange: {
					color: '#999'
				}
			},
		series: [
			{
				name:'车流量',
				type:'line',
				smooth: true,
				areaStyle: {normal: {}},
				data:ver[1]
			}
		]
	};
	return option;
}
