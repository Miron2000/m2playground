define(['jquery'], function ($) {
    'use strict'
    console.log('Hello')
    return function (config, element) {
        console.log(element, 'DIV');//мой Див с id=selector
        console.log(config, 'CONFIG');//мой обьект config.label
        let hour = new Date().getHours();
            console.log(hour)
        if (hour >= 6 && hour <= 12) {

            return $(element).html(`<h1>${config.label1} - <span>it's time is ${hour} o'clock</span></h1> `);

        } else if (hour > 12 && hour <= 18) {

            return $(element).html(`<h1>${config.label2} - <span>it's time is ${hour} o'clock</span></h1> `);

        } else if (hour > 18 && hour <= 24) {

            return $(element).html(`<h1>${config.label3} - <span>it's time is ${hour} o'clock</span></h1> `);

        }
    }
});
