
//自定义验证方法，提交时会调用
function customValidation() {
	valideResultDate();
	valideResultTime();
}

function valideResultDate(){
	
	var dt = $("[name=q_2912]:checked").attr("id");
	var resultDate = $("#resultDate").val();
	
	if(!dt || !resultDate) return;
	
	var dayType = {
			"2912_0_9279": "workday",
			"2912_0_9280": "weekend"
	};
	
	var day = new Date(resultDate.replace(/-/gi,'/')).getDay();
	
	if(dayType[dt] == "workday"){
		if(!(day >= 1 && day <= 5)){
			Paper.setValidationResult($("#resultDate"), "必须为工作日");
		}
	} else {
		if(day != 0 && day != 6){
			Paper.setValidationResult($("#resultDate"), "必须为双休日");
		}
	}
	
}

function valideResultTime(){
	
	var startTime = $("#startDate").val();
	var endTime = $("#endDate").val();
	var tp = $("[name=q_2913]:checked").attr("id");
	
	if(!tp) return;
	
	var timePeriod = {
			"2913_0_9281": {
				"start": "09:00",
				"end": "11:00"
			},
			"2913_0_9282": {
				"start": "11:00",
				"end": "14:00"
			},
			"2913_0_9283": {
				"start": "14:00",
				"end": "17:00"
			},
			"2913_0_9284": {
				"start": "17:00",
				"end": "19:30"
			}
	};
	
	var start = timePeriod[tp].start,
		end	= timePeriod[tp].end;
	
	if(startTime && !(startTime >= start && startTime <= end)){
		Paper.setValidationResult($("#startDate"), "必须在"+start+"~"+end);
	}
	/*
	if(endTime && !(endTime >= start && endTime <= end)){
		Paper.setValidationResult($("#endDate"), "必须在"+start+"~"+end);
	}
	*/
	
}


