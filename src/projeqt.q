walkTree:{[parseTree]
  $[
    (:) = parseTree[0]; //if the parse tree function is an assignment
      $[
        1 = count parseTree[2]; //if this is the final assignment
        (enlist parseTree[1])!(enlist parseTree[2]);
        ((enlist parseTree[1])!(enlist parseTree[2;0])),.z.s parseTree[2;1]
      ];
      
    //else
    '"only assignment is allowed in a global context"
  ]
 }

getDeclErrors:{[scope;i;f]
  fv: value f;
  globals: 1 _ fv[3];
  violations: globals where i < (key scope) ? globals;
  subFunctions: {x where 100h = type each x} -5 _ (3 _ fv);
  subViolations: raze .z.s[scope;i] each subFunctions;
  distinct violations, subViolations
 }

analyzeScope:{[scope]
  declErrors: (til count scope) getDeclErrors[scope]' (value scope);
  raze (key scope) {(enlist x)!enlist y}' declErrors
 }

parseFunctionBody:{
  s:string x;
  n: count s;
  i:1+first (string hTree) ss "]";
  parse trim s[i + til n - i + 1]
 }