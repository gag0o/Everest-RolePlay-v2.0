let roupaID = null;

$(document).ready(function() {
    let change = {}

    function openLoja() {
        $(".loja-de-roupa").fadeIn()
        $('.actions').fadeIn();
    }

    function closeLoja() {
        $(".loja-de-roupa").fadeOut()
        $('.notify').fadeOut();
        $('.container-roupas').fadeIn();
        for (let key in change) {
            if (!change[key] == 0) {
                change[key] = 0
            }
        }
        update_valor()
    }

    document.onkeydown = function(data) {
        if (data.keyCode == 27) {
            $('h1').fadeOut();
            $('.actions').fadeOut();
            $('.container-roupas').fadeOut();
            $('.notify').fadeIn(300);
        }
    }

    $("#confirmar").click(function() {
        $.post('http://gago_roupas/close', JSON.stringify({}))
    })

    $("#cancelar").click(function() {
        $('.notify').fadeOut();
        $('h1').fadeIn(300);
        $('.actions').fadeIn(300);
        $('.container-roupas').fadeIn(300);
    })

    $(".btn2").click(function() {
        let roupa = roupaID
        $.post('http://gago_roupas/next_custom', JSON.stringify({ type: roupa }));
        if (!change[roupa]) {
            change[roupa] = 1;
        } else {
            change[roupa] += 1;
        }
        update_valor()
    });

    $(".btn1").click(function() {
        let roupa = roupaID
        $.post('http://gago_roupas/anterior_custom', JSON.stringify({ type: roupaID }));
        if (!change[roupa]) {
            change[roupa] = -1;
        } else {
            change[roupa] -= 1;
        }
        update_valor()
    })

    $("#right").click(function() {
        $.post('http://gago_roupas/rotaterightheading', JSON.stringify({
            value: 10
        }));
    });

    $(".btncor").click(function() {
        $.post('http://gago_roupas/cor', JSON.stringify({ type: roupaID }));
    })


    function update_valor() {
        const formatter = new Intl.NumberFormat('pt-BR', {
            minimumFractionDigits: 2
        })
        let total = 0
        for (let key in change) {
            if (!change[key] == 0) {
                total += 40
            }
        }
        document.getElementsByClassName("total")[0].innerHTML = formatter.format(total)
        document.getElementsByClassName("totalReturn")[0].innerHTML = formatter.format(total)

    }

    $(".comprar").click(function() {
        let total = 0
        for (let key in change) {
            if (!change[key] == 0) {
                total += 40
                change[key] = 0
            }
        }
        $.post('http://gago_roupas/comprar', JSON.stringify({ preco: total }))
        update_valor()
    })


    window.addEventListener('message', function(event) {
        var item = event.data;

        if (item.openLojaRoupa == true) {
            openLoja()
        } else if (item.openLojaRoupa == false) {
            closeLoja()
        }
    })
});

function select(element) {
    roupaID = element.dataset.id;
    $(".item").css("background-color", "transparent");
    $(".item").css("border", "0");
    $(element).css("background-color", "rgba(0,0,0,0.516)");
    $(element).css("border", "1px solid #fff");
    $('.actions button').removeAttr("disabled");
}