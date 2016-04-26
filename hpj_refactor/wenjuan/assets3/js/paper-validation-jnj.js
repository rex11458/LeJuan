
//自定义验证方法，提交时会调用
function customValidation() {
	$("[id$=_2063],[id$=_2150],[id$=_2151],[id$=_2152],[id$=_2125],[id$=_2153]").change();
}

$(function(){
	
	var vSelector = {
			2062: "2063", 
			2063: "2062",
			2065: "2150",
			2150: "2065",
			2066: "2151",
			2151: "2066",
			2067: "2152", 
			2152: "2067",
			2124: "2125",
			2125: "2124",
			2105: "2153",
			2153: "2105"
	};

	//开始时间验证
	$("[id$=_2062],[id$=_2065],[id$=_2066],[id$=_2067],[id$=_2124],[id$=_2105]").change(function(e){
		
		var $e = $(this), val = $e.val(), errorMsg = "";
		
		if(val){
			var arr = this.id.split("_");
			var valEnd = $("#"+arr[0]+"_"+arr[1]+"_"+vSelector[arr[2]]).val();
			if(valEnd && val > valEnd){
				 errorMsg = "不能大于结束时间";
			}
		}
		
		Paper.setValidationResult($e, errorMsg);
		
        e.stopPropagation();
        e.preventDefault();		
		
	});
	
	//结束时间验证
	$("[id$=_2063],[id$=_2150],[id$=_2151],[id$=_2152],[id$=_2125],[id$=_2153]").change(function(e){
		
		var $e = $(this), val = $e.val(), errorMsg = "";
		
		if(val){
			var arr = this.id.split("_");
			var valStart = $("#"+arr[0]+"_"+arr[1]+"_"+vSelector[arr[2]]).val();
			if(valStart && val < valStart){
				 errorMsg = "不能小于开始时间";
			}
		}
		
		Paper.setValidationResult($e, errorMsg);
		
        e.stopPropagation();
        e.preventDefault();		
		
	});	
	
});


