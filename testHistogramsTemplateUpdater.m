function test_suite = testHistogramsTemplateUpdater
initTestSuite;

function histogramFactory = setup
histogramFactory = IntegralHistogramFactory(GrayHistogramStrategy(2));

function testUpdatesHistogramsOfAMovedObjectByUsingTheNextFrame(histogramFactory)
movedObject = TrackedObjectPosition({Patch(GrayHistogram([0; 1]), Area.fromXYtoXY(10, 10, 12, 12))});
nextFrame = zeros(20, 20); 
nextFrame(10:12, 10:12) = ones(3, 3) * 255; %something interesting in the area
newHistograms = histogramFactory.buildFromImage(nextFrame);

updater = HistogramsTemplateUpdater(AlwaysUpdatedAcceptanceStrategy());
newObject = updater.updateTemplate(movedObject, newHistograms);
assertEqual(Area.fromXYtoXY(10, 10, 12, 12), newObject.patches{1}.area);
assertEqual(GrayHistogram([0; 9]), newObject.patches{1}.histogram);

function testDoesNotUpdatePatchesWhichAreOccluded(histogramFactory)
updater = HistogramsTemplateUpdater(MaximumDistanceAcceptanceStrategy(SimpleComparator(), 0.1));
movedObject = TrackedObjectPosition({Patch(GrayHistogram([1; 0]), Area.fromXYtoXY(10, 10, 12, 12))});
nextFrame = zeros(20, 20); 
nextFrame(10:12, 10:12) = ones(3, 3) * 255; %something very different in the area: likely to be an occlusion
newHistograms = histogramFactory.buildFromImage(nextFrame);

newObject = updater.updateTemplate(movedObject, newHistograms);
assertEqual(Area.fromXYtoXY(10, 10, 12, 12), newObject.patches{1}.area);
assertEqual(GrayHistogram([1; 0]), newObject.patches{1}.histogram);
