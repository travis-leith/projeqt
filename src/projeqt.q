parseWithNamespace:{[codeString]
  parseTree: parse codeString;
  $[
    (2 = count parseTree) & (10h = type parseTree[1]) & 105h = type parseTree[0];
    {$[
      (`d ~ x[1;0]) & ";" ~ x[0];
      `namespace`tree!(enlist x[1;1]), (enlist 2 _ x);
      '"Unhandled system command (\\", string x[1;0], ") encountered in parse tree."
    ]} parse parseTree[1];
    ";" ~ parseTree[0];
    `namespace`tree!(enlist `), (enlist 1 _ parseTree);
    '"All statements in a code file must be separated by ';'."
  ]
 };

prepNs:{[ns;sym]
  $[
    ` = ns;
    sym;
    "." = (string sym)[0];
    sym;
    ` sv (ns,sym)
  ]
 };

getScopeFromTree:{[prse]
  extractAssignment:{[ns;subTree]
    $[
      (3 = count subTree) & (:) ~ subTree[0];
      ((enlist prepNs[ns;subTree[1]])!(enlist ns, enlist subTree[2]));
      null subTree;
      ()!();
      '"unhandled function '", (string subTree[0]), "', or cardinality (", (string count subTree), ") encountered in parse tree element"
    ]
  };

  raze extractAssignment[prse `namespace] each prse `tree
 };

isNotInSystemNs:{
  s:string x;
  $[
    4 > count s;
    1b;
    (s[0] <> ".") | s[2] <> ".";
    1b;
    s[1] in "hjmQz";
    0b;
    1b
  ]
 };

getGlobalsFromFunctionValue:{[fv]
  globalsToIgnore:`sublist`trim`ltrim`rtrim`parse`system;
  {x where isNotInSystemNs each x} (1 _ fv[3]) except globalsToIgnore
 };

getDeclErrorsFromFunction:{[scope;i;ns;f]
  fv: value f;
  globals: `symbol$ prepNs[ns] each getGlobalsFromFunctionValue fv;
  violations: globals where i < (key scope) ? globals;
  subFunctions: {x where 100h = type each x} -5 _ (3 _ fv);
  subViolations: raze .z.s[scope;i;ns] each subFunctions;
  distinct violations, subViolations
 };

getGlobalsFromGeneralList:{
  $[
    -11h = type x;
    enlist x;
    100h = type x;
    getGlobalsFromFunctionValue value x;
    0h = type x;
    raze .z.s each x;
    `symbol$()
  ]
 };

getDeclErrorsFromGeneralList:{[scope;i;ns;x]
  globals: prepNs[ns] each getGlobalsFromGeneralList x;
  distinct globals where i < (key scope) ? globals
 };

getDeclErrors:{[scope;i;x]
  $[
    100h = type x[1];
    getDeclErrorsFromFunction[scope;i;x[0];x[1]];
    0h = type x[1];
    getDeclErrorsFromGeneralList[scope;i;x[0];x[1]];
    20 > abs type x[1];
    `symbol$();
    '"unhandled type (", (string type x), ") encountered when type to get declaration errors"
  ]
 };

analyzeScope:{[scope]
  declErrors: (til count scope) getDeclErrors[scope]' (value scope);
  (key scope)!declErrors
 };

parseFunctionBody:{
  s:string x;
  n: count s;
  i:1+first s ss "]";
  parse trim s[i + til n - i + 1]
 };