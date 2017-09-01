	var map = new BMap.Map('allmap');
	map.addControl(new BMap.NavigationControl());
	map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
	map.addControl(new BMap.MapTypeControl()); 
	map.centerAndZoom(new BMap.Point(113.340217, 23.12408 ), 16);
	var PC = echarts.init(document.getElementById('PC'));
	var PT = echarts.init(document.getElementById('PT'));
	$(function(){
		$.ajax({
			url:'./getFile.php',
			type:'post',
			dataType:'json', 
			success:function(data){
				console.log(data);
				drawPoint(data);
				PC.setOption(getOption(data[1][0],data[0][0]));
				PT.setOption(getOption(data[3][0],data[2][0]));
			}
		});
	});
	
	
function drawPoint(data)
 {
	var point1=new BMap.Point(113.14,23.08);
	pointClub = data[5];
	console.log('in drawPoint function');
	var station = new BMap.Icon("./resource/station.png", new BMap.Size(40, 40), {});
	for(var key in pointClub){ 	
		point1.lng=pointClub[key][0];
		point1.lat=pointClub[key][1];
	  //覆盖物点坐标
	var marker = new BMap.Marker(point1,{icon:station});
	var mess = "到站EV数:"+data[6][key][0]+";<br />充电量:"+data[6][key][1]+"MW";
	var label = new BMap.Label(mess,{offset:new BMap.Size(20,-20)});
	map.addOverlay(marker);
	marker.setLabel(label);
	}

 }
 
 
function getOption(dataM,dataK)
{
var xdata = new Array();
var div = 1;
console.log(dataM.length);
if(dataM.length < 40) {div = 1;}
else if (dataM.length < 70) {div = 2;}
	else {div = 4};
for (i in dataM){
	xdata.push(i/div);
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
		left:35,
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
            name:'慢速充电',
            type:'line',
            smooth: true,
            data: dataM
        },
		{
            name:'快速充电',
            type:'line',
            smooth: true,
            data: dataK
        }
    ]
};

	return option;

	}
