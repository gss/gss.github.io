"use strict";

var grunt = require('grunt');
var fs = require('fs');

exports.combine = {
    single: function (test) {
		test.done();
        fs.readFile('./outputs/output_a', 'utf8', function (e, data) {
            test.equal(data,"The quick brown fox jumped over the lazy dog.");
            test.done();
        });
    },
    multiple: function (test) {
		test.done();
    }
};
