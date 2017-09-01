$(function(){
	$( "#draw" ).button();
	$.ajax({
	url:'./getData.php',
	type:'post',
	dataType:'json', 
	success:function(data){
		console.log(data);
		drawRoute(data,0,5);
	}
	});
});
//////map的相关设置//////////////////////
var map = new BMap.Map('allmap',{enableMapClick : false});
map.addControl(new BMap.NavigationControl());
map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
map.addControl(new BMap.MapTypeControl());
map.setMapStyle({style:'midnight'}); 
map.centerAndZoom(new BMap.Point(113.340217, 23.12408 ), 16);
var PC = echarts.init(document.getElementById('street'));
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
		//drawHeatmap(data);
		PC.setOption(getOption(data));
		}
	}
	});
});
function getParm()
{
	var delta = 15;
	var weekday = 1;
	var ratio = Number(document.getElementById('drawA').value);
	var fluency = Number(document.getElementById('drawB').value);
	if($('#h1').is(':checked')) weekday = 1;
	if($('#h2').is(':checked')) weekday = 0;
	var params = {type:3,ratio:ratio,weekday:weekday,fluency:fluency};
	console.log(params);
	return params;
}

var options = {
	onSearchComplete: function(results){
		if (driving.getStatus() == BMAP_STATUS_SUCCESS){
			var plan = results.getPlan(0);
			var route = plan.getRoute(0);
			var tt=route.getPath();
			var polyline = new BMap.Polyline(tt, {strokeColor:"white", strokeWeight:4, strokeOpacity:0.1}); 
			map.addOverlay(polyline);   //增加折线
			console.log('draw a route');
		}
	}
};
var driving = new BMap.DrivingRoute(map, options);//每次创造一个新的对象

function drawRoute(data,pointindex,lineindex)
 {
	console.log('in drawRoute function');
	var pointClub = data[pointindex];
	var lineClub = data[lineindex];
	for(var key = 0;key <400;key++){ 
	  point = getLineData(key, lineClub, pointClub);
	  driving.search(point[0], point[1]);
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
 
 function getOption(data)
{
var xdata = new Array();
for (i in data[1][0]){
	xdata.push(i);
}

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
        data:['私家车慢速充电负荷曲线', '私家车无序充电负荷曲线']
    },
    grid: {
        top: 20,
        bottom: 40,
		left:50,
		right:20
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
            data: xdata
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
    series: [
        {
            name:'微观交通',
            type:'line',
            smooth: true,
            data: data[1][0]
        },
		{
            name:'宏观交通',
            type:'line',
            smooth: true,
            data: data[2][0]
        }
    ]
};

	return option;

	}