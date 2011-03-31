function test_suite = testExpansionTemplateUpdater
initTestSuite;

function histogramFactory = setup
histogramFactory = IntegralHistogramFactory(GrayHistogramStrategy(2));

function testExpandsTemplateToAccomodateNewPatchesOfEnteringObjects(histogramFactory)
objects = {ObjectSighting({Patch(NaN, Area.fromXYtoXY(3, 3, 4, 4))})};
updater = ExpansionTemplateUpdater(ForegroundValidityStrategy(10));

nextFrame = zeros(6);
nextFrame(3:4, 1:2) = [0 255; 255 255];
newHistograms = histogramFactory.buildFromImage(nextFrame);
foreground = ones(6) * -1;
foreground(3:4, 1:4) = 1;

objects = updater.updateTemplate(objects, Frame(foreground), newHistograms, {});
assertEqual([2 1], size(objects{1}.patches));
expansion = objects{1}.patches{2};
assertEqual(Area.fromXYtoXY(3, 1, 4, 2), expansion.area);
assertEqual(GrayHistogram([1; 3]), expansion.histogram);

function testIntroducesNewObjectsForModellingPatchesWhichDoNotFitWithCurrentOnes(histogramFactory)
objects = {};
updater = ExpansionTemplateUpdater(ForegroundValidityStrategy(10));

nextFrame = zeros(6);
nextFrame(3:4, 1:2) = [0 255; 255 255];
newHistograms = histogramFactory.buildFromImage(nextFrame);
foreground = ones(6) * -1;
foreground(3:4, 1:4) = 1;
foregroundObjects = {ObjectSighting({Patch(NaN, Area.fromXYtoXY(3, 1, 4, 2)); Patch(NaN, Area.fromXYtoXY(3, 3, 4, 4))})};

objects = updater.updateTemplate(objects, Frame(foreground), newHistograms, foregroundObjects);
assertEqual([1 1], size(objects));
assertEqual([2 1], size(objects{1}.patches));

function testExcludesNewlyDetectedObjectsWhichAreAlreadyTracked(histogramFactory)
objects = {ObjectSighting({Patch(NaN, Area.fromXYtoXY(3, 3, 4, 4))})};
updater = ExpansionTemplateUpdater(ForegroundValidityStrategy(10));

nextFrame = zeros(6);
newHistograms = histogramFactory.buildFromImage(nextFrame);
foreground = ones(6) * -1;
foregroundObjects = {ObjectSighting({Patch(NaN, Area.fromXYtoXY(3, 3, 4, 4))})};

objects = updater.updateTemplate(objects, Frame(foreground), newHistograms, foregroundObjects);
assertEqual([1 1], size(objects));
assertEqual([1 1], size(objects{1}.patches));

function testDoesNotIncludePatchesAlreadyInTheTemplate(histogramFactory)
objects = {ObjectSighting({Patch(NaN, Area.fromXYtoXY(3, 3, 4, 4)); Patch(NaN, Area.fromXYtoXY(3, 5, 4, 6))})};
updater = ExpansionTemplateUpdater(ForegroundValidityStrategy(10));

nextFrame = zeros(6);
nextFrame(3:4, 1:2) = [0 255; 255 255];
newHistograms = histogramFactory.buildFromImage(nextFrame);
foreground = ones(6) * -1;
foreground(3:4, 1:6) = 1;

objects = updater.updateTemplate(objects, Frame(foreground), newHistograms, {});
assertEqual([3 1], size(objects{1}.patches));

function testDoesNotExpandTemplateOutOfTheImage(histogramFactory)
objects = {ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))})};
updater = ExpansionTemplateUpdater(ForegroundValidityStrategy(10));

nextFrame = zeros(2);
newHistograms = histogramFactory.buildFromImage(nextFrame);
foreground = ones(2);

objects = updater.updateTemplate(objects, Frame(foreground), newHistograms, {});
assertEqual([1 1], size(objects{1}.patches));

function testExpandsTemplateFollowingFourConnectivity(histogramFactory)
objects = {ObjectSighting({Patch(NaN, Area.fromXYtoXY(3, 3, 4, 4))})};
updater = ExpansionTemplateUpdater(ForegroundValidityStrategy(10));

nextFrame = zeros(6);
newHistograms = histogramFactory.buildFromImage(nextFrame);
foreground = ones(6);

objects = updater.updateTemplate(objects, Frame(foreground), newHistograms, {});
assertEqual([5 1], size(objects{1}.patches));

function testCannotExpandObjectsOverOtherObjects(histogramFactory)
objects = {ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 1, 2, 2))}); ObjectSighting({Patch(NaN, Area.fromXYtoXY(1, 3, 2, 5))})};
updater = ExpansionTemplateUpdater(ForegroundValidityStrategy(10));

nextFrame = zeros(2, 5);
newHistograms = histogramFactory.buildFromImage(nextFrame);
foreground = ones(2, 5);

objects = updater.updateTemplate(objects, Frame(foreground), newHistograms, {});
assertEqual([1 1], size(objects{1}.patches));
assertEqual([1 1], size(objects{2}.patches));
