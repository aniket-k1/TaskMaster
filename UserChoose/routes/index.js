var express = require('express');
var request = require('request');
var config = require('../config');

var witai_auth_key = config.WITAI_AUTH_KEY;

var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.get('/choose', function(req, res, next) {
	var people = [
		{
			id: 1361921,
			name: "kashav",
			tasks: [
				{
					text: 'buy three chairs from the store and deliver them to the room',
					action: 'buy',
					count: 'three',
					from: 'store',
					to: 'room',
					item: 'chairs',
					complete: 0
				},
				{
					text: 'buy eight new laptops for the school',
					action: 'buy',
					count: 'eight',
					from: 'store',
					to: 'school',
					item: 'laptops',
					complete: 0
				},
				{
					text: 'put the broom in the closet',
					action: 'put',
					count: '',
					from: '',
					to: 'closet',
					item: 'broom',
					complete: 0
				}
			]
		},
		{
			id: 1395195391,
			name: "bob",
			tasks: [
				{
					text: 'take food from the auditorium to the stadium',
					action: 'Take',
					count: '',
					from: 'auditorium',
					to: 'stadium',
					item: 'food',
					complete: 0
				},
				{
					text: 'buy food from the store',
					action: 'buy',
					count: '',
					from: 'store',
					to: '',
					item: 'food',
					complete: 0
				}
			]
		}
	];

	var actions = [];
	people.forEach(function(person, i) {
		person.tasks.forEach(function(task, j) {
			if ( typeof actions[task.action.toLowerCase()] != 'undefined' ) {
				if ( actions[task.action.toLowerCase()][person.id] != 'undefined' ) {
					actions[task.action.toLowerCase()][person.id] += 1;
				}
			} else {
				actions[task.action.toLowerCase()] = {};
				actions[task.action.toLowerCase()][person.id] = 1;
			}
		});
	});
	console.log(actions);

	function foo(things) {
		var toreturn;
		if (typeof things == 'undefined') {
			toreturn = "";
		} else {
			if (things.length > 1) {
				toreturn = [];
				for (var i = 0; i < things.length; i++) {
					toreturn.push(things[i].value);
				}
				toreturn = JSON.stringify(toreturn);
			} else {
				toreturn = things[0].value;
			}
		}
		return toreturn;
	}

	request({
		url:   'https://api.wit.ai/message?v=20150912&q=organize%20game%20for%20guests&_t=291',
		headers: {
			'Authorization' : 'Bearer ' + witai_auth_key,
		}
	}, function(error, response, body) {
		body = JSON.parse(body);
		//console.log(body);
		//console.log(body.outcomes[0].entities);

		var action = body.outcomes[0].entities.action;

		var userToReturn = Math.floor(Math.random() * people.length);
		for (var i = 0 ; i < people.length; i++) {
			if (people[i].tasks.length < people[userToReturn].tasks.length) {
				userToReturn = i;
			}
		}

		var thing = {
			text: body.outcomes[0]._text,
			action: foo(body.outcomes[0].entities.action),
			count: foo(body.outcomes[0].entities.count),
			from: foo(body.outcomes[0].entities.from),
			to: foo(body.outcomes[0].entities.to),
			item: foo(body.outcomes[0].entities.item),
			complete: 0
		}
		people[userToReturn].tasks.push(thing);
		//console.log(people[userToReturn]);
	});

	res.send('abc');
})

module.exports = router;
