\l src/projeqt.q

codeSample : "c"$read1 `$"test/gw_sample/gatewaylib.q"
prse: parseWithNamespace codeSample;
scope : getScopeFromTree prse
analyzeScope scope

codeSample : "c"$read1 `$"test/gw_sample/daqrest.q"
prse: parseWithNamespace codeSample;
scope : getScopeFromTree prse
analyzeScope scope

codeSample : "c"$read1 `$"test/gw_sample/dataaccess.q"
prse: parseWithNamespace codeSample;
scope : getScopeFromTree prse
analyzeScope scope

files:(`$"test/gw_sample/dummy.q"), (`$"test/gw_sample/dataaccess.q"), `$"test/gw_sample/daqrest.q"
codeSamples: {"c"$read1 x} each files
prses: parseWithNamespace each codeSamples
scope: raze getScopeFromTree each prses
analyzeScope scope

codeSample : "c"$read1 `$"src/projeqt.q"
prse: parseWithNamespace codeSample;
scope : getScopeFromTree prse
analyzeScope scope

codeSample : "c"$read1 `$"test/gw_sample/dataaccess2.q"
prse: parseWithNamespace codeSample;
scope : getScopeFromTree prse
analyzeScope scope