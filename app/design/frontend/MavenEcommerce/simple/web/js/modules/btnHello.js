define(['jquery'], function ($) {
    'use strict';

    return function (config, element) {
        const heightJq = $(document).height();
        const btn = document.getElementsByClassName('btn');
        btn[0].addEventListener('click', function () {
            alert(`HELLO WORLD and ${heightJq}px`);
        })
    }
});
