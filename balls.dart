import 'dart:html';
import 'dart:isolate';
import 'dart:math';

part 'color.dart';
part 'random.dart';

// based on http://www.efeion.com/canvastest/balls1.js

class Circle {
  static const int ballCount = 32;

  num x;
  num y;
  num r;

  num dx;
  num dy;

  CanvasElement canvas;
  CanvasRenderingContext2D context;

  String colorCode;

  Circle(this.x, this.y,this.r) {
    dx = randomDouble(7.0);
    dy = randomDouble(7.0);

    canvas = document.query('#canvas');
    context = canvas.getContext('2d');

    colorCode = randomColorCode();
  }

  draw() {
    context.beginPath();
    context.fillStyle = colorCode;
    context.arc(this.x, this.y, this.r, 0, PI * 2, true);
    context.closePath();
    context.fill();
  }

  move() {
    x += dx;
    y += dy;
    if (x > canvas.width || x < 0) dx = -dx;
    if (y > canvas.height || y < 0) dy = -dy;
  }

  onKeyDown(evt) {
    if (evt.keyCode == 39) { dx > 0 ? dx : dx = -dx;        // right
    } else if (evt.keyCode == 37) dx < 0 ? dx : dx = -dx;   // left
  }

}

draw(context, balls) {
  clear() {
    context.fillStyle = "#ffffff";
    context.fillRect(0, 0, context.canvas.width, context.canvas.height);
  }
  clear();
  var i;
  for (var i = 0; i <balls.length; i++) {
    balls[i].move();
    balls[i].draw();
  }
}

main() {
  CanvasElement canvas = document.query('#canvas');
  CanvasRenderingContext2D context = canvas.getContext('2d');
  var width = canvas.width;
  var height = canvas.height;
  var ballCount = Circle.ballCount;
  var balls = new List(ballCount);
  for (var i = 0; i < ballCount; i++) {
    var ball =
        new Circle(width/2, height/2, randomDouble((ballCount * 2).toDouble()));
    balls[i] = ball;
    document.on.keyDown.add(ball.onKeyDown);
  }
  // Redraw every ballCount ms.
  new Timer.repeating(ballCount < 20 ? ballCount : ballCount - 16,
      (t) => draw(context, balls));
}


