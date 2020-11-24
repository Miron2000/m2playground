/**
 * Copyright © 2020 Studio Raz. All rights reserved.
 * See LICENSE.txt for license details.
 */

define([
    'ko',
    'uiComponent',
    'jquery'
], function (ko, Component, $) {
    'use strict';

    return Component.extend({
        /**
         * @override
         */
        initialize: function () {
            this._super();

            this.items = ko.observableArray(this.getItems());
            this.isVisible = ko.observable(this.getIsVisible());

            setInterval(function () {
                this.items(this.getItems());
            }.bind(this), 2000);
        },

        /**
         * @return {Array}
         */
        getItems: function () {
            return [
                {
                    name: 'foo',
                    id: this.getRandomNumber()
                },
                {
                    name: 'bar',
                    id: this.getRandomNumber()
                },
                {
                    name: 'baz',
                    id: this.getRandomNumber()
                }
            ];
        },

        //Добавление в массив
        addMessage:function (){
            this.items.push({name:' mir', id: this.getRandomNumber()});
        },

        /**
         * @return {Boolean}
         */
        getIsVisible: function () {
            return true;
        },

        /**
         * @return {Number}
         */
        getRandomNumber: function () {
            return Math.ceil(Math.random() * 10);
        }
    });
});
