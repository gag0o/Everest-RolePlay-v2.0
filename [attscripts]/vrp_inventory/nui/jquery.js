$(document).ready(function(){
	let actionContainer = $("#actionmenu");

	window.addEventListener("message",function(event){
		let item = event.data;
		switch(item.action){
			case "showMenu":
				updateMochila();
				actionContainer.fadeIn(500);
			break;

			case "hideMenu":
				actionContainer.fadeOut(500);
			break;

			case "updateMochila":
				updateMochila();
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_inventory/invClose");
		}
	};
});

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}

var isText = '<titulo>MOCHILA</titulo>O sistema encontra-se em desenvolvimento, qualquer atualização você pode encontrar em <b>#changelog</b> no discord.<br><br>Qualquer sugestão, dúvidas e problemas fale diretamente com um membro da administração ou procure outro jogador.';

const updateMochila = () => {
	$("#desc").html(isText);
	$.post("http://vrp_inventory/requestMochila",JSON.stringify({}),(data) => {
		const nameList = data.inventario.sort((a,b) => (a.name > b.name) ? 1: -1);
		$('#invleft').html(`
			<div class="peso"><b>OCUPADO:</b>  ${(data.peso).toFixed(2)}    <s>|</s>    <b>LIVRE:</b>  ${(data.maxpeso-data.peso).toFixed(2)}    <s>|</s>    <b>TAMANHO:</b>  ${(data.maxpeso).toFixed(2)}</div>
			${nameList.map((item) => (`
				<div class="item" style="background-image: url('images/${item.index}.png');" data-item-key="${item.key}" data-item-type="${item.type}" data-name-key="${item.name}" data-desc-key="${item.desc}">
					<div id="peso">${(item.peso*item.amount).toFixed(2)}</div>
					<div id="quantity">${formatarNumero(item.amount)}x</div>
					<div id="itemname">${item.name}</div>
				</div>
			`)).join('')}
		`);
	});
}

$(document).on("click",".item",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.item').removeClass('active');
	if(!isActive){
		$el.addClass('active');
		$("#desc").html('<titulo>'+$el.attr('data-name-key').toUpperCase()+'</titulo>'+$el.attr('data-desc-key'));
	} else {
		$("#desc").html(isText);
	}
});

$(document).on("click",".dropar",function(){
	let $el = $('.item.active');
	let amount = Number($('#amount').val());
	if($el && amount > 0) {
		$.post("http://vrp_inventory/dropItem",JSON.stringify({
			item: $el.attr('data-item-key'),
			amount
		}));
	} else if($el) {
		$.post("http://vrp_inventory/dropItem",JSON.stringify({
			item: $el.attr('data-item-key')
		}));
	}
});

$(document).on("click",".enviar",function(){
	let $el = $('.item.active');
	let amount = Number($('#amount').val());
	if($el && amount > 0) {
		$.post("http://vrp_inventory/sendItem",JSON.stringify({
			item: $el.attr('data-item-key'),
			amount
		}));
	} else if($el) {
		$.post("http://vrp_inventory/sendItem",JSON.stringify({
			item: $el.attr('data-item-key')
		}));
	}
})

$(document).on("click",".usar",function(){
	let $el = $('.item.active');
	let amount = Number($('#amount').val());
	if($el) {
		$.post("http://vrp_inventory/useItem",JSON.stringify({
			item: $el.attr('data-item-key'),
			type: $el.attr('data-item-type'),
			amount
		}));
	}
})