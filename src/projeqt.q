getScopeFromTree:{[parseTree]
  extractAssignment:{[subTree]
    $[
      (3 = count subTree) & (:) ~ subTree[0];
      ((enlist subTree[1])!(enlist subTree[2]));
      null subTree[0];
      ()!();
      '"unhandled function '", (string subTree[0]), "', or cardinality (", (string count subTree), ") encountered in parse tree element"
    ]
  };

  $[
    ";" ~ parseTree[0];
    raze extractAssignment each -1 _ (1 _ parseTree); //drop the first and last element
    '"unhandled function '", (string parseTree[0]), "' encountered in parse tree root"
  ]
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

getDeclErrorsFromFunction:{[scope;i;f]
  fv: value f;
  globals: {x where isNotInSystemNs each x} 1 _ fv[3];
  violations: globals where i < (key scope) ? globals;
  subFunctions: {x where 100h = type each x} -5 _ (3 _ fv);
  subViolations: raze .z.s[scope;i] each subFunctions;
  distinct violations, subViolations
 };

getDeclErrorsFromGeneralList:{[scope;i;x]
  // TODO - this is currently a way to use yet-to-be-defined variables
  ()
 };

getDeclErrors:{[scope;i;x]
  $[
    100h = type x;
    getDeclErrorsFromFunction[scope;i;x];
    0h = type x;
    getDeclErrorsFromGeneralList[scope;i;x];
    type x in 1h;
    ();
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
  i:1+first (string hTree) ss "]";
  parse trim s[i + til n - i + 1]
 };