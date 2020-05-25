import 'dart:math';

/// Takes two Matrix3s, a and b, and computes the product in the order
/// that pre-composes b with a.  In other words, the matrix returned will
/// a A matrix.
/// b A matrix.
List<num> multiply(List<num> a, List<num> b) {
  final a00 = a[0 * 3 + 0];
  final a01 = a[0 * 3 + 1];
  final a02 = a[0 * 3 + 2];
  final a10 = a[1 * 3 + 0];
  final a11 = a[1 * 3 + 1];
  final a12 = a[1 * 3 + 2];
  final a20 = a[2 * 3 + 0];
  final a21 = a[2 * 3 + 1];
  final a22 = a[2 * 3 + 2];
  final b00 = b[0 * 3 + 0];
  final b01 = b[0 * 3 + 1];
  final b02 = b[0 * 3 + 2];
  final b10 = b[1 * 3 + 0];
  final b11 = b[1 * 3 + 1];
  final b12 = b[1 * 3 + 2];
  final b20 = b[2 * 3 + 0];
  final b21 = b[2 * 3 + 1];
  final b22 = b[2 * 3 + 2];

  return [
    b00 * a00 + b01 * a10 + b02 * a20,
    b00 * a01 + b01 * a11 + b02 * a21,
    b00 * a02 + b01 * a12 + b02 * a22,
    b10 * a00 + b11 * a10 + b12 * a20,
    b10 * a01 + b11 * a11 + b12 * a21,
    b10 * a02 + b11 * a12 + b12 * a22,
    b20 * a00 + b21 * a10 + b22 * a20,
    b20 * a01 + b21 * a11 + b22 * a21,
    b20 * a02 + b21 * a12 + b22 * a22,
  ];
}


/// Creates a 3x3 identity matrix
List<int> identity() {
  return [
    1, 0, 0,
    0, 1, 0,
    0, 0, 1,
  ];
}

/// Creates a 2D projection matrix
/// width width in pixels
/// height height in pixels
List<num> projection(num width, num height) {
  // Note: This matrix flips the Y axis so 0 is at the top.
  return [
    2 / width, 0, 0,
    0, -2 / height, 0,
    -1, 1, 1,
  ];
}

/// Multiplies by a 2D projection matrix
/// m the matrix to be multiplied
/// width width in pixels
/// height height in pixels
List<num> project(List<num> m, num width, num height) {
  return multiply(m, projection(width, height));
}

/// Creates a 2D translation matrix
/// tx amount to translate in x
/// ty amount to translate in y
List<num> translation(num tx, num ty) {
  return [
    1, 0, 0,
    0, 1, 0,
    tx, ty, 1,
  ];
}

/// Multiplies by a 2D translation matrix
/// m the matrix to be multiplied
/// tx amount to translate in x
/// ty amount to translate in y
List<num> translate(List<num> m, num tx, num ty) {
  return multiply(m, translation(tx, ty));
}

/// Creates a 2D rotation matrix
/// angleInRadians amount to rotate in radians
List<num> rotation(num angleInRadians) {
  var c = cos(angleInRadians);
  var s = sin(angleInRadians);
  return [
    c, -s, 0,
    s, c, 0,
    0, 0, 1,
  ];
}

/// Multiplies by a 2D rotation matrix
/// m the matrix to be multiplied
/// angleInRadians amount to rotate in radians
List<num> rotate(List<num> m, num angleInRadians) {
  return multiply(m, rotation(angleInRadians));
}

/// Creates a 2D scaling matrix
/// sx amount to scale in x
/// sy amount to scale in y
List<num> scaling(num sx, num sy) {
  return [
    sx, 0, 0,
    0, sy, 0,
    0, 0, 1,
  ];
}

/// Multiplies by a 2D scaling matrix
/// m the matrix to be multiplied
/// sx amount to scale in x
/// sy amount to scale in y
List<num> scale(List<num> m, num sx, num sy) {
  return multiply(m, scaling(sx, sy));
}

num dot(num x1, num y1, num x2, num y2) {
  return x1 * x2 + y1 * y2;
}

num distance(num x1, num y1, num x2, num y2) {
  var dx = x1 - x2;
  var dy = y1 - y2;
  return sqrt(dx * dx + dy * dy);
}

List<num> normalize(num x, num y) {
  var l = distance(0, 0, x, y);
  if (l > 0.00001) {
    return [x / l, y / l];
  } else {
    return [0, 0];
  }
}

// i = incident
// n = normal
List<num> reflect(num ix, num iy, num nx, num ny) {
  // I - 2.0 * dot(N, I) * N.
  var d = dot(nx, ny, ix, iy);
  return [
    ix - 2 * d * nx,
    iy - 2 * d * ny,
  ];
}

num radToDeg(num r) {
  return r * 180 / pi;
}

num degToRad(num d) {
  return d * pi / 180;
}

List<num> transformPoint(List<num> m, List<num> v) {
  final v0 = v[0];
  final v1 = v[1];
  final d = v0 * m[0 * 3 + 2] + v1 * m[1 * 3 + 2] + m[2 * 3 + 2];
  return [
    (v0 * m[0 * 3 + 0] + v1 * m[1 * 3 + 0] + m[2 * 3 + 0]) / d,
    (v0 * m[0 * 3 + 1] + v1 * m[1 * 3 + 1] + m[2 * 3 + 1]) / d,
  ];
}

List<num> inverse(List<num> m) {
  var t00 = m[1 * 3 + 1] * m[2 * 3 + 2] - m[1 * 3 + 2] * m[2 * 3 + 1];
  var t10 = m[0 * 3 + 1] * m[2 * 3 + 2] - m[0 * 3 + 2] * m[2 * 3 + 1];
  var t20 = m[0 * 3 + 1] * m[1 * 3 + 2] - m[0 * 3 + 2] * m[1 * 3 + 1];
  var d = 1.0 / (m[0 * 3 + 0] * t00 - m[1 * 3 + 0] * t10 + m[2 * 3 + 0] * t20);
  return [
    d * t00, -d * t10, d * t20,
    -d * (m[1 * 3 + 0] * m[2 * 3 + 2] - m[1 * 3 + 2] * m[2 * 3 + 0]),
    d * (m[0 * 3 + 0] * m[2 * 3 + 2] - m[0 * 3 + 2] * m[2 * 3 + 0]),
    -d * (m[0 * 3 + 0] * m[1 * 3 + 2] - m[0 * 3 + 2] * m[1 * 3 + 0]),
    d * (m[1 * 3 + 0] * m[2 * 3 + 1] - m[1 * 3 + 1] * m[2 * 3 + 0]),
    -d * (m[0 * 3 + 0] * m[2 * 3 + 1] - m[0 * 3 + 1] * m[2 * 3 + 0]),
    d * (m[0 * 3 + 0] * m[1 * 3 + 1] - m[0 * 3 + 1] * m[1 * 3 + 0]),
  ];
}
