import 'dart:html';
import 'world.dart';

world tw;

InputElement zoomRange;
InputElement xRange;
InputElement yRange;
InputElement heightRange;
InputElement worldSizeRange;

InputElement regenButton;
InputElement addPeaksButton;
InputElement growBeachesButton;
InputElement flattenWorldButton;
InputElement invertWorldButton;
InputElement erodeWorldButton;
InputElement erodeRandWorldButton;
InputElement flipNSButton;
InputElement flipEWButton;

void main() {

  CanvasElement ce = querySelector('#surface');

  CanvasRenderingContext2D c2d = ce.getContext("2d");

  tw = new world(c2d)
        ..generateWorld()
        ..draw(null);

  heightRange = querySelector('#HeightScale')
      ..onChange.listen(Draw);

  regenButton = querySelector('#regenButton')
      ..onClick.listen(Regenerate);

  addPeaksButton = querySelector('#addPeaksButton')
      ..onClick.listen(AddPeaks);

  worldSizeRange = querySelector('#WorldSize')
      ..onChange.listen(Resize);

  zoomRange = querySelector('#Zoom')
      ..onChange.listen(Zoom);

  xRange = querySelector('#WorldX')
      ..onChange.listen(Move);

  yRange = querySelector('#WorldY')
      ..onChange.listen(Move);

  growBeachesButton = querySelector('#growBeachesButton')
      ..onClick.listen(GrowBeaches);

  flattenWorldButton = querySelector('#flattenWorldButton')
      ..onClick.listen(FlattenWorld);

  invertWorldButton = querySelector('#invertWorldButton')
      ..onClick.listen(InvertWorld);

  erodeWorldButton = querySelector('#erodeWorldButton')
      ..onClick.listen(ErodeWorld);

  erodeRandWorldButton = querySelector('#erodeRandWorldButton')
      ..onClick.listen(ErodeWorldRandom);

  flipNSButton = querySelector('#flipNSButton')
      ..onClick.listen(FlipWorldNS);

  flipEWButton = querySelector('#flipEWButton')
      ..onClick.listen(FlipWorldEW);

  print("main ${heightRange.value}");
}

Move(e){
  tw.setWorldPos(xRange.valueAsNumber.toInt(),yRange.valueAsNumber.toInt());
  Draw(null);
}

Regenerate(e){
  print("Regenerate");
  tw..resetWorld()
    ..generateWorld();
  Draw(null);
}
AddPeaks(e){
  tw.addPeaks();
  Draw(null);
}

InvertWorld(e){
  tw.invertWorld();
  Draw(null);
}

FlattenWorld(e){
  tw.flatWorld();
  Draw(null);
}

GrowBeaches(e){
  print("GB");
  tw.growLevel(2);
  Draw(null);
}

ErodeWorld(e){
  print("Erode");
  tw.erodeWorld();
  Draw(null);
}

ErodeWorldRandom(e){
  print("Erode Random");
  tw.erodeWorldRandom();
  Draw(null);
}

Zoom(e){
  print("Zoom");
  tw.setZoom(zoomRange.valueAsNumber.toInt());
  Draw(null);
}

Resize(e){
  InputElement worldSizeRange = querySelector('#WorldSize');
  tw.setWorldSize( worldSizeRange.valueAsNumber.toInt());
  Regenerate(e);
}

Draw(e){
  print("DRAW");

  // Get values from controls.
  InputElement heightRange = querySelector('#HeightScale');

  tw.HeightScale = heightRange.valueAsNumber.toInt();
  tw.draw(null);
  print("pop ${tw.HeightScale}");
}

FlipWorldEW(e){
  tw.flip("EW");
  tw.draw(null);
}

FlipWorldNS(e){
  tw.flip("NS");
  tw.draw(null);
}
