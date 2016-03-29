library isoland;

import 'dart:math';
import 'dart:html';

/***
 *
 * Defines a simple world class of a 2D grid with height maps.
 * Isometric perspective used to render.
 *
 */
class world {
  int HeightScale = 10;

  CanvasRenderingContext2D _ctx;
  List<List<int>> _mapdata;
  int _width = 22;
  int _height = 22;
  int _tilewidth = 10;
  int _ox = 170;
  int _oy = 200;

  List<String> ca = new List.filled(10, "");
  List<String> cae = new List.filled(10, "");
  List<String> cas = new List.filled(10, "");
  Random _rng = new Random(new DateTime.now().millisecondsSinceEpoch);

  world(this._ctx) {
    resetWorld();
    setNormalPalette();
  }

  void setNormalPalette() {
    ca[0] = '#333377';
    cae[0] = '#331700';
    cas[0] = '#330100';
    ca[1] = '#aabb00';
    cae[1] = '#aaa600';
    cas[1] = '#aab000';
    ca[2] = '#007700';
    cae[2] = '#006100';
    cas[2] = '#004500';
    ca[3] = '#009900';
    cae[3] = '#008300';
    cas[3] = '#006700';
    ca[4] = '#00AA00';
    cae[4] = '#009400';
    cas[4] = '#007800';
    ca[5] = '#00BB00';
    cae[5] = '#00a600';
    cas[5] = '#008900';
    ca[6] = '#00CC00';
    cae[6] = '#00b000';
    cas[6] = '#00A000';
    ca[7] = '#00DD00';
    cae[7] = '#00c800';
    cas[7] = '#00AE00';
    ca[8] = '#00f900';
    cae[8] = '#00d900';
    cas[8] = '#00B900';
    ca[9] = '#FFFFFF';
    cae[9] = '#444444';
    cas[9] = '#333333';
  }

  void resetWorld() {
    _mapdata = new List<List<int>>();

    for (int i = 0; i < _width; i++)
      _mapdata.add(new List<int>.filled(_height, 0));

    print(_mapdata[0][0]);
    print(_mapdata[7][7]);
  }

  void flatWorld() {
    for (int x = 0; x < _width; x++)
      for (int y = 0; y < _height; y++) _mapdata[x][y] = 0;
  }

  void invertWorld() {
    int h = 0;
    for (int x = 0; x < _width; x++)
      for (int y = 0; y < _height; y++) {
      h = _mapdata[x][y];
      if (h > 0) {
        _mapdata[x][y] = 9 - h;
      }
    }
  }

  void draw(e) {
    int w = _tilewidth;
    int hw = (_tilewidth ~/ 2);

    int ocx = 0;
    int ocy = 0;
    int hh = 0;
    int h = 0;
    _ctx.clearRect(0, 0, 9999, 9999);
    _ctx.strokeStyle = '#333333';
    for (int y = 0; y < _height; y++)
      for (int x = _width - 1; x > -1; x--) {
      h = _mapdata[x][y];
      hh = (h * HeightScale);
      ocx = _ox + (x * w) + (y * w);
      ocy = ((_oy + (y * hw)) - (x * hw)) - (hh);

      _ctx
        ..beginPath()
        ..fillStyle = ca[h]
        ..moveTo(ocx, ocy)
        ..lineTo(ocx + w, ocy - hw)
        ..lineTo(ocx + w + w, ocy)
        ..lineTo(ocx + w, ocy + hw)
        ..closePath()
        ..fill()
        ..stroke()
        ..beginPath()
        ..fillStyle = cae[h]
        ..moveTo(ocx, ocy)
        ..lineTo(ocx, ocy + hh)
        ..lineTo(ocx + w, ocy + hw + hh)
        ..lineTo(ocx + w, ocy + hw)
        ..closePath()
        ..fill()
        ..stroke()
        ..beginPath()
        ..fillStyle = cas[h]
        ..moveTo(ocx + w, ocy + hw)
        ..lineTo(ocx + w, ocy + hw + hh)
        ..lineTo(ocx + w + w, ocy + hh)
        ..lineTo(ocx + w + w, ocy)
        ..closePath()
        ..fill()
        ..stroke();
    }
  }

  void generateWorld() {
    addTerrain((_width * 0.495).toInt());
  }

  void addPeaks() {
    addTerrain((_width * 0.1).toInt());
  }

  void growLevel(int level) {
    for (int x = 0; x < _width; x++)
      for (int y = 0; y < _height; y++) {
      if (_mapdata[x][y] == level) {
        drawPoint(x, y, level);
      }
    }
  }

  void addTerrain(int iterations) {
    for (int i = 0; i < iterations; i++) {
      int spx = _rng.nextInt(_width);
      int spy = _rng.nextInt(_height);
      int height = _rng.nextInt(10);

      drawPoint(spx + 1, spy + 1, height);
      drawPoint(spx - 1, spy - 1, height);
      drawPoint(spx - 1, spy, height);
      drawPoint(spx, spy, height);
      drawPoint(spx + 1, spy, height);
      drawPoint(spx + 1, spy - 1, height);
      drawPoint(spx, spy + 1, height);
      drawPoint(spx - 1, spy + 1, height);
      drawPoint(spx, spy - 1, height);
    }
  }

  void drawPoint(int x, int y, int c) {
    try {
      if (c > _mapdata[x][y]) _mapdata[x][y] = c;
    } catch (e) {
      return;
    } //Nasty but..
    c--;
    if (c > 0) {
      if (Vary2()) drawPoint(x + 1, y - 1, c);
      if (Vary2()) drawPoint(x, y - 1, c);
      if (Vary2()) drawPoint(x - 1, y - 1, c);

      if (Vary2()) drawPoint(x - 1, y, c);
      if (Vary2()) drawPoint(x, y, c);
      if (Vary2()) drawPoint(x + 1, y, c);

      if (Vary2()) drawPoint(x + 1, y + 1, c);
      if (Vary2()) drawPoint(x, y + 1, c);
      if (Vary2()) drawPoint(x - 1, y + 1, c);
    }
  }

  bool Vary2() {
    return _rng.nextInt(5) == 1;
  }

  void setWorldSize(int i) {
    _width = i;
    _height = i;
  }

  void setZoom(int i) {
    _tilewidth = i;
  }

  void setWorldPos(int i, int j) {
    _ox = i;
    _oy = j;
  }

  void erodeWorld() {
    for (int x = 0; x < _width; x++)
      for (int y = 0; y < _height; y++) {
      if (_mapdata[x][y] > 4) _mapdata[x][y] -= 1;
    }
  }

  void erodeWorldRandom() {
    for (int x = 0; x < _width; x++)
      for (int y = 0; y < _height; y++) {
      if (_mapdata[x][y] > 0 && _rng.nextInt(2) == 1) _mapdata[x][y] -= 1;
    }
  }

  void flip(String s) {
    if (s == "ns") {
      for (int x = 0; x < _width; x++)
        _mapdata[x] = new List.from(_mapdata[x].reversed);
    } else {
      _mapdata = new List.from(_mapdata.reversed);
    }
  }
}
