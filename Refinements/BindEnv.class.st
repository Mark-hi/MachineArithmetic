Class {
	#name : #BindEnv,
	#superclass : #Object,
	#instVars : [
		'indexDict'
	],
	#category : #Refinements
}

{ #category : #'as yet unclassified' }
BindEnv class >> empty [
	^self new
]

{ #category : #visiting }
BindEnv >> accept: aVisitor [ 
	^self copy 
		indexDict: (indexDict collectAssociations: [ :sym :sr |
			sym ->
			(sr accept: aVisitor) ]);
		yourself
]

{ #category : #'as yet unclassified' }
BindEnv >> bindEnvToList [
	"...for now.  In Smalltalk we can write it much more elegantly.
	Represent the receiver as array of 3-tuples (BindId, Symbol, SortedReft)."
	^indexDict associations collect: [ :ass | {ass key. ass value key. ass value value.} ]
]

{ #category : #compilation }
BindEnv >> compile [
	indexDict := indexDict collect: [ :var_sr |
		| var sr |
		var := var_sr key.
		sr := var_sr value.
		var -> (sr evaluateIn: self evalEnv) ]
]

{ #category : #'as yet unclassified' }
BindEnv >> concretePreds [
	| concreteIndexDict compiledPreds |
	concreteIndexDict := indexDict select: [ :s_r | s_r value sr_reft expr isBool ].
	compiledPreds := concreteIndexDict collect: [ :s_r |
		| r |
		r := s_r value.
		r sr_reft expr ].
	^compiledPreds reject: #isShortExpr
]

{ #category : #'instance creation' }
BindEnv >> copyDictFrom: aBindEnv [ 
	indexDict := aBindEnv indexDict copy
]

{ #category : #'as yet unclassified' }
BindEnv >> cstrDef: aSimpC [
"cstrDef :: F.BindEnv -> F.SimpC a -> Maybe F.Symbol"
	| v rhs e sym |
	v := aSimpC lookupBindIn: self.
	rhs := aSimpC crhs "stripCasts".
	e := rhs isSingletonExpr: v  in: self evalEnv.
	e isNil ifTrue: [ ^nil ].
	e isNamedConstant ifFalse: [ ^nil ].
	sym := e functorName.
	sym = 'true' ifTrue: [ ^nil ].
	sym = 'false' ifTrue: [ ^nil ].
	^sym
]

{ #category : #'as yet unclassified' }
BindEnv >> domain: aWfC [ 
	"answer a collection of variable names"
	^{aWfC rft first},
	 ((self envCs: aWfC env) collect: #key) asArray
]

{ #category : #'as yet unclassified' }
BindEnv >> envCs: anIBindEnv [
	"Answer the collection of Symbol->SortedReft's for all entries in the argument.
	cf. Types/Environments.hs:
	envCs :: BindEnv -> IBindEnv -> [(Symbol, SortedReft)]"
	^anIBindEnv indexes collect: [ :j | indexDict at: j ]
]

{ #category : #'as yet unclassified' }
BindEnv >> envKVars: c [
	"Answer a collection of kvar names."
	^(c clhs: self) collectAndCat: [ :ass |
		| sr |
		sr := ass value.
		sr sr_reft expr kvarsExpr ]
]

{ #category : #compilation }
BindEnv >> evalEnv [
	^EvalEnv ofSorts: self sortDict
]

{ #category : #GT }
BindEnv >> gtInspectorBindsIn: composite [
	<gtInspectorPresentationOrder: 20>
	^ composite fastTable
		title: 'Binds';
		display: [ self indexDict associations ];
			column: 'Index' evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each key ];
		column: 'Bind' evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each value ]
]

{ #category : #accessing }
BindEnv >> indexDict [
	indexDict isNil ifTrue: [indexDict := Dictionary new].
	^ indexDict
]

{ #category : #accessing }
BindEnv >> indexDict: bs [
	indexDict := bs
]

{ #category : #updating }
BindEnv >> insertVar: name sort: s [
	"Instantiate a new BindEnv which is a copy of the receiver grown by
	the association, name->TrueRefinement, at the next index, j.
	Answer the association, j->grownBindEnv."
	| j new |
	j := self indexDict size.
	new := BindEnv new. "horrible :-("
	new copyDictFrom: self.
	new indexDict
		at: j
		put: name -> s trueSortedReft.
	^j -> new
]

{ #category : #accessing }
BindEnv >> lookup: aBindId [
"lookupBindEnv :: BindId -> BindEnv -> (Symbol, SortedReft)
cf. Environments.hs"
	^indexDict at: aBindId 
]

{ #category : #accessing }
BindEnv >> sortDict [
	^self sortedReftsDict collect: #sr_sort
	
]

{ #category : #accessing }
BindEnv >> sortOf: varName [
	^self sortDict at: varName
]

{ #category : #accessing }
BindEnv >> sortedReftsDict [
	^Dictionary newFromAssociations: indexDict values 
	
]

{ #category : #'as yet unclassified' }
BindEnv >> subcKVars: c [
	^(self envKVars: c), c rhsKVars
]

{ #category : #accessing }
BindEnv >> sxEnv [ 
	^Dictionary newFromAssociations: (self bindEnvToList collect: [ :i_x_sr |
				| i x sr |
				i := i_x_sr first.
				x := i_x_sr second.
				sr := i_x_sr third.
				x->(i->sr sr_sort) ])
]

{ #category : #accessing }
BindEnv >> toList [
	"Answer a collection each element of which is of the form {BindId.Symbol.SortedReft.}"
	^indexDict associations collect: [ :ass | { ass key. ass value key. ass value value. } ]
]

{ #category : #'as yet unclassified' }
BindEnv >> withoutIndexes: indexesToReject [
	^self copy instVarNamed: 'indexDict' put: (indexDict withoutKeys: indexesToReject); yourself
]
