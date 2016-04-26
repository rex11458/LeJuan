/**
 * modal dialog
 * author: ivan
 */
window.dialog = window.dialog || (function init($, undefined) {
  
	var templates = {
   	 	dialog:
			'<div class="modal fade" tabindex="-1" data-backdrop="static" data-keyboard="false">\
				<div class="modal-body">\
				</div>\
				<div class="modal-footer">\
				</div>\
			</div>',
    	header:
      		'<div class="modal-header">\
        		<h4 class="modal-title"></h4>\
      		</div>',
    	buttons:{
    		cancel:'<button type="button" class="btn btn-default cancel">取消</button>',
    		ok:'<button type="button" class="btn blue ok">确定</button>'
    	},
    	text:'<textarea  maxlength="200" class="form-control" rows="3">{0}</textarea>'     
	};
	  
  	var dialog = {};
  
	dialog.confirm = function(tip,	callback){
		var $modal = $(templates.dialog);
		$modal.find(".modal-body").html(tip);
		$modal.find('.modal-footer').append(templates.buttons.cancel).append(templates.buttons.ok);
		
		$modal.on('click','.cancel',function(){
			$modal.modal('hide');
			callback(false); 
		});
		
		$modal.on('click','.ok',function(){
			$modal.modal('hide');
			callback(true);
		});		
				 
		$modal.modal('show');  	
	}
	
	dialog.alert = function(tip, callback){
		var $modal = $(templates.dialog);
		$modal.find(".modal-body").html(tip);
		$modal.find('.modal-footer').append(templates.buttons.ok);
		
		$modal.on('click','.ok',function(){
			$modal.modal('hide');
			if(callback){
				callback();
			}
		});		
				 
		$modal.modal('show');  	
	};
	
	/*
	 * options:{
	 * 	title:'',
	 * 	content: '' || function,
	 *  confirm: true or false, 确认模式都会触发回调事件
	 * 	init: function,
	 *  result: function, get customer val
	 * }
	 */
	dialog.prompt = function(options,callback){
		var $modal = $(templates.dialog);
		var $header = $(templates.header);
		
		if(typeof options == "string"){
			$header.find(".modal-title").html(options);
			$modal.find(".modal-body").html(templates.text.replace("{0}",""));
		} else {
			$header.find(".modal-title").html(options.title);
			$modal.find(".modal-body").html( templates.text.replace("{0}", typeof options.content == "string" ? options.content : options.content()) );
			if (options.init != null) 
				options.init($modal);
		}
			
		$header.insertBefore($modal.find(".modal-body"));
			
		$modal.find('.modal-footer').append(templates.buttons.cancel).append(templates.buttons.ok);
		
		$modal.on('click','.cancel',function(){
			$modal.modal('hide');
			options.confirm && callback("", false);
		});
		
		$modal.on('click','.ok',function(){
			var result;
			if(options.result != null)
				result = options.result($modal);
			else
				result = $(this).parent().prev().find("textarea").val().trim();
				
			if(result){
				$modal.modal('hide');
				callback(result, true);
			}
		});		
				 
		$modal.modal('show'); 	
	};

  	return dialog;

}(window.jQuery));
