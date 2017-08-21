//////map的相关设置//////////////////////
var map = new BMap.Map("allmap",{mapType: BMAP_HYBRID_MAP});
map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
map.addControl(new BMap.MapTypeControl()); 
map.centerAndZoom(new BMap.Point(113.340217, 23.12408 ), 16);
heatmapOverlay = new BMapLib.HeatmapOverlay({"radius":15});//添加地图覆盖图层
map.addOverlay(heatmapOverlay);
////////////////////////////////////////////////////////
$("#draw").click(function(){
	$.ajax({
	url:'./getResult.php',
	type:'post',
	dataType:'json', 
	success:function(data){
		console.log(data);
		drawHeatmap(data);
	}
	});
});

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
