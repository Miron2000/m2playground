define([
        "jquery",
        "swiper"
    ],
    function ($, Swiper) {
        "use strict";

        //complete look
        var swiper = new Swiper('.swiper-container', {
            slidesPerView: 'auto',
            spaceBetween: 10,
            freeMode: true,
            breakpoints: {
                1024: {
                    slidesPerView: 4,
                    spaceBetween: 40,
                },
                768: {
                    slidesPerView: 3,
                    spaceBetween: 30,
                },
                470: {
                    slidesPerView: 2,
                    spaceBetween: 10,
                }
            }
        })
        console.log(swiper, 'SWIPER');

    });
