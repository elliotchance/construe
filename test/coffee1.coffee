#~ var cubes, list, math, num, number, opposite, race, square,
#~ __slice = [].slice;
# Assignment:

#~ number = 42;
number   = 42

#~ opposite = true;
opposite = true

#~ if (opposite) {
#~   number = -42;
#~ }
# Conditions:
number = -42 if opposite

#~ square = function(x) {
#~   return x * x;
#~ };
# Functions:
square = (x) -> x * x

#~ list = [1, 2, 3, 4, 5];
# Arrays:
list = [1, 2, 3, 4, 5]

#~ math = {
#~   root: Math.sqrt,
#~   square: square,
#~   cube: function(x) {
#~     return x * square(x);
#~   }
#~ };
# Objects:
math =
  root:   Math.sqrt
  square: square
  cube:   (x) -> x * square x

#~ race = function() {
#~   var runners, winner;
#~   winner = arguments[0], runners = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
#~   return print(winner, runners);
#~ };
# Splats:
race = (winner, runners...) ->
  print winner, runners

#~ if (typeof elvis !== "undefined" && elvis !== null) {
#~   alert("I knew it!");
#~ }
# Existence:
alert "I knew it!" if elvis?

#~ cubes = (function() {
#~   var _i, _len, _results;
#~   _results = [];
#~   for (_i = 0, _len = list.length; _i < _len; _i++) {
#~     num = list[_i];
#~     _results.push(math.cube(num));
#~   }
#~   return _results;
#~ })();
# Array comprehensions:
cubes = (math.cube num for num in list)
