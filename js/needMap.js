//////map的相关设置//////////////////////
var map = new BMap.Map("allmap",{mapType: BMAP_HYBRID_MAP});
map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
map.addControl(new BMap.MapTypeControl()); 
map.centerAndZoom(new BMap.Point(113.340217, 23.12408 ), 16);
heatmapOverlay = new BMapLib.HeatmapOverlay({"radius":15});//添加地图覆盖图层
map.addOverlay(heatmapOverlay);
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
		drawHeatmap(data);
		}
	}
	});
});
function getParm()
{
	var delta = 15;
	var weekday = 1;
	var ratio = Number(document.getElementById('drawA').value);
	if($('#t1').is(':checked')) delta = 15;
	if($('#t2').is(':checked')) delta = 30;
	if($('#t3').is(':checked')) delta = 60;
	if($('#h1').is(':checked')) weekday = 1;
	if($('#h2').is(':checked')) weekday = 0;
	var start = $( "#slider-range" ).slider( "values", 0 );
	var end = $( "#slider-range" ).slider( "values", 1 );
	var params = {type:1,ratio:ratio,delta:delta,weekday:weekday,start:start,end:end};
	console.log(params);
	return params;
}


function drawHeatmap(data)
{
	console.log('in the drawHeatmap function');
	console.log(data[0]);
	console.log(toJson(data[0]));
	heatmapOverlay.setDataSet({data:toJson(data[0]),max:3});
	heatmapOverlay.show();
}

function toJson(data)
{
	var jsonstr="[";
	for(key in data)
	{
	    substr = "{lng:"+data[key][0]+",lat:"+data[key][1]+",count:1},";
		jsonstr += substr;
	}
	jsonstr = jsonstr.substring(0,jsonstr.length-1);//除去最后一个字符串
	jsonstr += "]";
	return eval(jsonstr);
}
