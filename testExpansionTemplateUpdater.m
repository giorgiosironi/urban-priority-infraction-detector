function test_suite = testExpansionTemplateUpdater
initTestSuite;

function histogramFactory = setup
histogramFactory = IntegralHistogramFactory(GrayHistogramStrategy(2));

function testExpandTemplateToAccomodateNewPatchesOfEnteringObjects(histogramFactory)
objects = {TrackedObjectPosition({Patch(NaN, Area.fromXYtoXY(3, 3, 4, 4))})};
updater = ExpansionTemplateUpdater(ForegroundValidityStrategy(10));

nextFrame = zeros(6);
nextFrame(3:4, 1:2) = [0 255; 255 255];
newHistograms = histogramFactory.buildFromImage(nextFrame);
foreground = ones(6) * -1;
foreground(3:4, 1:4) = 1;

objects = updater.updateTemplate(objects, Frame(foreground), newHistograms);
expansion = objects{1}.patches{2};
assertEqual(Area.fromXYtoXY(3, 1, 4, 2), expansion.area);
assertEqual(GrayHistogram([1; 3]), expansion.histogram);