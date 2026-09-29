(function(){
    var head = document.getElementById('masthead');
    var glitch = function() {
        head.classList.toggle('pause');
        var rand = Math.floor(Math.random() * 8) + 3;
        setTimeout(glitch, rand * 100);
    }
    glitch();
})();
